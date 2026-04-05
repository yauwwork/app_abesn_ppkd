import 'package:flutter/material.dart';

class TodayCard extends StatelessWidget {
  final String checkIn;
  final String checkOut;

  const TodayCard({
    super.key,
    required this.checkIn,
    required this.checkOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFBDF1F6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today Attendance",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text("Check In: $checkIn"),
          Text("Check Out: $checkOut"),
        ],
      ),
    );
  }
}