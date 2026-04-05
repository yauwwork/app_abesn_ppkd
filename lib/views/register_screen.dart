import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../utils/colors_app.dart';

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

  bool isLoading = false;
  bool isObscure1 = true;
  bool isObscure2 = true;
  bool isChecked = false;

  Future<void> register() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak sama")),
      );
      return;
    }

    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harus setuju syarat & ketentuan")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("https://your-api.com/register"),
        body: {
          "name": nameController.text,
          "email": emailController.text,
          "password": passwordController.text,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        // simpan token
        await prefs.setString("token", data["token"]);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Register berhasil")),
        );

        Navigator.pop(context); // balik ke login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Register gagal")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Terjadi error")),
      );
    }

    setState(() => isLoading = false);
  }

  Widget buildInput(String hint, TextEditingController controller,
      {bool isPassword = false, bool obscure = false, VoidCallback? toggle}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(obscure
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: toggle,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 70, bottom: 30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ],
            ),
          ),

          // FORM
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView(
                children: [
                  const Text("Create Account ✨",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 5),
                  const Text("Fill in your details to get started"),

                  const SizedBox(height: 20),

                  buildInput("Full Name", nameController),
                  const SizedBox(height: 15),

                  buildInput("Email Address", emailController),
                  const SizedBox(height: 15),

                  buildInput("Min. 8 characters", passwordController,
                      isPassword: true,
                      obscure: isObscure1,
                      toggle: () {
                        setState(() => isObscure1 = !isObscure1);
                      }),

                  const SizedBox(height: 15),

                  buildInput("Repeat your password", confirmPasswordController,
                      isPassword: true,
                      obscure: isObscure2,
                      toggle: () {
                        setState(() => isObscure2 = !isObscure2);
                      }),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (val) {
                          setState(() => isChecked = val!);
                        },
                      ),
                      const Expanded(
                        child: Text(
                            "I agree to the Terms of Service and Privacy Policy"),
                      )
                    ],
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : register,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Create Account"),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Already have an account? Sign In"),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}