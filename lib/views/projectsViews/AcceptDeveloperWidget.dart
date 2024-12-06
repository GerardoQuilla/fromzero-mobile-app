import 'package:flutter/material.dart';
import 'package:fromzero_app/api/profilesService.dart';
import 'package:fromzero_app/api/projectsService.dart';
import '../../models/developer_model.dart';
import 'package:fromzero_app/views/exploreDevelopersViews/previewDevelopers.dart';
import 'package:fromzero_app/models/company_model.dart';

class AcceptDeveloperWidget extends StatefulWidget {
  final Function() refreshProjects;
  final List<dynamic> candidates;
  final int projectId;
  final Company currentUser;

  const AcceptDeveloperWidget({
    super.key,
    required this.candidates,
    required this.projectId,
    required this.refreshProjects,
    required this.currentUser,
  });

  @override
  State<AcceptDeveloperWidget> createState() => _AcceptDeveloperWidgetState();
}

class _AcceptDeveloperWidgetState extends State<AcceptDeveloperWidget> {
  List<Developer> developers = [];

  Future<void> fetchCandidates() async {
    var service = ProfilesService();

    for (var profileId in widget.candidates) {
      final response = await service.getDeveloper(profileId);
      setState(() {
        developers.add(response);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCandidates();
  }

  Future<void> acceptDeveloper(BuildContext context, String developerId, bool accepted) async {
    var service = ProjectsService();
    final response = await service.setDeveloperToProject(
      widget.projectId,
      developerId,
      accepted,
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lista de candidatos actualizada")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Postulantes del proyecto"),
      ),
      body: developers.isNotEmpty
          ? ListView.builder(
        itemCount: developers.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(8),
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(developers[index].profileImgUrl),
              ),
              title: Text(
                developers[index].firstName + " " + developers[index].lastName,
                textAlign: TextAlign.center,
              ),
              subtitle: Column(
                children: [
                  Text(developers[index].description),
                  Text(developers[index].specialties),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await acceptDeveloper(
                            context,
                            developers[index].profileId,
                            true,
                          );
                          await widget.refreshProjects.call();
                          Navigator.pop(context);
                        },
                        child: Text("Aceptar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await acceptDeveloper(
                            context,
                            developers[index].profileId,
                            false,
                          );
                          await widget.refreshProjects.call();
                          Navigator.pop(context);
                        },
                        child: Text("Rechazar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewDeveloper(
                      developer: developers[index],
                      currentUser: widget.currentUser,
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
          "Aún no hay postulantes a este proyecto",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}