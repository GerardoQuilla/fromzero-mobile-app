import 'dart:convert';

import 'package:fromzero_app/api/baseUrl.dart';
import 'package:http/http.dart' as http;

class AuthService{
  static const String url = "${BaseUrlApi.url}/auth";

  Future<http.Response> login(String email, String password)async{
    try{
      final response = await http.post(
        Uri.parse("$url/sign-in"),
        body: jsonEncode({
          'email': email,
          'password': password
        }),
        headers: {'Content-Type':'application/json'}
      );
      return response;
    }catch(e){
      throw Exception("Error");
    }
  }

  Future<http.Response> registerDeveloper(
      String email,
      String password,
      String firstName,
      String lastName
      )async{
    try{
      final response = await http.post(
        Uri.parse("$url/register-developer"),
        body: jsonEncode({
          'email':email,
          'password':password,
          'firstName':firstName,
          'lastName':lastName
        }),
        headers: {'Content-Type':'application/json'}
      );
      return response;
    }catch(e){
      throw Exception("Error");
    }
  }

  Future<http.Response> registerCompany(
      String email,
      String password,
      String companyName
      ) async {
    try {
      final response = await http.post(
          Uri.parse("$url/register-company"),
          body: jsonEncode({
            'email': email,
            'password': password,
            'companyName': companyName
          }),
          headers: {'Content-Type': 'application/json'}
      );
      return response;

      /*
      if (response.statusCode == 200) {
        return response;
      } else {
        throw Exception("Failed to register company: ${response.body}");
      }*/
    } catch (e) {
      throw Exception("Error registering company: $e");
    }
  }

}