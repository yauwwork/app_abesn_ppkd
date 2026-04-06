import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:flutter/material.dart';
import '../widgets/permission_card.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PermissionRequestScreen extends StatefulWidget {
  const PermissionRequestScreen({super.key});

  @override
  State<PermissionRequestScreen> createState() =>
      _PermissionRequestScreenState();
}

class _PermissionRequestScreenState extends State<PermissionRequestScreen> {
  final List<Map<String, dynamic>> dummyRequests = [
    {
      'title': 'Annual Leave',
      'date': 'April 5, 2026',
      'reason': 'Family vacation',
      'submittedDate': 'Mar 28, 2026',
      'status': 'Approved',
      'statusColor': Colors.green,
    },
    {
      'title': 'Personal Leave',
      'date': 'April 10, 2026',
      'reason': 'Personal affairs',
      'submittedDate': 'Apr 1, 2026',
      'status': 'Pending',
      'statusColor': Colors.orange,
    },
    {
      'title': 'Sick Leave',
      'date': 'April 15, 2026',
      'reason': 'Fever and headache',
      'submittedDate': 'Apr 10, 2026',
      'status': 'Rejected',
      'statusColor': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueCard,
      // appBar: AppBar(
      //   backgroundColor: const Color(0xffEEF3F6),
      //   elevation: 0,
      //   centerTitle: true,
      //   title: const Text(
      //     'Permission Request',
      //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
      //   ),
      // ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: dummyRequests.length,
          itemBuilder: (context, index) {
            final item = dummyRequests[index];

            return PermissionCard(
              title: item['title'] as String,
              date: item['date'] as String,
              reason: item['reason'] as String,
              submittedDate: item['submittedDate'] as String,
              status: item['status'] as String,
              statusColor: item['statusColor'] as Color,
            );
          },
        ),
      ),
    );
  }
}
