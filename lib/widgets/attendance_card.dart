import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:flutter/material.dart';

class AttendanceCard extends StatelessWidget {
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;

  final String currentTime;
  final String checkIn;
  final String checkOut;

  const AttendanceCard({
    super.key,
    required this.onCheckIn,
    required this.onCheckOut,
    required this.currentTime,
    required this.checkIn,
    required this.checkOut,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.gradientEnd],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 TOP ROW (status + lokasi)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  CircleAvatar(radius: 4, backgroundColor: Colors.green),
                  SizedBox(width: 6),
                  Text("Checked In", style: TextStyle(color: Colors.white)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Jakarta HQ",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 🔥 JAM BESAR
          Text(
            currentTime,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const Text("Current Time", style: TextStyle(color: Colors.white70)),

          const SizedBox(height: 20),

          // 🔥 CHECK IN & OUT BOX
          Row(
            children: [
              Expanded(child: _timeBox("CHECK IN", checkIn)),
              const SizedBox(width: 10),
              Expanded(child: _timeBox("CHECK OUT", checkOut)),
            ],
          ),

          const SizedBox(height: 20),

          // 🔥 BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onCheckOut,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "Check Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
