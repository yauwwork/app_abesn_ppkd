import 'package:app_abesn_ppkd/services/attandance_service.dart';
import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:app_abesn_ppkd/views/history.dart';
import 'package:app_abesn_ppkd/views/permission_form_screen.dart';
import 'package:app_abesn_ppkd/widgets/navigationbar.dart';
import 'package:flutter/material.dart';
import '../models/card_models/attendance_model.dart';
import '../widgets/activity_card.dart';
import '../widgets/attendance_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/today_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Attendance> attendanceList = [];
  bool isLoading = true;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await AttendanceService.getAttendance();

    setState(() {
      attendanceList = data;
      isLoading = false;
    });
  }

  Attendance? get todayData {
    if (attendanceList.isEmpty) return null;
    return attendanceList.last;
  }

  int get totalPresent =>
      attendanceList.where((e) => e.status == "Hadir").length;

  int get totalLate => attendanceList.where((e) => e.status == "Late").length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });

          // 🔥 NAVIGASI BERDASARKAN INDEX
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PermissionFormScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            );
            // } else if (index == 3) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => const ProfileScreen()),
            //   );
            // }
          }
        },
      ),
      backgroundColor: AppColors.lightBlueCard,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔥 HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.calendar_month,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "AttendEase",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const CircleAvatar(),
                      ],
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Good Morning, Alex! 👋",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔥 ATTENDANCE BUTTON
                    AttendanceCard(
                      onCheckIn: () {},
                      onCheckOut: () {},
                      currentTime: "09:22 AM",
                      checkIn: "08:45 AM",
                      checkOut: "--:--",
                    ),

                    const SizedBox(height: 20),

                    // 🔥 MONTHLY REPORT
                    const Text(
                      "Monthly Report",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    MonthlyReportCard(hadir: 20, izin: 2, telat: 3, absen: 1),

                    const SizedBox(height: 20),

                    // 🔥 QUICK ACTION
                    const Text(
                      "Quick Actions",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        QuickActionCard(
                          icon: Icons.description,
                          title: "Request\nPermission",
                          color: AppColors.info,
                          onTap: () {
                            print("Request");
                          },
                        ),
                        QuickActionCard(
                          icon: Icons.menu_book,
                          title: "Training",
                          color: AppColors.purple,
                          onTap: () {},
                        ),
                        QuickActionCard(
                          icon: Icons.access_time,
                          title: "View\nHistory",
                          color: AppColors.success,
                          onTap: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // 🔥 RECENT ACTIVITY
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Recent Activity",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "See all >",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Column(
                      children: attendanceList.map((e) {
                        return ActivityCard(
                          date: e.date,
                          time: "${e.checkIn} - ${e.checkOut}",
                          status: e.status,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
