class Endpoint {
  // 🔥 BASE URL PRODUCTION
  static const String baseUrl = "https://appabsensi.mobileprojp.com/api";

  // ============================================================================
  // AUTH
  // ============================================================================

  /// POST - Register
  static const String register = "$baseUrl/register";

  /// POST - Login
  static const String login = "$baseUrl/login";

  /// POST - Logout
  static const String logout = "$baseUrl/logout";

  /// POST - Forgot Password
  static const String forgotPassword = "$baseUrl/forgot-password";

  /// POST - Reset Password
  static const String resetPassword = "$baseUrl/reset-password";

  // ============================================================================
  // PROFILE
  // ============================================================================

  /// GET - Ambil data user / PUT - Update profile
  static const String profile = "$baseUrl/profile";

  /// PUT - Upload foto profil
  static const String uploadPhoto = "$baseUrl/profile/photo";

  // ============================================================================
  // ATTENDANCE
  // ============================================================================

  /// POST - Check In
  static const String checkIn = "$baseUrl/absen/check-in";

  /// POST - Check Out
  static const String checkOut = "$baseUrl/absen/check-out";

  /// GET - Absensi hari ini (?attendance_date=YYYY-MM-DD)
  static const String today = "$baseUrl/absen/today";

  /// GET - History absensi
  static const String history = "$baseUrl/absen/history";

  /// GET - Statistik (?start=YYYY-MM-DD&end=YYYY-MM-DD)
  static const String stats = "$baseUrl/absen/stats";

  /// DELETE - Hapus absen by ID
  static String deleteAbsen(int id) => "$baseUrl/absen/$id";

  // ============================================================================
  // PERMISSION / IZIN
  // ============================================================================

  /// POST - Submit izin / GET - List izin
  static const String permission = "$baseUrl/izin";

  // ============================================================================
  // MASTER DATA
  // ============================================================================

  /// GET - Training list
  static const String trainings = "$baseUrl/trainings";

  /// GET - Batch list
  static const String batches = "$baseUrl/batches";

  // ============================================================================
  // DETAIL
  // ============================================================================

  /// GET - Detail training by ID
  static String trainingById(int id) => "$baseUrl/trainings/$id";

  /// GET - Detail absensi by ID
  static String attendanceById(int id) => "$baseUrl/absen/$id";

  // ============================================================================
  // DEVICE TOKEN
  // ============================================================================

  /// POST - Simpan device token
  static const String deviceToken = "$baseUrl/device-token";
}
