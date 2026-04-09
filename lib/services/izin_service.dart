import 'dart:convert';
import 'dart:developer';
import 'package:app_abesn_ppkd/models/screen_models/izin_model.dart';
import 'package:http/http.dart' as http;
import '../utils/shared_preferences.dart';

class IzinService {
  final String baseUrl = "https://appabsensi.mobileprojp.com/api";

  Future<Map<String, dynamic>> sendIzin(IzinModel izin) async {
    try {
      final token = await PreferenceHandler.getToken();

      final response = await http.post(
        Uri.parse("$baseUrl/izin"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token ?? ''}",
        },
        body: jsonEncode(izin.toJson()),
      );

      log("IZIN STATUS: ${response.statusCode}");
      log("IZIN BODY: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        throw Exception(data["message"] ?? "Gagal kirim izin");
      }
    } catch (e) {
      log("ERROR IZIN: $e");
      rethrow;
    }
  }
}