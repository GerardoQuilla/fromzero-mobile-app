import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/projectsService.dart';
import '../../models/project_model.dart';
import 'AcceptDeveloperWidget.dart';
import '../deliverableViews/DeliverablesWidget.dart';
import '../../models/company_model.dart';
import '../../api/profilesService.dart';

class ProjectsList extends StatefulWidget {
  const ProjectsList({super.key});

  @override
  State<ProjectsList> createState() => _ProjectsListState();
}

class _ProjectsListState extends State<ProjectsList> {
  String role = "";
  List<Project> projectList = [];

  Future<void> _fetchProjects() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      role = prefs.getString("role") ?? "";
      var service = ProjectsService();
      if (role == "COMPANY") {
        final response = await service.getProjectsByCompanyId();
        setState(() {
          projectList = response;
        });
      } else if (role == "DEVELOPER") {
        final response = await service.getProjectsByDeveloperId();
        setState(() {
          projectList = response;
        });
      } else {
        throw Exception("Unknown role");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  void checkDeliverables(BuildContext context, int projectId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliverablesSchedule(
          refreshProjects: _fetchProjects,
          projectId: projectId,
          role: role,
        ),
      ),
    );
  }

  void checkDevelopers(BuildContext context, int projectId, List<dynamic> candidates) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profileId = prefs.getString("profileId") ?? "";
    var service = ProfilesService();
    Company currentUser = await service.getCompany(profileId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcceptDeveloperWidget(
          projectId: projectId,
          candidates: candidates,
          refreshProjects: _fetchProjects,
          currentUser: currentUser,
        ),
      ),
    );
  }

  ListView _listProjects() {
    return ListView.builder(
      itemCount: projectList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ListTile(
            title: Text(
              projectList[index].name,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(projectList[index].description),
                const SizedBox(height: 10),
                if (role == "COMPANY" && projectList[index].developerId == "")
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      checkDevelopers(
                        context,
                        projectList[index].id,
                        projectList[index].candidates,
                      );
                    },
                    child: Text("Ver Candidatos"),
                  )
                else
                  Text("Progreso: ${projectList[index].progress.toStringAsFixed(2)}%"),
              ],
            ),
            trailing: Icon(Icons.arrow_forward_ios),
            tileColor: Colors.grey[300],
            onTap: () {
              checkDeliverables(context, projectList[index].id);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tus Proyectos",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: projectList.isNotEmpty ? _listProjects() : emptyProjects(),
      floatingActionButton: FloatingActionButton(
        heroTag: "refresh_available_projects",
        child: Icon(Icons.refresh),
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          _fetchProjects();
        },
      ),
    );
  }

  ListView emptyProjects() {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text("No projects available"),
        );
      },
    );
  }
}