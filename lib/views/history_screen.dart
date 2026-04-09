import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:app_abesn_ppkd/widgets/history_abesn_card.dart';
import 'package:app_abesn_ppkd/services/history_service.dart';
import 'package:app_abesn_ppkd/models/screen_models/history_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int selectedFilterIndex = 0;

  final List<String> filters = ['All', 'Present', 'Late', 'Absent'];

  List<Data> history = [];

  String getCurrentMonth() {
    final now = DateTime.now();
    return DateFormat('MMMM yyyy').format(now).toUpperCase();
  }

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  // 🔥 AMBIL DATA DARI API
  Future<void> loadHistory() async {
    final result = await HistoryService.getHistory();

    setState(() {
      history = result;
    });
  }

  // 🔥 FILTER
  List<Data> get filteredData {
    String selectedFilter = filters[selectedFilterIndex];

    if (selectedFilter == 'All') return history;

    return history.where((item) {
      String status = formatStatus(item);

      switch (selectedFilter) {
        case 'Present':
          return status == 'Present';
        case 'Late':
          return status == 'Late';
        case 'Absent':
          return status == 'Absent';
        default:
          return true;
      }
    }).toList();
  }

  // 🔥 FORMAT STATUS
  String formatStatus(Data item) {
    if (item.status == "Absent") return "Absent";

    if (item.checkInTime == null) return "Absent";

    final hour = int.parse(item.checkInTime!.split(":")[0]);

    if (hour > 8) return "Late";

    return "Present";
  }

  // 🔥 FORMAT LOKASI
  String formatLocation(Data item) {
    if (item.checkInLat != null && item.checkInLng != null) {
      return "${item.checkInLat}, ${item.checkInLng}";
    }
    return "-";
  }

  // 🔥 FORMAT DURASI
  String formatDuration(Data item) {
    if (item.checkInTime == null || item.checkOutTime == null) return "";

    final inTime = item.checkInTime!.split(":");
    final outTime = item.checkOutTime!.split(":");

    final inMinutes = int.parse(inTime[0]) * 60 + int.parse(inTime[1]);
    final outMinutes = int.parse(outTime[0]) * 60 + int.parse(outTime[1]);

    final diff = outMinutes - inMinutes;

    return "${diff ~/ 60}j ${diff % 60}m";
  }

  // 🔥 FORMAT TANGGAL
  String formatDate(String date) {
    DateTime dt = DateTime.parse(date);
    return "${dt.day}";
  }

  String getDayName(String date) {
    DateTime dt = DateTime.parse(date);

    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];

    return days[dt.weekday - 1];
  }

  bool isWeekend(String date) {
    DateTime dt = DateTime.parse(date);
    return dt.weekday == DateTime.saturday || dt.weekday == DateTime.sunday;
  }

  @override
  Widget build(BuildContext context) {
    final data = filteredData;

    return Scaffold(
      backgroundColor: AppColors.lightBlueCard,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text('History', style: TextStyle(color: Colors.white)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              /// 🔍 SEARCH
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by date...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              /// 🔥 FILTER
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    bool isSelected = selectedFilterIndex == index;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilterIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xffE7F0FF)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          filters[index],
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xff1E63F3)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getCurrentMonth(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    '${data.length} records',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              /// 🔥 LIST DATA
              Expanded(
                child: RefreshIndicator(
                  onRefresh: loadHistory,
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];

                      return HistoryCard(
                        date: formatDate(item.attendanceDate),
                        day: getDayName(item.attendanceDate),
                        checkIn: item.checkInTime ?? "-",
                        checkOut: item.checkOutTime ?? "-",
                        duration: formatDuration(item),
                        status: formatStatus(item),
                        location: formatLocation(item),
                        isWeekend: isWeekend(item.attendanceDate),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
