import 'dart:convert';
import 'dart:developer';
import 'package:app_abesn_ppkd/services/endpoint.dart';
import 'package:app_abesn_ppkd/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  // ============================================================================
  // CHECK IN
  // ============================================================================
  static Future<Map<String, dynamic>> checkIn({
    required double latitude,
    required double longitude,
  }) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      Uri.parse(Endpoint.checkIn),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token ?? ''}",
      },
      body: jsonEncode({
        "attendance_date": DateTime.now().toString().split(' ')[0],
        "check_in": "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}",
        "check_in_lat": latitude,
        "check_in_lng": longitude,
        "check_in_address": "Lat $latitude, Lng $longitude",
        // Fallback for old API endpoints if needed:
        "latitude": latitude,
        "longitude": longitude,
      }),
    );

    log("CHECK-IN STATUS: ${response.statusCode}");
    log("CHECK-IN BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Check-in gagal");
    }
  }

  // ============================================================================
  // CHECK OUT
  // ============================================================================
  static Future<Map<String, dynamic>> checkOut({
    required double latitude,
    required double longitude,
  }) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.post(
      Uri.parse(Endpoint.checkOut),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token ?? ''}",
      },
      body: jsonEncode({
        "attendance_date": DateTime.now().toString().split(' ')[0],
        "check_out": "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}",
        "check_out_lat": latitude,
        "check_out_lng": longitude,
        "check_out_address": "Lat $latitude, Lng $longitude",
        // Fallback for old API endpoints if needed:
        "latitude": latitude,
        "longitude": longitude,
      }),
    );

    log("CHECK-OUT STATUS: ${response.statusCode}");
    log("CHECK-OUT BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Check-out gagal");
    }
  }

  // ============================================================================
  // GET TODAY ATTENDANCE
  // ============================================================================
  static Future<Map<String, dynamic>?> getToday({String? date}) async {
    final token = await PreferenceHandler.getToken();
    final today = date ?? DateTime.now().toString().split(' ')[0];

    final response = await http.get(
      Uri.parse("${Endpoint.today}?attendance_date=$today"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${token ?? ''}",
      },
    );

    log("TODAY STATUS: ${response.statusCode}");
    log("TODAY BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      return null;
    }
  }

  // ============================================================================
  // GET STATS
  // ============================================================================
  static Future<Map<String, dynamic>?> getStats({
    required String start,
    required String end,
  }) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      Uri.parse("${Endpoint.stats}?start=$start&end=$end"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${token ?? ''}",
      },
    );

    log("STATS STATUS: ${response.statusCode}");
    log("STATS BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      return null;
    }
  }

  // ============================================================================
  // GET HISTORY
  // ============================================================================
  static Future<List<dynamic>> getHistory() async {
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      Uri.parse(Endpoint.history),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${token ?? ''}",
      },
    );

    log("HISTORY STATUS: ${response.statusCode}");
    log("HISTORY BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data["data"] is List) {
        return data["data"];
      }
      return [];
    } else {
      return [];
    }
  }

  // ============================================================================
  // DELETE ABSEN
  // ============================================================================
  static Future<Map<String, dynamic>> deleteAbsen(int id) async {
    final token = await PreferenceHandler.getToken();

    final response = await http.delete(
      Uri.parse(Endpoint.deleteAbsen(id)),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${token ?? ''}",
      },
    );

    log("DELETE STATUS: ${response.statusCode}");
    log("DELETE BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data["message"] ?? "Gagal hapus absen");
    }
  }
}