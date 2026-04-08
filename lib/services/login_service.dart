import 'dart:convert';
import 'dart:developer';
import 'package:app_abesn_ppkd/models/screen_models/login_model.dart';
import 'package:app_abesn_ppkd/services/endpoint.dart';
import 'package:app_abesn_ppkd/utils/shared_preferences.dart'; // 🔥 pastikan ini PreferenceHandler lo
import 'package:http/http.dart' as http;

Future<LoginModel> loginModel({
  required String email,
  required String password,
}) async {
  final response = await http.post(
    Uri.parse(Endpoint.login),
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
    body: jsonEncode({"email": email, "password": password}),
  );

  log(response.body);

  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    final loginData = LoginModel.fromJson(data);

    // 🔥 SIMPAN TOKEN
    await PreferenceHandler.saveToken(loginData.token ?? "");

    // 🔥 SIMPAN USER
    await PreferenceHandler.saveUser(
      name: loginData.user?.name ?? "",
      email: loginData.user?.email ?? "",
    );

    return loginData; // ✅ WAJIB ADA
  } else {
    throw Exception(data["message"] ?? "Login gagal"); // ✅ HANDLE ERROR
  }
}
