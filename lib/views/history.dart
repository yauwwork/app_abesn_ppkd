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

  final List<Map<String, dynamic>> attendanceHistory = [
    {
      'date': 'April 2, 2026',
      'day': 'Thursday',
      'checkIn': '08:45 AM',
      'checkOut': '--:--',
      'duration': '',
      'status': 'Present',
      'statusColor': Colors.green,
      'isWeekend': false,
    },
    {
      'date': 'April 1, 2026',
      'day': 'Wednesday',
      'checkIn': '08:32 AM',
      'checkOut': '05:15 PM',
      'duration': '8h 43m',
      'status': 'Present',
      'statusColor': Colors.green,
      'isWeekend': false,
    },
    {
      'date': 'March 31, 2026',
      'day': 'Tuesday',
      'checkIn': '08:30 AM',
      'checkOut': '05:00 PM',
      'duration': '8h 30m',
      'status': 'Present',
      'statusColor': Colors.green,
      'isWeekend': false,
    },
    {
      'date': 'March 30, 2026',
      'day': 'Monday',
      'checkIn': '09:15 AM',
      'checkOut': '05:30 PM',
      'duration': '8h 15m',
      'status': 'Late',
      'statusColor': Colors.orange,
      'isWeekend': false,
    },
    {
      'date': 'March 29, 2026',
      'day': 'Sunday',
      'checkIn': '--:--',
      'checkOut': '--:--',
      'duration': '',
      'status': 'Weekend',
      'statusColor': Colors.grey,
      'isWeekend': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueCard,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xffEEF4FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              color: Color(0xff1E63F3),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              TextField(
                decoration: InputDecoration(
                  hintText: 'Search by date...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey.shade300),
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
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
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
                children: const [
                  Text(
                    'APRIL 2026',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black54,
                    ),
                  ),
                  Text('12 records', style: TextStyle(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 14),

              Expanded(
                child: ListView.builder(
                  itemCount: attendanceHistory.length,
                  itemBuilder: (context, index) {
                    final item = attendanceHistory[index];

                    return HistoryCard(
                      date: item['date'],
                      day: item['day'],
                      checkIn: item['checkIn'],
                      checkOut: item['checkOut'],
                      duration: item['duration'],
                      status: item['status'],
                      statusColor: item['statusColor'],
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
