import 'dart:convert';
import 'package:app_abesn_ppkd/models/screen_models/profile_model.dart';
import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:app_abesn_ppkd/views/edit_profil_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_abesn_ppkd/services/profile_service.dart';
import 'package:app_abesn_ppkd/utils/shared_preferences.dart';
import 'package:app_abesn_ppkd/views/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final data = await ProfileService.getProfile();
      setState(() {
        user = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void logout() async {
    await PreferenceHandler.logout();

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> goToEdit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );

    if (result == true) {
      fetchProfile(); // 🔥 auto refresh
    }
  }

  //PHOTO URL HANDLER
  String getFullPhotoUrl(String? path) {
    if (path == null || path.isEmpty) {
      return "";
    }

    // kalau udah full url → langsung pakai
    if (path.startsWith("http")) {
      return path;
    }

    return "https://appabsensi.mobileprojp.com$path";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text("Profile"),
        actions: [
          IconButton(onPressed: goToEdit, icon: const Icon(Icons.edit)),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _headerCard(),
                const SizedBox(height: 20),
                _personalInfo(),
                const SizedBox(height: 20),
                _accountSection(),
                const SizedBox(height: 20),
                _activitySection(),
                const SizedBox(height: 20),
                _appSection(),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "AttendEase v2.4.0",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
    );
  }

  // ================= HEADER =================
  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.gradientStart, AppColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                backgroundImage: (user?.photo != null && user!.photo.isNotEmpty)
                    ? NetworkImage(getFullPhotoUrl(user!.photo))
                    : null,
                child: (user?.photo == null || user!.photo.isEmpty)
                    ? const Icon(Icons.person, size: 40, color: Colors.grey)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 18,
                  width: 18,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user?.name ?? "-",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.position ?? "-",
            style: const TextStyle(color: Colors.white70),
          ),
          Text(
            "Batch ${user?.batch ?? "-"}",
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: goToEdit,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white38,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              "Edit Profile",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // ================= PERSONAL INFO =================
  Widget _personalInfo() {
    return _card(
      title: "PERSONAL INFO",
      children: [
        _infoTile(Icons.email, "Email", user?.email ?? "-"),
        const SizedBox(height: 8),
        _infoTile(Icons.work, "Position", user?.position ?? "-"),
        const SizedBox(height: 8),
        _infoTile(Icons.badge, "Batch", user?.batch ?? "-"),
      ],
    );
  }

  // ================= ACCOUNT =================
  Widget _accountSection() {
    return _menuCard("ACCOUNT", [
      _menuItem(Icons.edit, "Edit Profile", onTap: goToEdit),
      _menuItem(Icons.lock, "Change Password"),
    ]);
  }

  // ================= ACTIVITY =================
  Widget _activitySection() {
    return _menuCard("ACTIVITY", [
      _menuItem(Icons.menu_book, "Training & Courses"),
      _menuItem(Icons.shield, "Privacy & Security"),
    ]);
  }

  // ================= APP =================
  Widget _appSection() {
    return _menuCard("APP", [
      _menuItem(Icons.settings, "Settings"),
      _menuItem(Icons.logout, "Log Out", isLogout: true),
    ]);
  }

  // ================= COMPONENT =================
  Widget _card({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _menuCard(String title, List<Widget> items) {
    return _card(title: title, children: items);
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _menuItem(
    IconData icon,
    String title, {
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: isLogout ? logout : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: isLogout ? AppColors.danger : AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isLogout ? AppColors.danger : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
