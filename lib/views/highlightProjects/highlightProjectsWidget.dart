import 'package:flutter/material.dart';
import 'package:fromzero_app/api/projectsService.dart';
import 'package:fromzero_app/views/highlightProjects/completedProjectDetails.dart';
import '../../models/project_model.dart';

class HighlightProjects extends StatefulWidget {
  const HighlightProjects({super.key});

  @override
  State<HighlightProjects> createState() => _HighlightProjectsState();
}

class _HighlightProjectsState extends State<HighlightProjects> {
  List<Project> filteredProjects = [];
  List<Project> projects = [];

  Future<void> fetchProjects() async {
    try {
      var service = ProjectsService();
      List<Project> response = await service.getAllProjectsByState("COMPLETADO");
      setState(() {
        filteredProjects = response;
        projects = filteredProjects;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  void filterByProjectType(String type) {
    if (type != "") {
      setState(() {
        filteredProjects = projects.where((project) => project.type == type).toList();
      });
    } else {
      setState(() {
        filteredProjects = projects;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4.0,
              alignment: WrapAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    filterByProjectType("WEB_APPLICATION");
                  },
                  child: Text("Aplicación web"),
                ),
                TextButton(
                  onPressed: () {
                    filterByProjectType("MOBILE_APPLICATION");
                  },
                  child: Text("Aplicación móvil"),
                ),
                TextButton(
                  onPressed: () {
                    filterByProjectType("LANDING_PAGE");
                  },
                  child: Text("Landing Page"),
                ),
                TextButton(
                  onPressed: () {
                    filterByProjectType("DESKTOP_APPLICATION");
                  },
                  child: Text("Aplicación de escritorio"),
                ),
                TextButton(
                  onPressed: () {
                    filterByProjectType("");
                  },
                  child: Text("Borrar filtros"),
                ),
              ],
            ),
            Expanded(
              child: filteredProjects.isNotEmpty
                  ? ListView.builder(
                itemCount: filteredProjects.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        filteredProjects[index].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filteredProjects[index].type,
                            textAlign: TextAlign.center,
                          ),
                          Text(filteredProjects[index].description),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CompletedProjectDetails(
                              project: filteredProjects[index],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
                  : Center(
                child: Text(
                  "Aún no hay proyectos completados",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "refresh_finished_projects",
        onPressed: () {
          fetchProjects();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}