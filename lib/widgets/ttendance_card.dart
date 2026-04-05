import 'package:flutter/material.dart';

class AttendanceCard extends StatelessWidget {
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;

  const AttendanceCard({
    super.key,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF2F80ED)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text("Attendance",
              style: TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onCheckIn,
                  child: const Text("Check In"),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: onCheckOut,
                  child: const Text("Check Out"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}