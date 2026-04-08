import 'package:app_abesn_ppkd/utils/colors_app.dart';
import 'package:app_abesn_ppkd/utils/shared_preferences.dart';
import 'package:app_abesn_ppkd/views/login_screen.dart';
import 'package:app_abesn_ppkd/views/main_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 CEK TOKEN & DARK MODE
  final isLoggedIn = await PreferenceHandler.isLogin();
  final isDarkMode = await PreferenceHandler.getDarkMode();

  runApp(MyApp(isLoggedIn: isLoggedIn, isDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final bool isDarkMode;

  const MyApp({super.key, required this.isLoggedIn, required this.isDarkMode});

  // 🔥 GLOBAL KEY UNTUK AKSES THEME TOGGLE DARI MANA SAJA
  static final GlobalKey<_MyAppState> appKey = GlobalKey<_MyAppState>();

  static void toggleTheme(BuildContext context) {
    final state = context.findAncestorStateOfType<_MyAppState>();
    state?.toggleTheme();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    PreferenceHandler.saveDarkMode(_isDarkMode);
  }

  bool get isDarkMode => _isDarkMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absensi PPKD',
      debugShowCheckedModeBanner: false,

      // 🔥 LIGHT THEME
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Roboto',
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      // 🔥 DARK THEME
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        fontFamily: 'Roboto',
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkCard,
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 0,
        ),
        cardColor: AppColors.darkCard,
      ),

      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // 🔥 AUTO LOGIN CHECK
      home: widget.isLoggedIn ? const MainScreen() : const LoginScreen(),
    );
  }
}
