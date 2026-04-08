import 'dart:convert';
import 'dart:developer';
import 'package:app_abesn_ppkd/services/endpoint.dart';
import 'package:app_abesn_ppkd/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:app_abesn_ppkd/models/screen_models/get_user_model.dart';

Future<GetUserModel?> getUser() async {
  try {
    // 🔥 AMBIL TOKEN
    final token = await PreferenceHandler.getToken();

    final response = await http.get(
      Uri.parse(Endpoint.profile),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer ${token ?? ''}",
      },
    );

    log("RESPONSE USER: ${response.body}");

    if (response.statusCode == 200) {
      return GetUserModel.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      log("ERROR: $error");

      throw Exception(error["message"] ?? "Gagal ambil user");
    }
  } catch (e) {
    log("EXCEPTION: $e");
    rethrow;
  }
}
