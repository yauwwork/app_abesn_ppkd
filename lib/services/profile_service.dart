import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:app_abesn_ppkd/models/screen_models/profile_model.dart';
import 'package:app_abesn_ppkd/services/endpoint.dart';
import 'package:app_abesn_ppkd/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  // ================= GET PROFILE =================
  static Future<ProfileModel> getProfile() async {
    try {
      final token = await PreferenceHandler.getToken();

      final response = await http.get(
        Uri.parse(Endpoint.profile),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${token ?? ''}",
        },
      );

      log("INI RESPONSE ASLI: ${response.body}");
      log("PROFILE STATUS: ${response.statusCode}");
      log("PROFILE BODY: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ProfileModel.fromJson(decoded);
      } else {
        throw Exception(decoded["message"] ?? "Gagal ambil profil");
      }
    } catch (e) {
      log("ERROR PROFILE: $e");
      throw Exception("Terjadi kesalahan saat ambil profil");
    }
  }

  // ================= UPDATE PROFILE =================
  static Future<ProfileModel> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      final token = await PreferenceHandler.getToken();

      final response = await http.put(
        Uri.parse(Endpoint.profile),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token ?? ''}",
        },
        body: jsonEncode({"name": name, "email": email}),
      );

      log("UPDATE PROFILE STATUS: ${response.statusCode}");
      log("UPDATE PROFILE BODY: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        await PreferenceHandler.saveUser(name: name, email: email);
        return ProfileModel.fromJson(decoded);
      } else {
        throw Exception(decoded["message"] ?? "Gagal update profil");
      }
    } catch (e) {
      log("ERROR UPDATE: $e");
      throw Exception("Terjadi kesalahan saat update profil");
    }
  }

  // ================= UPDATE PHOTO =================
  static Future<String> updatePhoto(File imageFile) async {
    try {
      final token = await PreferenceHandler.getToken();

      final request = http.MultipartRequest(
        'PUT',
        Uri.parse(Endpoint.uploadPhoto),
      );

      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer ${token ?? ''}",
      });

      request.files.add(
        await http.MultipartFile.fromPath('photo', imageFile.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      log("UPLOAD PHOTO STATUS: ${response.statusCode}");
      log("UPLOAD PHOTO BODY: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return decoded["data"]["photo"] ?? "";
      } else {
        throw Exception(decoded["message"] ?? "Gagal upload foto");
      }
    } catch (e) {
      log("ERROR PHOTO: $e");
      throw Exception("Terjadi kesalahan upload foto");
    }
  }
}
