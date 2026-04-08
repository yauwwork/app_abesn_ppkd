import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:app_abesn_ppkd/views/history_screen.dart';
import 'package:app_abesn_ppkd/views/profile_screen.dart';
import 'package:app_abesn_ppkd/widgets/navigationbar.dart';
import 'package:flutter/material.dart';

// IMPORT SEMUA SCREEN
import 'home_screen.dart';
import 'permission_form_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    const PermissionFormScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBlueCard,
      body: IndexedStack(index: currentIndex, children: pages),

      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
