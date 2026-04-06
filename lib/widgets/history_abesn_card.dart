import 'package:flutter/material.dart';

class HistoryCard extends StatelessWidget {
  final String date;
  final String day;
  final String checkIn;
  final String checkOut;
  final String duration;
  final String status;
  final Color statusColor;
  final bool isWeekend;

  const HistoryCard({
    super.key,
    required this.date,
    required this.day,
    required this.checkIn,
    required this.checkOut,
    required this.duration,
    required this.status,
    required this.statusColor,
    required this.isWeekend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isWeekend ? const Color(0xffF7F7F7) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isWeekend ? Border.all(color: Colors.grey.shade300) : null,
        boxShadow: isWeekend
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Opacity(
        opacity: isWeekend ? 0.6 : 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(Icons.login, color: Colors.green, size: 18),
                const SizedBox(width: 6),
                Text(
                  checkIn,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.logout, color: Colors.deepOrange, size: 18),
                const SizedBox(width: 6),
                Text(
                  checkOut,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                if (duration.isNotEmpty)
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        duration,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
