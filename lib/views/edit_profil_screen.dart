import 'dart:io';
import 'package:app_abesn_ppkd/models/screen_models/profile_model.dart';
import 'package:app_abesn_ppkd/services/profile_service.dart';
import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();

  File? imageFile;
  String? photoUrl;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  // 🔥 LOAD DATA AWAL
  Future<void> loadProfile() async {
    try {
      final profile = await ProfileService.getProfile();

      setState(() {
        nameController.text = profile.name;
        photoUrl = profile.photo;
      });
    } catch (e) {
      print("ERROR LOAD PROFILE: $e");
    }
  }

  // 🔥 PILIH GAMBAR
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  // 🔥 UPDATE PROFILE
  Future<void> updateProfile() async {
    setState(() => isLoading = true);

    try {
      // update nama
      await ProfileService.updateProfile(name: nameController.text);

      // update foto (kalau ada)
      if (imageFile != null) {
        final newPhoto = await ProfileService.updatePhoto(imageFile!);

        setState(() {
          photoUrl = newPhoto; // 🔥 biar langsung ke-refresh
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile berhasil diupdate")),
      );

      Navigator.pop(context, true); // 🔥 balik + trigger refresh
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueCard,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 🔥 FOTO PROFILE
            GestureDetector(
              onTap: pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: imageFile != null
                        ? FileImage(imageFile!)
                        : (photoUrl != null && photoUrl!.isNotEmpty
                              ? NetworkImage(photoUrl!) as ImageProvider
                              : null),
                    child:
                        imageFile == null &&
                            (photoUrl == null || photoUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔥 INPUT NAMA
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Nama",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 BUTTON SAVE
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Simpan",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
