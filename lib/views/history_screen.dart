import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:app_abesn_ppkd/widgets/history_abesn_card.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int selectedFilterIndex = 0;

  final List<String> filters = ['All', 'Present', 'Late', 'Absent'];

  List<Map<String, dynamic>> historyData = [];

  @override
  void initState() {
    super.initState();
    fetchActivityData();
  }

  // 🔥 SIMULASI DATA DARI ACTIVITY (NANTI GANTI API)
  Future<void> fetchActivityData() async {
    // contoh response activity
    final List<Map<String, dynamic>> activity = [
      {
        "date": "2026-04-07",
        "type": "checkin",
        "time": "08:00",
        "status": "Hadir",
      },
      {
        "date": "2026-04-07",
        "type": "checkout",
        "time": "17:00",
        "status": "Hadir",
      },
      {
        "date": "2026-04-05",
        "type": "checkin",
        "time": "09:10",
        "status": "Late",
      },
      {
        "date": "2026-04-05",
        "type": "checkout",
        "time": "17:00",
        "status": "Late",
      },
    ];

    // 🔥 GROUP BY DATE
    Map<String, Map<String, dynamic>> grouped = {};

    for (var item in activity) {
      String date = item['date'];

      if (!grouped.containsKey(date)) {
        grouped[date] = {
          'date': date.substring(8, 10),
          'day': _getDayName(date),
          'checkIn': '-',
          'checkOut': '-',
          'duration': '',
          'status': item['status'],
          'isWeekend': _isWeekend(date),
        };
      }

      if (item['type'] == 'checkin') {
        grouped[date]!['checkIn'] = item['time'];
      } else if (item['type'] == 'checkout') {
        grouped[date]!['checkOut'] = item['time'];
      }
    }

    setState(() {
      historyData = grouped.values.toList();
    });
  }

  // 🔥 FILTER
  List<Map<String, dynamic>> get filteredData {
    String selectedFilter = filters[selectedFilterIndex];

    if (selectedFilter == 'All') return historyData;

    return historyData.where((item) {
      switch (selectedFilter) {
        case 'Present':
          return item['status'] == 'Hadir';
        case 'Late':
          return item['status'] == 'Late';
        case 'Absent':
          return item['status'] == 'Absent';
        default:
          return true;
      }
    }).toList();
  }

  // 🔥 GET DAY NAME
  String _getDayName(String date) {
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

  // 🔥 CEK WEEKEND
  bool _isWeekend(String date) {
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
        automaticallyImplyLeading: false,
        title: const Text(
          'History',
          style: TextStyle(color: AppColors.card, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by date...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 14),

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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'APRIL 2026',
                    style: TextStyle(
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

              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    return HistoryCard(
                      date: item['date'],
                      day: item['day'],
                      checkIn: item['checkIn'],
                      checkOut: item['checkOut'],
                      duration: item['duration'],
                      status: item['status'],
                      isWeekend: item['isWeekend'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
