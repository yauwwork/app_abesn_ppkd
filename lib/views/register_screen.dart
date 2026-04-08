import 'dart:convert';
import 'dart:developer';
import 'package:app_abesn_ppkd/models/screen_models/batch_model.dart';
import 'package:app_abesn_ppkd/models/screen_models/training_model.dart';
import 'package:app_abesn_ppkd/services/endpoint.dart';
import 'package:app_abesn_ppkd/services/training_service.dart';
import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:app_abesn_ppkd/utils/shared_preferences.dart';
import 'package:app_abesn_ppkd/views/login_screen.dart';
import 'package:app_abesn_ppkd/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedGender;
  int? selectedTraining;
  int? selectedBatch;

  List<Training> trainingList = [];
  List<Batch> batchList = [];

  bool isLoading = false;
  bool isObscure = true;
  bool isObscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final trainings = await TrainingService.getTraining();
    final batches = await TrainingService.getBatches();

    log("TRAINING COUNT: ${trainings.length}");
    log("BATCH COUNT: ${batches.length}");

    setState(() {
      trainingList = trainings;
      batchList = batches;
    });
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedGender == null) {
      _showError("Pilih jenis kelamin");
      return;
    }
    if (selectedTraining == null) {
      _showError("Pilih training");
      return;
    }
    if (selectedBatch == null) {
      _showError("Pilih batch");
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      _showError("Password dan konfirmasi tidak sama");
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await http.post(
        Uri.parse(Endpoint.register),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "password": passwordController.text,
          "jenis_kelamin": selectedGender,
          "batch_id": selectedBatch,
          "training_id": selectedTraining,
        }),
      );

      log("REGISTER STATUS: ${res.statusCode}");
      log("REGISTER BODY: ${res.body}");

      final data = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        // 🔥 SIMPAN TOKEN JIKA ADA
        if (data["token"] != null) {
          await PreferenceHandler.saveToken(data["token"]);
        }
        if (data["data"] != null || data["user"] != null) {
          final user = data["data"] ?? data["user"];
          await PreferenceHandler.saveUser(
            name: user["name"] ?? "",
            email: user["email"] ?? "",
          );
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Register berhasil!"),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // 🔥 CEK APAKAH ADA TOKEN (LANGSUNG KE DASHBOARD)
        if (data["token"] != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        } else {
          // KEMBALI KE LOGIN
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      } else {
        String message = data['message'] ?? 'Register gagal';
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final List<String> errorMessages = [];
          errors.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              errorMessages.add(value.first.toString());
            }
          });
          if (errorMessages.isNotEmpty) {
            message = errorMessages.join('\n');
          }
        }
        _showError(message);
      }
    } catch (e) {
      log("ERROR REGISTER: $e");
      _showError("Terjadi kesalahan, coba lagi");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _input(
    String label,
    String hint,
    TextEditingController c, {
    bool isPassword = false,
    bool isConfirmPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: c,
          obscureText: isPassword
              ? isObscure
              : isConfirmPassword
                  ? isObscureConfirm
                  : false,
          keyboardType: keyboardType,
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) return "$label wajib diisi";
                return null;
              },
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            suffixIcon: (isPassword || isConfirmPassword)
                ? IconButton(
                    icon: Icon(
                      (isPassword ? isObscure : isObscureConfirm)
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        if (isPassword) {
                          isObscure = !isObscure;
                        } else {
                          isObscureConfirm = !isObscureConfirm;
                        }
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }

  Widget dropdownBox({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 🔵 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 30, left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Register to start your attendance",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          // 🧾 FORM
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _input("Nama Lengkap", "Masukkan nama lengkap", nameController),
                  const SizedBox(height: 14),

                  _input(
                    "Email",
                    "your@email.com",
                    emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),

                  // 🔥 GENDER
                  const Text("Jenis Kelamin",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  dropdownBox(
                    child: DropdownButton<String>(
                      value: selectedGender,
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: const Text("Pilih Gender"),
                      items: const [
                        DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                        DropdownMenuItem(value: "P", child: Text("Perempuan")),
                      ],
                      onChanged: (val) {
                        setState(() => selectedGender = val);
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 🔥 TRAINING (FROM API)
                  const Text("Training",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  dropdownBox(
                    child: DropdownButton<int>(
                      value: selectedTraining,
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: const Text("Pilih Training"),
                      items: trainingList.map((e) {
                        return DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(
                            e.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => selectedTraining = val);
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 🔥 BATCH (FROM API)
                  const Text("Batch",
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  dropdownBox(
                    child: DropdownButton<int>(
                      value: selectedBatch,
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: const Text("Pilih Batch"),
                      items: batchList.map((e) {
                        return DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(e.displayName),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => selectedBatch = val);
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  _input(
                    "Password",
                    "Masukkan password",
                    passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password wajib diisi";
                      }
                      if (value.length < 6) {
                        return "Password minimal 6 karakter";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),

                  _input(
                    "Konfirmasi Password",
                    "Ulangi password",
                    confirmPasswordController,
                    isConfirmPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Konfirmasi password wajib diisi";
                      }
                      if (value != passwordController.text) {
                        return "Password tidak sama";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // 🔥 BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryDark, AppColors.gradientEnd],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton(
                        onPressed: isLoading ? null : register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
