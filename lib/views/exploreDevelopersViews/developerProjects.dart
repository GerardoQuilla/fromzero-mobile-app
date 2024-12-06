import 'package:flutter/material.dart';
import 'package:fromzero_app/api/projectsService.dart';
import 'package:fromzero_app/models/project_model.dart';

class DeveloperProjectsScreen extends StatefulWidget {
  final String developerId;

  const DeveloperProjectsScreen({super.key, required this.developerId});

  @override
  State<DeveloperProjectsScreen> createState() =>
      _DeveloperProjectsScreenState();
}

class _DeveloperProjectsScreenState extends State<DeveloperProjectsScreen> {
  List<Project> projects = [];

  @override
  void initState() {
    super.initState();
    fetchProjects();
  }

  Future<void> fetchProjects() async {
    var service = ProjectsService();
    final response =
        await service.getProjectsByDeveloperIdV2(widget.developerId);
    setState(() {
      projects =
          response.where((project) => project.state == "COMPLETADO").toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.black,
        title: const Text('Proyectos'),
        elevation: 0,
      ),
      body: projects.isEmpty
          ? const Center(
              child: Text(
                "Este desarrollador aún no ha completado proyectos en esta plataforma",
                textAlign: TextAlign.center
              ))
          : ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      projects[index].name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text('Estado: ${projects[index].state}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProjectDetailScreen(project: projects[index]),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'Ver detalles',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({Key? key, required this.project})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(project.name),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              project.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text("Lenguajes de programación utilizados"),
            Expanded(
                child: ListView.builder(
                    itemCount: project.languages.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text("${project.languages[index]}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    })),
            const SizedBox(height: 8),
            Text("Frameworks utilizados"),
            Expanded(
                child: ListView.builder(
                    itemCount: project.frameworks.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text("${project.frameworks[index]}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      );
                    })),
            const SizedBox(height: 8),
            Text(
              'Presupuesto: ${project.budget}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  'Regresar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
