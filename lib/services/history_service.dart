import 'dart:convert';
import 'package:app_abesn_ppkd/models/screen_models/history_model.dart';
import 'package:app_abesn_ppkd/services/endpoint.dart';
import 'package:http/http.dart' as http;
import '../utils/shared_preferences.dart';

class HistoryService {
  static Future<List<Data>> getHistory() async {
    try {
      final token = await PreferenceHandler.getToken();

      final response = await http.get(
        Uri.parse(Endpoint.history),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // 🔥 DEBUG (penting buat lu sebagai newbie)
      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final result = AttendanceHistoryModel.fromJson(jsonData);

        return result.data;
      } else {
        print("ERROR API: ${response.body}");
        return [];
      }
    } catch (e) {
      print("ERROR SERVICE: $e");
      return [];
    }
  }
}