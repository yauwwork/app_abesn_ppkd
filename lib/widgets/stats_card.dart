import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:flutter/material.dart';

class MonthlyReportCard extends StatelessWidget {
  final int hadir;
  final int izin;
  final int telat;
  final int absen;

  const MonthlyReportCard({
    super.key,
    required this.hadir,
    required this.izin,
    required this.telat,
    required this.absen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _item("Hadir", hadir, AppColors.success),
          _item("Izin", izin, AppColors.info),
          _item("Telat", telat, AppColors.warning),
          _item("Absen", absen, AppColors.danger),
        ],
      ),
    );
  }

  Widget _item(String title, int value, Color color) {
    return Expanded(
      child: Column(
        children: [
          // 🔥 ANGKA BESAR (lebih clean dari bulatan)
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          const SizedBox(height: 4),

          // 🔥 LABEL
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 6),

          // 🔥 LINE INDICATOR (biar modern 🔥)
          Container(
            height: 4,
            width: 30,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }
}
