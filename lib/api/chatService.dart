import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseUrl.dart';
import '../models/chat_model.dart';

class ChatService {
  static const String url = "${BaseUrlApi.url}/chat";


  Future<Chat> createChat(String companyId, String developerId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      final response = await http.post(
        Uri.parse("$url/chats/create"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'companyId': companyId,
          'developerId': developerId
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return Chat.fromJson(responseData);
      } else {
        throw Exception("Failed to create chat");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<List<Chat>> getChatsForDeveloper(String developerId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      final response = await http.get(
        Uri.parse("$url/developer/$developerId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
        return responseData.map((chat) => Chat.fromJson(chat)).toList();
      } else {
        throw Exception("Failed to get chats for developer");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<List<Chat>> getChatsForCompany(String companyId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      final response = await http.get(
        Uri.parse("$url/company/$companyId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
        return responseData.map((chat) => Chat.fromJson(chat)).toList();
      } else {
        throw Exception("Failed to get chats for company");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<Chat?> getChatByDeveloperAndCompany(String developerId, String companyId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      final response = await http.get(
        Uri.parse("$url/chats/$developerId/$companyId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Chat.fromJson(responseData);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception("Failed to get chat");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }
  Future<Chat> getChatById(int chatId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      final response = await http.get(
        Uri.parse("$url/chats/$chatId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Chat.fromJson(responseData);
      } else {
        throw Exception("Failed to get chat by ID");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }
}
