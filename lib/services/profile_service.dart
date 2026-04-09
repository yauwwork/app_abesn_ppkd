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

      if (token == null || token.isEmpty) {
        throw Exception("Token tidak ditemukan, silakan login ulang");
      }

      final response = await http.get(
        Uri.parse(Endpoint.profile),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      log("PROFILE STATUS: ${response.statusCode}");
      log("PROFILE BODY: ${response.body}");

      final decoded = _safeDecode(response.body);

      if (response.statusCode == 200) {
        return ProfileModel.fromJson(decoded);
      } else if (response.statusCode == 401) {
        throw Exception("Session habis, login ulang");
      } else {
        throw Exception(decoded["message"] ?? "Gagal ambil profil");
      }
    } catch (e) {
      log("ERROR PROFILE: $e");
      throw Exception("Terjadi kesalahan saat ambil profil");
    }
  }

  // ================= UPDATE PROFILE =================
  static Future<ProfileModel> updateProfile({required String name}) async {
    try {
      final token = await PreferenceHandler.getToken();

      if (token == null || token.isEmpty) {
        throw Exception("Token tidak ditemukan");
      }

      final response = await http.put(
        Uri.parse(Endpoint.profile),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"name": name}),
      );

      log("UPDATE PROFILE STATUS: ${response.statusCode}");
      log("UPDATE PROFILE BODY: ${response.body}");

      final decoded = _safeDecode(response.body);

      if (response.statusCode == 200) {
        final profile = ProfileModel.fromJson(decoded);

        // 🔥 ambil email dari response / model (AMAN)
        await PreferenceHandler.saveUser(
          name: profile.name,
          email: profile.email,
        );

        return profile;
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

      if (token == null || token.isEmpty) {
        throw Exception("Token tidak ditemukan");
      }

      if (!await imageFile.exists()) {
        throw Exception("File tidak ditemukan");
      }

      // 🔥 FIX MIME TYPE
      String extension = imageFile.path.split('.').last.toLowerCase();

      String mimeType;
      if (extension == "jpg" || extension == "jpeg") {
        mimeType = "image/jpeg";
      } else if (extension == "png") {
        mimeType = "image/png";
      } else {
        mimeType = "image/jpeg";
      }

      // 🔥 BASE64
      List<int> imageBytes = await imageFile.readAsBytes();
      log("IMAGE SIZE: ${imageBytes.length}");

      String base64Image = base64Encode(imageBytes);

      final response = await http.put(
        Uri.parse(Endpoint.uploadPhoto),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "profile_photo": "data:$mimeType;base64,$base64Image",
        }),
      );

      log("UPLOAD PHOTO STATUS: ${response.statusCode}");
      log("UPLOAD PHOTO BODY: ${response.body}");

      final decoded = _safeDecode(response.body);

      if (response.statusCode == 200) {
        return decoded["data"]?["profile_photo"]?.toString() ?? "";
      } else {
        throw Exception(decoded["message"] ?? response.body);
      }
    } catch (e) {
      log("ERROR PHOTO DETAIL: $e");
      throw Exception(e.toString());
    }
  }

  // ================= SAFE JSON =================
  static Map<String, dynamic> _safeDecode(String body) {
    try {
      return jsonDecode(body);
    } catch (e) {
      return {};
    }
  }
}
