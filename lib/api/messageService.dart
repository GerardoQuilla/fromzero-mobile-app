import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseUrl.dart';
import '../models/message_model.dart';

class MessageService {
  static const String url = "${BaseUrlApi.url}/messages";

  Future<Message> createMessage(int chatId, String senderId, String content) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'chatId': chatId,
          'senderId': senderId,
          'content': content,
        }),
      );

      final responseData = jsonDecode(response.body);
      return Message.fromJson(responseData);
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<List<Message>> getMessagesByChatId(int chatId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      final response = await http.get(
        Uri.parse("$url/chat/$chatId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> responseData = jsonDecode(utf8.decode(response.bodyBytes));
        return responseData.map((message) => Message.fromJson(message)).toList();
      } else {
        throw Exception("Failed to get messages");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }
}
