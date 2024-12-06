import 'dart:convert';
import 'package:fromzero_app/api/baseUrl.dart';
import 'package:fromzero_app/models/create_project_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/project_model.dart';

class ProjectsService{
  static const String url = "${BaseUrlApi.url}/projects";

  Future<http.Response> createProject(CreateProjectData data)async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String companyId = prefs.getString("profileId")??"";
      String token = prefs.getString("token")??"";
      final response = await http.post(
        Uri.parse("$url"),
        body: jsonEncode({
          'name':data.name,
          'description':data.description,
          'ownerId':companyId,
          //'languages':data.languages,
          'languages':data.languages.map((e)=>e.name).toList(),
          //'frameworks':data.frameworks,
          'frameworks':data.frameworks.map((e)=>e.name).toList(),
          'type':data.type.name,
          'budget':data.budget,
          'currency':data.currency.name,
          'methodologies':data.methodologies.map((e)=>e.toJson()).toList()
        }),
        headers: {
          'Content-Type':'application/json',
          'Authorization':'Bearer $token'
        }
      );
      return response;
    }catch(e){
      throw Exception("Error al publicar proyecto. $e");
    }
  }

  Future<List<Project>> getAllProjectsByState(String projectState)async{
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")??"";
      final response = await http.get(
          Uri.parse("$url/by-state?state=$projectState"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
      );
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data)=>
          Project.fromJson(data))
          .toList();
    }catch(e){
      throw Exception("Error al obtener proyectos. $e");
    }

  }

  Future<http.Response> applyToProject(int projectId)async{
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String developerId = prefs.getString("profileId")??"";
      String token = prefs.getString("token")??"";
      final response = await http.patch(
          Uri.parse('$url/$projectId/add-candidate'),
          body: jsonEncode({
            'developerId':developerId
          }),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
      );
      return response;
    }catch(e){
      throw Exception("Error al obtener proyectos. $e");
    }
  }

  Future<http.Response> setDeveloperToProject(int projectId,String developerId, bool accepted)async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")??"";

      final response = await http.patch(
        Uri.parse("$url/$projectId/set-developer"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'developerId':developerId,
          'accepted':accepted
        })
      );
      return response;
    }catch(e){
      throw Exception("$e");
    }
  }

  Future<List<Project>> getProjectsByCompanyId()async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String companyId = prefs.getString("profileId")??"";
      String token = prefs.getString("token")??"";
      final response = await http.get(
        Uri.parse("$url/company/$companyId"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
      );
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data)=>
          Project.fromJson(data))
          .toList();
    }catch(e){
      throw Exception("Error al obtener proyectos. $e");
    }
  }

  Future<List<Project>> getProjectsByDeveloperId()async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String developerId = prefs.getString("profileId")??"";
      String token = prefs.getString("token")??"";
      final response = await http.get(
          Uri.parse("$url/developer/$developerId"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
      );
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data)=>
          Project.fromJson(data))
          .toList();
    }catch(e){
      throw Exception("Error al obtener proyectos$e");
    }
  }

  Future<List<Project>> getProjectsByDeveloperIdV2(String developerId)async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")??"";
      final response = await http.get(
          Uri.parse("$url/developer/$developerId"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
      );
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data)=>
          Project.fromJson(data))
          .toList();
    }catch(e){
      throw Exception("Error al obtener proyectos$e");
    }
  }

}