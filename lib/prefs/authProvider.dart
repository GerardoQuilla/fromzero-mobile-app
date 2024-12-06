import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _token = "";
  String _role = "";
  String _profileId = "";

  bool get isLoggedIn => _isLoggedIn;

  String get token => _token;

  String get role => _role;

  String get profileId => _profileId;

  AuthProvider();

  Future<void> _updateData()async {
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', _token);
      await prefs.setString('role', _role);
      await prefs.setString('profileId', _profileId);
    }catch(e){
      print("Error al actualizar datos");
    }
  }

  Future<void> login(String token, String profileId, String role)async{
    _isLoggedIn=true;
    _token=token;
    _profileId=profileId;
    _role=role;
    await _updateData();
    notifyListeners();
  }

  Future<void> logout()async{
    _isLoggedIn=false;
    _token='';
    _profileId='';
    _role='';
    await _updateData();
    notifyListeners();
  }

}
