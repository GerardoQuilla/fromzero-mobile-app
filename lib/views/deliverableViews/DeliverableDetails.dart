import 'package:flutter/material.dart';
import 'package:fromzero_app/api/deliverablesService.dart';
import 'package:fromzero_app/models/deliverable_model.dart';

class DeliverableDetailsWidget extends StatelessWidget {
  final Deliverable deliverable;
  final Function() goBackToDeliverables;
  final String role;
  final Function() refreshDeliverables;
  final TextEditingController _controller = TextEditingController();

  DeliverableDetailsWidget({
    super.key,
    required this.deliverable,
    required this.goBackToDeliverables,
    required this.role,
    required this.refreshDeliverables
  });

  Future<void> sendDeliverable(BuildContext context) async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("El comentario no puede estar vacío")),
      );
      return;
    }

    var service = DeliverablesService();
    final response = await service.sendDeliverable(
        deliverable.id,
        _controller.text
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Entregable enviado a revisión"))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ocurrió un error"))
      );
    }
  }

  Future<void> reviewDeliverable(BuildContext context, bool accept) async {
    var service = DeliverablesService();
    final response = await service.reviewDeliverable(
        deliverable.id,
        accept
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Entregable revisado"))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ocurrió un error"))
      );
    }
  }

  Widget developerMessageWidget(BuildContext context) {
    if (role == "COMPANY") {
      return Column(
        children: [
          Text("Entrega del desarrollador", style: TextStyle(fontSize: 20)),
          deliverable.developerMessage != ""
              ? Text(this.deliverable.developerMessage!, style: TextStyle(fontSize: 20))
              : Text("Aún no se ha enviado el entregable"),
          (deliverable.state == "COMPLETADO" || deliverable.developerMessage == "")
              ? Container()
              : Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text("Rechazar", style: TextStyle(fontSize: 20, color: Colors.black)),
                  onPressed: () async {
                    await reviewDeliverable(context, false);
                    await refreshDeliverables.call();
                    goBackToDeliverables();
                  },
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text("Aceptar", style: TextStyle(fontSize: 20, color: Colors.black)),
                  onPressed: () async {
                    await reviewDeliverable(context, true);
                    await refreshDeliverables.call();
                    goBackToDeliverables();
                  },
                ),
              ),
            ],
          )
        ],
      );
    } else if (role == "DEVELOPER") {
      return deliverable.state != "COMPLETADO"
          ? Column(
        children: [
          Text("Ingresar comentarios", style: TextStyle(fontSize: 20)),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            maxLines: null,
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Enviar entregable"),
                      content: Text("¿Desea enviar este entregable a revisión?"),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              await sendDeliverable(context);
                              Navigator.of(context).pop();
                              await refreshDeliverables();
                              goBackToDeliverables();
                            },
                            child: Text("Enviar")
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancelar")
                        ),
                      ],
                    );
                  }
              );
            },
            child: Text("Enviar"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: TextStyle(fontSize: 16),
            ),
          )
        ],
      )
          : Container();
    } else return Placeholder();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            Text(this.deliverable.name, style: TextStyle(fontSize: 20)),
            Text("Fecha de entrega: " + this.deliverable.date, style: TextStyle(fontSize: 20)),
            Text("Estado: " + this.deliverable.state, style: TextStyle(fontSize: 20)),
            Text("Descripción", style: TextStyle(fontSize: 20)),
            Text(this.deliverable.description, style: TextStyle(fontSize: 20)),
            developerMessageWidget(context)
          ],
        )
    );
  }
}