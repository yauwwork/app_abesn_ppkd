import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:app_abesn_ppkd/views/permission_request_list_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:app_abesn_ppkd/models/screen_models/permission_model.dart';

class PermissionFormScreen extends StatefulWidget {
  const PermissionFormScreen({super.key});

  @override
  State<PermissionFormScreen> createState() => _PermissionFormScreenState();
}

class _PermissionFormScreenState extends State<PermissionFormScreen> {
  String selectedLeaveType = 'Sick Leave';

  final TextEditingController reasonController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

  Future<void> _pickDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      controller.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    reasonController.dispose();
    notesController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.lightBlueCard,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          leading: const BackButton(color: AppColors.card),
          title: const Text(
            "Leave Request",
            style: TextStyle(
              color: AppColors.card,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 16, color: Colors.white),
                    SizedBox(width: 6),
                    Text("Submit", style: TextStyle(color: AppColors.border)),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.white),
                    SizedBox(width: 6),
                    Text(
                      "My Request",
                      style: TextStyle(color: AppColors.border),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 🔥 TAB VIEW
        body: TabBarView(children: [_buildSubmitForm(), _buildMyRequest()]),
      ),
    );
  }

  // 🔥 SUBMIT FORM (ISI LAMA LO)
  Widget _buildSubmitForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Leave Request Form",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Fill in all required fields",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 24),

            _label("Leave Type *"),
            const SizedBox(height: 8),
            _dropdown(),

            const SizedBox(height: 16),

            _label("Start Date *"),
            const SizedBox(height: 8),
            _input(
              startDateController,
              "dd/mm/yyyy",
              icon: Icons.calendar_today,
            ),

            const SizedBox(height: 16),

            _label("End Date *"),
            const SizedBox(height: 8),
            _input(endDateController, "dd/mm/yyyy", icon: Icons.calendar_today),

            const SizedBox(height: 16),

            _label("Reason *"),
            const SizedBox(height: 8),
            _input(reasonController, "Brief reason for leave"),

            const SizedBox(height: 16),

            _label("Additional Notes"),
            const SizedBox(height: 8),
            _input(
              notesController,
              "Add any additional information (optional)",
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            _label("Supporting Document"),
            const SizedBox(height: 8),
            _uploadBox(),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // 🔥 VALIDASI
                  if (startDateController.text.isEmpty ||
                      endDateController.text.isEmpty ||
                      reasonController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all required fields"),
                      ),
                    );
                    return;
                  }

                  // 🔥 SIMPAN DATA
                  permissionList.add(
                    PermissionModel(
                      type: selectedLeaveType,
                      startDate: startDateController.text,
                      endDate: endDateController.text,
                      reason: reasonController.text,
                      notes: notesController.text,
                      status: "Pending",
                      imagePath: selectedImage?.path,
                    ),
                  );

                  // 🔥 RESET FORM
                  startDateController.clear();
                  endDateController.clear();
                  reasonController.clear();
                  notesController.clear();

                  setState(() {
                    selectedImage = null;
                  });

                  // 🔥 PINDAH KE TAB "MY REQUEST"
                  DefaultTabController.of(context).animateTo(1);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Request submitted successfully"),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Submit Request",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 MY REQUEST (DUMMY DULU)
  Widget _buildMyRequest() {
    return const PermissionRequestScreen();
  }

  // ================= COMPONENT =================

  Widget _label(String text) {
    bool isRequired = text.contains("*");

    return RichText(
      text: TextSpan(
        text: text.replaceAll("*", ""),
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        children: isRequired
            ? [
                const TextSpan(
                  text: " *",
                  style: TextStyle(color: Colors.red),
                ),
              ]
            : [],
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: icon != null,
      onTap: icon != null ? () => _pickDate(controller) : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLeaveType,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: 'Sick Leave', child: Text('Sick Leave')),
            DropdownMenuItem(
              value: 'Annual Leave',
              child: Text('Annual Leave'),
            ),
            DropdownMenuItem(
              value: 'Personal Leave',
              child: Text('Personal Leave'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              selectedLeaveType = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _uploadBox() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          color: Colors.grey.shade50,
        ),
        child: Column(
          children: [
            if (selectedImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  selectedImage!,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              const Text("Tap to change image", style: TextStyle(fontSize: 12)),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.upload_file, color: AppColors.primary),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tap to upload document",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              const Text(
                "PDF, JPG, PNG up to 5MB",
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
