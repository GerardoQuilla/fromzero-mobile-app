import 'dart:convert';
import 'package:fromzero_app/models/create_deliverable_model.dart';
import 'package:fromzero_app/models/deliverable_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseUrl.dart';

class DeliverablesService{
  static const String url = "${BaseUrlApi.url}/deliverables";

  Future<http.Response> createDeliverable(CreateDeliverableData data)async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")??"";
      final response = await http.post(
        Uri.parse("$url"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'name':data.name,
          'description':data.description,
          'date':data.date.toIso8601String().split('T').first,
          'projectId':data.projectId
        })
      );
      return response;
    }catch(e){
      throw Exception("$e");
    }
  }

  Future<List<Deliverable>> getDeliverablesByProjectId(int projectId)async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")??"";
      
      final response = await http.get(
        Uri.parse("$url/project/$projectId"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
      );
      final List<dynamic> jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      return jsonData.map((data)=>
          Deliverable.fromJson(data))
          .toList();
    }catch(e){
      throw Exception("$e");
    }
  }

  Future<http.Response> sendDeliverable(int deliverableId,String message)async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")??"";

      final response = await http.patch(
        Uri.parse("$url/$deliverableId/send"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'developerMessage':message
        })
      );
      return response;
    }catch(e){
      throw Exception("$e");
    }
  }

  Future<http.Response> reviewDeliverable(int deliverableId, bool accept)async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")??"";

      final response = await http.patch(
        Uri.parse("$url/$deliverableId/review"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          "accepted":accept
        })
      );
      return response;
    }catch(e){
      throw Exception("$e");
    }
  }

}