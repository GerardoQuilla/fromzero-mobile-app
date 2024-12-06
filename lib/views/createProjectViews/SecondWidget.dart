import 'package:flutter/material.dart';
import 'package:fromzero_app/models/create_project_model.dart';

class ProjectTechnologiesWidget extends StatelessWidget {
  final CreateProjectData projectData;

  final Function(CreateProjectData) onUpdatedProjectData;
  final Function(int) onUpdateSection;

  const ProjectTechnologiesWidget(
      {super.key,
      required this.projectData,
      required this.onUpdatedProjectData,
      required this.onUpdateSection});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Lenguajes de programación",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            LanguagesWidget(
              onLanguageSelected: (Languages? addLanguage) {
                if (!projectData.languages.contains(addLanguage)) {
                  projectData.languages.add(addLanguage!);
                }
              },
              onLanguageDeleted: (Languages value) {
                projectData.languages.remove(value);
              },
              currentLanguagesList: projectData.languages,
            ),
          ],
        ),
        const SizedBox(height: 80),
        Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Frameworks",
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            FrameworksWidget(
              onFrameworkSelected: (Frameworks? addFramework) {
                if (!projectData.frameworks.contains(addFramework)) {
                  projectData.frameworks.add(addFramework!);
                }
              },
              onFrameworkDeleted: (Frameworks value) {
                projectData.frameworks.remove(value);
              },
              currentFrameworksList: projectData.frameworks,
            ),
          ],
        ),
        const SizedBox(height: 80),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Siguiente",
                  style: TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: () {
                onUpdatedProjectData(projectData);
                onUpdateSection(3);
              }),
        )
      ],
    );
  }
}

class LanguagesWidget extends StatefulWidget {
  final ValueChanged<Languages?> onLanguageSelected;
  final Function(Languages) onLanguageDeleted;
  final List<Languages> currentLanguagesList;

  const LanguagesWidget({
    super.key,
    required this.currentLanguagesList,
    required this.onLanguageSelected,
    required this.onLanguageDeleted
  });

  @override
  State<LanguagesWidget> createState() => _LanguagesWidgetState();
}

class _LanguagesWidgetState extends State<LanguagesWidget> {
  Languages? _language;
  List<Languages> languagesList = [];

  @override
  Widget build(BuildContext context) {
    languagesList = widget.currentLanguagesList;
    return Column(children: [
      DropdownButton(
          menuMaxHeight: 150,
          hint: Text("Selecciona un lenguaje"),
          underline: Container(
            height: 2,
            color: Colors.black,
          ),
          items: Languages.values
              .map<DropdownMenuItem<Languages>>((Languages value) {
            return DropdownMenuItem<Languages>(
              value: value,
              child: Text(value.name),
            );
          }).toList(),
          onChanged: (Languages? value) {
            setState(() {
              this._language = value;
              languagesList.add(value!);
            });
            widget.onLanguageSelected(value);
          }),
      Container(
        child: Column(
          children: languagesList.map((language) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  language.name,
                  style: TextStyle(fontSize: 25),
                ),
                IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        languagesList.remove(language);
                      });
                      widget.onLanguageDeleted(language);
                    })
              ],
            );
          }).toList(),
        ),
      )
    ]);
  }
}

class FrameworksWidget extends StatefulWidget {
  final ValueChanged<Frameworks?> onFrameworkSelected;
  final Function(Frameworks) onFrameworkDeleted;
  final List<Frameworks> currentFrameworksList;

  const FrameworksWidget({
    super.key,
    required this.currentFrameworksList,
    required this.onFrameworkSelected,
    required this.onFrameworkDeleted
  });

  @override
  State<FrameworksWidget> createState() => _FrameworksWidgetState();
}

class _FrameworksWidgetState extends State<FrameworksWidget> {
  Frameworks? _framework;
  List<Frameworks> frameworksList = [];

  @override
  Widget build(BuildContext context) {
    frameworksList = widget.currentFrameworksList;
    return Column(
      children: [
        DropdownButton(
            menuMaxHeight: 150,
            hint: Text("Selecciona un framework"),
            underline: Container(
              height: 2,
              color: Colors.black,
            ),
            items: Frameworks.values
                .map<DropdownMenuItem<Frameworks>>((Frameworks value) {
              return DropdownMenuItem<Frameworks>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
            onChanged: (Frameworks? value) {
              setState(() {
                this._framework = value;
                frameworksList.add(value!);
              });
              widget.onFrameworkSelected(value);
            }),
        Container(
          child: Column(
            children: frameworksList.map((framework) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    framework.name,
                    style: TextStyle(fontSize: 25),
                  ),
                  IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          frameworksList.remove(framework);
                        });
                        widget.onFrameworkDeleted(framework);
                      })
                ],
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
