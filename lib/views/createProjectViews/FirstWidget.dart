import 'package:flutter/material.dart';
import 'package:fromzero_app/models/create_project_model.dart';

class ProjectDetailsWidget extends StatelessWidget {
  final CreateProjectData projectData;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();

  final Function(CreateProjectData) onUpdatedProjectData;
  final Function(int) onUpdateSection;

  ProjectDetailsWidget(
      {super.key,
      required this.projectData,
      required this.onUpdatedProjectData,
      required this.onUpdateSection});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Nombre del proyecto",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(),
            keyboardType: TextInputType.text,
          )
        ]),
        const SizedBox(height: 40),
        Column(children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Descripcion del proyecto",
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          TextFormField(
            controller: descController,
            decoration: const InputDecoration(),
            maxLines: null,
          )
        ]),
        const SizedBox(height: 40),
        Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Presupuesto del proyecto",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 200,
                  //Expanded(
                  child: TextFormField(
                    controller: budgetController,
                    decoration: const InputDecoration(),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                BudgetCurrencyWidget(onCurrencyChanged: (Currency? value) {
                  projectData.currency = value!;
                })
              ],
            )
          ],
        ),
        const SizedBox(height: 40),
        ProjectTypeWidget(
          onTypeChanged: (ProjectType? newType) {
            projectData.type = newType!;
          },
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Siguiente",
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: () {
                projectData.name = nameController.text;
                projectData.description = descController.text;
                double? parsedBudget = double.tryParse(budgetController.text);
                if (parsedBudget == null ||
                    projectData.name == "" ||
                    projectData.description == "") {
                  return;
                }
                projectData.budget = parsedBudget;
                onUpdatedProjectData(projectData);
                onUpdateSection(2);
              }),
        )
      ],
    );
  }
}

class BudgetCurrencyWidget extends StatefulWidget {
  final ValueChanged<Currency?> onCurrencyChanged;

  const BudgetCurrencyWidget({super.key, required this.onCurrencyChanged});

  @override
  State<BudgetCurrencyWidget> createState() => _BudgetCurrencyWidgetState();
}

class _BudgetCurrencyWidgetState extends State<BudgetCurrencyWidget> {
  Currency? _currency = Currency.PEN;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: _currency,
        items:
            Currency.values.map<DropdownMenuItem<Currency>>((Currency value) {
          return DropdownMenuItem<Currency>(
            value: value,
            child: Text(value.name),
          );
        }).toList(),
        onChanged: (Currency? value) {
          setState(() {
            _currency = value;
          });
          widget.onCurrencyChanged(value);
        });
  }
}

class ProjectTypeWidget extends StatefulWidget {
  final ValueChanged<ProjectType?> onTypeChanged;

  const ProjectTypeWidget({super.key, required this.onTypeChanged});

  @override
  State<ProjectTypeWidget> createState() => _ProjectTypeWidgetState();
}

class _ProjectTypeWidgetState extends State<ProjectTypeWidget> {
  ProjectType? _type = ProjectType.LANDING_PAGE;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text("Tipo de proyecto", style: TextStyle(fontSize: 20.0)),
        ),
        RadioListTile(
            title: const Text("Landing Page"),
            value: ProjectType.LANDING_PAGE,
            groupValue: _type,
            onChanged: (ProjectType? value) {
              setState(() {
                _type = value;
              });
              widget.onTypeChanged(value);
            }),
        RadioListTile(
            title: const Text("Aplicación Web"),
            value: ProjectType.WEB_APPLICATION,
            groupValue: _type,
            onChanged: (ProjectType? value) {
              setState(() {
                _type = value;
              });
              widget.onTypeChanged(value);
            }),
        RadioListTile(
            title: const Text("Aplicación de Escritorio"),
            value: ProjectType.DESKTOP_APPLICATION,
            groupValue: _type,
            onChanged: (ProjectType? value) {
              setState(() {
                _type = value;
              });
              widget.onTypeChanged(value);
            }),
        RadioListTile(
            title: const Text("Aplicación Móvil"),
            value: ProjectType.MOBILE_APPLICATION,
            groupValue: _type,
            onChanged: (ProjectType? value) {
              setState(() {
                _type = value;
              });
              widget.onTypeChanged(value);
            })
      ],
    );
  }
}
