import 'package:flutter/material.dart';
import 'package:app_abesn_ppkd/utils/colors_app.dart';

class HistoryCard extends StatelessWidget {
  final String date;
  final String day;
  final String checkIn;
  final String checkOut;
  final String duration;
  final String status;
  final String location; // 🔥 NEW
  final bool isWeekend;

  const HistoryCard({
    super.key,
    required this.date,
    required this.day,
    required this.checkIn,
    required this.checkOut,
    required this.duration,
    required this.status,
    required this.location,
    required this.isWeekend,
  });

  Color getStatusColor() {
    switch (status) {
      case "Late":
        return AppColors.warning;
      case "Present":
        return AppColors.success;
      case "Absent":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon() {
    switch (status) {
      case "Late":
        return Icons.access_time;
      case "Present":
        return Icons.check_circle;
      case "Absent":
        return Icons.info;
      default:
        return Icons.help;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWeekend ? const Color(0xffF7F7F7) : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Opacity(
        opacity: isWeekend ? 0.6 : 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(date,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(day,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(getStatusIcon(),
                          size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(status,
                          style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// TIME
            Row(
              children: [
                const Icon(Icons.login, color: Colors.green, size: 18),
                const SizedBox(width: 6),
                Text(checkIn),
                const SizedBox(width: 20),
                const Icon(Icons.logout, color: Colors.orange, size: 18),
                const SizedBox(width: 6),
                Text(checkOut),
                const Spacer(),
                if (duration.isNotEmpty) Text(duration),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔥 LOCATION
            Row(
              children: [
                const Icon(Icons.location_on,
                    size: 16, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    location,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}