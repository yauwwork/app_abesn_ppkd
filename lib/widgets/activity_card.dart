import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final String date;
  final String time;
  final String status;

  const ActivityCard({
    super.key,
    required this.date,
    required this.time,
    required this.status,
  });

  String mapStatusToEnglish(String? status, String? checkInTime) {
  // 🔥 kalau izin
  if (status == "izin") return "Absent";

  // 🔥 kalau gak ada checkin
  if (checkInTime == null) return "Absent";

  // 🔥 cek telat
  final hour = int.parse(checkInTime.split(":")[0]);
  if (hour > 8) return "Late";

  return "Present";
}

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData icon;

    // 🔥 logic status
    switch (status) {
      case "Late":
        statusColor = AppColors.warning;
        icon = Icons.access_time;
        break;
      case "Present":
        statusColor = AppColors.success;
        icon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.grey;
        icon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // 🔥 ICON KIRI
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: statusColor, size: 20),
          ),

          const SizedBox(width: 12),

          // 🔥 TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // 🔥 STATUS BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
