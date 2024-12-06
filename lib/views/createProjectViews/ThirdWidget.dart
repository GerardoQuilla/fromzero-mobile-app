import 'package:flutter/material.dart';
import 'package:fromzero_app/models/create_project_model.dart';

class MethodologiesWidget extends StatefulWidget {
  final CreateProjectData projectData;
  final Function(CreateProjectData) onUpdatedProjectData;
  final Function(int) onUpdateSection;

  const MethodologiesWidget(
      {super.key,
      required this.projectData,
      required this.onUpdatedProjectData,
      required this.onUpdateSection});

  @override
  State<MethodologiesWidget> createState() => _MethodologiesWidgetState();
}

class _MethodologiesWidgetState extends State<MethodologiesWidget> {
  bool defaultMethodologies = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (!defaultMethodologies)
              Expanded(
                  child: Text(
                "Ingresa metodologias",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              )),
            Expanded(
                child: Column(
              children: [
                Text(
                  "Elegir metodologías por defecto",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                Switch(
                    value: defaultMethodologies,
                    onChanged: (value) {
                      setState(() {
                        defaultMethodologies = value;
                        if (value == true) {
                          widget.projectData.methodologies = [];
                        }
                      });
                    })
              ],
            ))
          ],
        ),
        Container(
          child: defaultMethodologies
              ? Container(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "Metodologías por defecto",
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          "Se elegirán entregables por defecto en base al tipo de proyecto que eligió.",
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                )
              : SetMethodologiesWidget(
                  onAddMethodology: (String name, String description) {
                    widget.projectData.methodologies
                        .add(MethodologyResource(name, description));
                  },
                ),
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Siguiente",
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: () {
                widget.onUpdatedProjectData(widget.projectData);
                widget.onUpdateSection(4);
              }),
        )
      ],
    );
  }
}

class SetMethodologiesWidget extends StatefulWidget {
  final Function(String, String) onAddMethodology;

  const SetMethodologiesWidget({super.key, required this.onAddMethodology});

  @override
  State<SetMethodologiesWidget> createState() => _SetMethodologiesWidgetState();
}

class _SetMethodologiesWidgetState extends State<SetMethodologiesWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Column(
          children: [
            Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nombre de entregable",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(),
                  keyboardType: TextInputType.text,
                )
              ],
            ),
            Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Descripcion de entregable",
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(),
                  maxLines: null,
                )
              ],
            ),
          ],
        ),
      ),
      SizedBox(
          width: 60,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue, shape: BoxShape.circle),
              child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    if (nameController.text != "" &&
                        descController.text != "") {
                      widget.onAddMethodology(
                          nameController.text, descController.text);
                      nameController.text = "";
                      descController.text = "";
                    }
                  })))
    ]);
  }
}
