import 'dart:convert';
import 'dart:developer';
import 'package:app_abesn_ppkd/services/endpoint.dart';
import 'package:app_abesn_ppkd/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class IzinService {
  // ============================================================================
  // SUBMIT IZIN
  // ============================================================================
  static Future<Map<String, dynamic>> submitIzin({
    required String type,
    required String reason,
    required String startDate,
    required String endDate,
    String? notes,
  }) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      Uri.parse(Endpoint.permission),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token ?? ''}",
      },
      body: jsonEncode({
        "type": type,
        "reason": reason,
        "start_date": startDate,
        "end_date": endDate,
        if (notes != null && notes.isNotEmpty) "notes": notes,
      }),
    );

    log("IZIN STATUS: ${response.statusCode}");
    log("IZIN BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Gagal submit izin");
    }
  }
}
