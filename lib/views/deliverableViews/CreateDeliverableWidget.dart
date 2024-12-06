import 'package:flutter/material.dart';
import 'package:fromzero_app/api/deliverablesService.dart';
import 'package:fromzero_app/models/create_deliverable_model.dart';

class CreateDeliverableWidget extends StatelessWidget {
  final Function() goBackToDeliverables;
  final int projectId;
  final Function() refreshDeliverables;
  final CreateDeliverableData createDeliverableData=CreateDeliverableData();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  CreateDeliverableWidget({
    super.key,
    required this.refreshDeliverables,
    required this.projectId,
    required this.goBackToDeliverables
  });

  Future<void> createDeliverable(BuildContext context,CreateDeliverableData data)async{

    var service = DeliverablesService();
    final response = await service.createDeliverable(data);
    if(response.statusCode==201){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Entregable creado")
        )
      );
      await refreshDeliverables.call();
      goBackToDeliverables.call();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Error")
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(60),
        child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Nombre del entregable"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 80),
                TextFormField(
                  controller: descController,
                  decoration: InputDecoration(labelText: "Descripcion del entregable"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Este campo es obligatorio";
                    }
                    return null;
                  },
                  maxLines: null,
                ),
                SizedBox(height: 80),
                DatePickerWidget(
                  context: context,
                  updateDeadline:(DateTime deadline){
                    createDeliverableData.date=deadline;
                  }
                ),
                SizedBox(height: 80),
                ElevatedButton(
                  child: Text("Crear Entregable"),
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No valido")));
                      return;
                    }
                    //Post de entregable
                    createDeliverableData.name=nameController.text;
                    createDeliverableData.description=descController.text;
                    createDeliverableData.projectId=projectId;

                    createDeliverable(context,createDeliverableData);

                  },
                )
              ],
            )),
      ),
    );
  }
}

class DatePickerWidget extends StatefulWidget {
  final BuildContext context;
  final Function(DateTime) updateDeadline;
  const DatePickerWidget({
    super.key,
    required this.context,
    required this.updateDeadline
  });

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? deadline;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        ElevatedButton(
          child: Text(
            "Seleccione fecha limite para este entregable",
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            selectDeadline();
          },
        ),
        deadline != null ? Text("Fecha límite de entrega: " + deadline!.toIso8601String().split('T').first) : Container()
      ],
    ));
  }

  Future<void> selectDeadline() async {
    final DateTime? selected =
        await showDatePicker(context: widget.context, initialDate: DateTime.now(), firstDate: DateTime(2023), lastDate: DateTime(2050));
    if (selected != null) {
      setState(() {
        deadline = selected;
        if(deadline!=null) {
          widget.updateDeadline.call(deadline!);
        }
      });
    }
  }
}
