import 'package:flutter/material.dart';
import 'package:fromzero_app/api/projectsService.dart';
import 'package:fromzero_app/models/project_model.dart';

class ProjectDetails extends StatelessWidget {
  final Project project;

  const ProjectDetails({super.key, required this.project});

  Future<void> apply(BuildContext context)async{
    final service = ProjectsService();
    final response = await service.applyToProject(project.id);
    if(response.statusCode==200){
      ScaffoldMessenger.of(context)
          .showSnackBar(
          SnackBar(
              content: Text("Has postulado al proyecto")
          )
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles del proyecto"),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(project.name),
            Text("Descripción"),
            Text(project.description),
            Text("Presupuesto: ${project.budget}"),
            Text("Tecnologías"),
            Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: project.languages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          project.languages[index],
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: project.frameworks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          project.frameworks[index],
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              child: Text("Postular"),
              onPressed: () {
                apply(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
