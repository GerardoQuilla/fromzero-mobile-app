import 'dart:convert';

import 'package:fromzero_app/api/baseUrl.dart';
import 'package:http/http.dart' as http;

class UsersService{
  static const String url = "${BaseUrlApi.url}/users";

  Future<Map<String,dynamic>> getUserById(int userId, String token)async{
    try {
      final response = await http.get(
          Uri.parse("$url/$userId"),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }
      );

      if(response.statusCode==200){
        Map<String, dynamic> data = jsonDecode(response.body);
        List<String> roles = List<String>.from(data['roles']);
        return {
          'role': roles.isNotEmpty ? roles[0] : ""
        };
      }else{
        throw Exception("Error");
      }

    }catch(e){
      throw Exception("$e");
    }
  }
}