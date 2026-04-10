import 'dart:async';
import 'dart:developer';
import 'package:app_abesn_ppkd/services/attandance_service.dart';
import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:app_abesn_ppkd/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../models/card_models/attendance_model.dart';
import '../widgets/activity_card.dart';
import '../widgets/attendance_card.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/stats_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "User";
  String currentTime = "";
  Timer? _timer;

  // Data from API
  Attendance? todayData;
  Map<String, dynamic> statsData = {
    "hadir": 0,
    "izin": 0,
    "terlambat": 0,
    "absen": 0,
  };
  List<Attendance> recentHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _startClock();
    _loadData();
  }

  void _startClock() {
    currentTime = DateFormat('hh:mm a').format(DateTime.now());
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          currentTime = DateFormat('hh:mm a').format(DateTime.now());
        });
      }
    });
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      final user = await PreferenceHandler.getUser();
      userName = user['name']?.split(' ').first ?? "User";

      // Fetch Today
      final todayRes = await AttendanceService.getToday();
      if (todayRes != null && todayRes['data'] != null) {
        todayData = Attendance.fromJson(todayRes['data']);
      }

      // Fetch Stats for current month
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, 1).toString().split(' ')[0];
      final end = DateTime(now.year, now.month + 1, 0).toString().split(' ')[0];
      final statsRes = await AttendanceService.getStats(start: start, end: end);
      if (statsRes != null && statsRes['data'] != null) {
        statsData = statsRes['data'];
      }

      // Fetch History
      final historyRes = await AttendanceService.getHistory();
      recentHistory = Attendance.listFromJson(historyRes);
      if (recentHistory.length > 5) {
        recentHistory = recentHistory.sublist(0, 5); // Take top 5
      }
    } catch (e) {
      log("Error load home: $e");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<Position?> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError("Location services are disabled.");
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError("Location permissions are denied");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError("Location permissions are permanently denied.");
      return null;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _showLoading("Mendapatkan lokasi...");
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      _showError("Gagal mendapatkan lokasi");
      return null;
    } finally {
      Navigator.pop(context); // close dialog loading
    }
  }

  Future<void> _onCheckIn() async {
    final pos = await _getLocation();
    if (pos == null) return;

    _showLoading("Processing Check In...");
    try {
      final res = await AttendanceService.checkIn(
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
      _showSuccess(res['message'] ?? "Check In Sukses");
      _loadData();
    } catch (e) {
      _showError(e.toString().replaceAll("Exception: ", ""));
    } finally {
      Navigator.pop(context); // close loading dialog
    }
  }

  Future<void> _onCheckOut() async {
    final pos = await _getLocation();
    if (pos == null) return;

    _showLoading("Processing Check Out...");
    try {
      final res = await AttendanceService.checkOut(
        latitude: pos.latitude,
        longitude: pos.longitude,
      );
      _showSuccess(res['message'] ?? "Check Out Sukses");
      _loadData();
    } catch (e) {
      _showError(e.toString().replaceAll("Exception: ", ""));
    } finally {
      Navigator.pop(context); // close dialog
    }
  }

  void _showLoading(String msg) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(child: Text(msg)),
          ],
        ),
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.danger),
    );
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.success),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  //ACTIVITY CARD LOGIC
  String mapStatusToEnglish(String? status, String? checkInTime) {
    if (status == "izin") return "Absent";

    if (checkInTime == null || checkInTime == "-") return "Absent";

    final hour = int.parse(checkInTime.split(":")[0]);

    if (hour > 8) return "Late";

    return "Present";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueCard,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                                "WorkZen",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Good Morning, $userName! 👋",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔥 ATTENDANCE BUTTON
                      AttendanceCard(
                        onCheckIn: _onCheckIn,
                        onCheckOut: _onCheckOut,
                        currentTime: currentTime,
                        checkIn: todayData?.checkIn ?? "--:--",
                        checkOut: todayData?.checkOut ?? "--:--",
                      ),

                      const SizedBox(height: 20),

                      // 🔥 MONTHLY REPORT
                      const Text(
                        "Monthly Report",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      MonthlyReportCard(
                        hadir: statsData['hadir'] ?? 0,
                        izin: statsData['izin'] ?? 0,
                        telat: statsData['terlambat'] ?? 0,
                        absen: statsData['absen'] ?? 0,
                      ),

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
                              // Navigate via parent's state to permission form index (1)
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
                            onTap: () {
                              // Navigate via parent's state to history index (2)
                            },
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
                        ],
                      ),
                      const SizedBox(height: 10),

                      if (recentHistory.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "Belum ada data history absen",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        Column(
                          children: recentHistory.map((e) {
                            return ActivityCard(
                              date: e.date,
                              time: "${e.checkIn} - ${e.checkOut}",
                              status: mapStatusToEnglish(
                                e.status,
                                e.checkIn,
                              ), // 🔥 FIX
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
