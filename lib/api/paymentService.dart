import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'baseUrl.dart';
import '../models/payment_model.dart';
import '../models/complete_payment_model.dart';

class PaymentService {
  static const String url = "${BaseUrlApi.url}/payments";

  Future<Payment> completePayment(int projectId, CompletePaymentResource resource) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      final response = await http.patch(
        Uri.parse("$url/project/$projectId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(resource.toJson()),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Payment.fromJson(responseData);
      } else {
        throw Exception("Failed to complete payment");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<Payment> getProjectPayment(int projectId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token") ?? "";

      final response = await http.get(
        Uri.parse("$url/project/$projectId"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return Payment.fromJson(responseData);
      } else {
        throw Exception("Failed to get project payment");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }

  Future<List<Payment>> getAllPaymentsByDeveloper(String developerId) async {
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
        return responseData.map((payment) => Payment.fromJson(payment)).toList();
      } else {
        throw Exception("Failed to get payments by developer");
      }
    } catch (e) {
      throw Exception("$e");
    }
  }
}