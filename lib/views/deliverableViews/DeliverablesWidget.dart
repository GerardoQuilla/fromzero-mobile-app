import 'package:flutter/material.dart';
import 'package:fromzero_app/api/deliverablesService.dart';
import 'package:fromzero_app/models/deliverable_model.dart';
import 'CreateDeliverableWidget.dart';
import 'DeliverableDetails.dart';

class DeliverablesSchedule extends StatefulWidget {
  final Function() refreshProjects;
  final int projectId;
  final String role;
  const DeliverablesSchedule({
    super.key,
    required this.projectId,
    required this.role,
    required this.refreshProjects
  });

  @override
  State<DeliverablesSchedule> createState() => _DeliverablesScheduleState();
}

class _DeliverablesScheduleState extends State<DeliverablesSchedule> {
  List<Deliverable> deliverablesList=[];
  int currentSection = 1;
  late Deliverable deliverable;

  Future<void> fetchDeliverables()async{
    final service = DeliverablesService();
    final response = await service.getDeliverablesByProjectId(widget.projectId);
    setState(() {
      deliverablesList=response;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDeliverables();
  }

  Widget currentWidget() {
    switch(currentSection){
      case 1:
        return ListDeliverablesWidget(
          deliverables: deliverablesList,
          onUpdatedDeliverable: (Deliverable newValue) {
            setState(() {
              deliverable = newValue;
              currentSection = 2;
            });
          },
        );
      case 2:
        return DeliverableDetailsWidget(
          refreshDeliverables: fetchDeliverables,
          role: widget.role,
          deliverable: deliverable,
          goBackToDeliverables: () {
            setState(() {
              currentSection = 1;
            });
          },
        );

      case 3:
        return CreateDeliverableWidget(
          refreshDeliverables: fetchDeliverables,
          projectId: widget.projectId,
          goBackToDeliverables:(){
            setState(() {
              currentSection=1;
            });
          }
        );

      default:
        return Container();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Cronograma de entregables",
            style: TextStyle(fontSize: 20),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: ()async{
              await widget.refreshProjects.call();
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.lightBlue,
          toolbarHeight: 100,
          bottom: currentSection == 2 || currentSection == 3
              ? PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, bottom: 8),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: ()async {
                              await fetchDeliverables();
                              setState(() {
                                currentSection = 1;
                              });
                            },
                          ),
                          Text(
                            "Volver",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                    ),
                  ))
              : null,
        ),
        body: currentWidget(),
        floatingActionButton: currentSection == 1 && widget.role == "COMPANY"
            ? FloatingActionButton(
            child: Icon(Icons.add, size: 40, color: Colors.green),
            onPressed: (){
              setState(() {
                currentSection = 3;
              });
            }
        ) : null
    );
  }
}

class ListDeliverablesWidget extends StatefulWidget {
  final Function(Deliverable) onUpdatedDeliverable;
  final List<Deliverable> deliverables;
  const ListDeliverablesWidget({super.key, required this.onUpdatedDeliverable, required this.deliverables});

  @override
  State<ListDeliverablesWidget> createState() => _ListDeliverablesWidgetState();
}

class _ListDeliverablesWidgetState extends State<ListDeliverablesWidget> {
  Color deliverableState(Deliverable value) {
    if (value.state == "PENDIENTE") {
      return Colors.yellow;
    } else if (value.state == "ESPERANDO_REVISION") {
      return Colors.orange;
    } else if (value.state == "RECHAZADO") {
      return Colors.red;
    } else if (value.state == "COMPLETADO") {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(30),
        child: ListView(
          children: widget.deliverables.map<Widget>((Deliverable value) {
            return ListTile(
              leading: Icon(
                Icons.circle,
                color: deliverableState(value),
              ),
              title: Text(value.name, style: TextStyle(fontSize: 20)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value.date.toString(), style: TextStyle(fontSize: 20)),
                  Text("Estado: " + value.state, style: TextStyle(fontSize: 20))
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: () {
                widget.onUpdatedDeliverable(value);
              },
            );
          }).toList(),
        ));
  }
}
