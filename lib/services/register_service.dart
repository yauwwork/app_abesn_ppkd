import 'dart:convert';
import 'dart:developer';
import 'package:app_abesn_ppkd/models/screen_models/register_modle.dart';
import 'package:app_abesn_ppkd/services/endpoint.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<RegisterModel> register({
    required String name,
    required String email,
    required String password,
    required int trainingId,
    required int batchId,
    required String jenisKelamin,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoint.register),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "training_id": trainingId,
          "batch_id": batchId,
          "jenis_kelamin": jenisKelamin,
        }),
      );

      log('REGISTER STATUS: ${response.statusCode}');
      log('REGISTER BODY: ${response.body}');

      final decoded = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return RegisterModel.fromJson(decoded);
      } else {
        String message = decoded['message'] ?? 'Register gagal';

        // 🔥 ambil error detail kalau ada
        if (decoded['errors'] != null) {
          final errors = decoded['errors'] as Map<String, dynamic>;
          final List<String> errorMessages = [];

          errors.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              errorMessages.add("${key}: ${value.first}");
            }
          });

          if (errorMessages.isNotEmpty) {
            message += "\n${errorMessages.join('\n')}";
          }
        }

        throw Exception(message);
      }
    } catch (e) {
      log("ERROR REGISTER: $e");
      throw Exception("Terjadi kesalahan, coba lagi");
    }
  }
}
