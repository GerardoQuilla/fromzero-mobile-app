import 'package:flutter/material.dart';
import 'package:fromzero_app/api/projectsService.dart';
import 'package:fromzero_app/views/applyToProjectViews/ProjectDetails.dart';

import '../../models/project_model.dart';

class ApplyToProjects extends StatefulWidget {
  const ApplyToProjects({super.key});

  @override
  State<ApplyToProjects> createState() => _ApplyToProjectsState();
}

class _ApplyToProjectsState extends State<ApplyToProjects> {
  List<Project> projectsList = [];

  Future<void> _fetchProjects() async{
    var service = ProjectsService();
    final response = await service.getAllProjectsByState("EN_BUSQUEDA");
    if(mounted) {
      setState(() {
        projectsList = response;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: ,
        body: Center(
          child: projectsList.isNotEmpty?ListView.builder(
              itemCount: projectsList.length,
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  title: Text(
                    projectsList[index].name,
                    textAlign: TextAlign.center
                  ),
                  subtitle: Column(
                    children: [
                      Text(projectsList[index].type),
                      ElevatedButton(
                        child: Text("Ver detalles"),
                        onPressed: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context)=>
                                      ProjectDetails(
                                        project: projectsList[index],
                                      )
                              )
                          );
                        },
                      )
                    ],
                  ),
                );
              }
          ):Text("Aún no se han publicados proyectos."),
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
          backgroundColor: Colors.lightBlueAccent,
          onPressed: (){
              _fetchProjects();
          }
      ),
    );
  }
}

