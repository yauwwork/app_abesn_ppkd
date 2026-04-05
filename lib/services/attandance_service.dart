import 'package:app_abesn_ppkd/models/card_models/attendance_model.dart';

class AttendanceService {
  static Future<List<Attendance>> getAttendance() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      Attendance(
        date: "01 April 2026",
        checkIn: "08:00",
        checkOut: "17:00",
        status: "Hadir",
      ),
      Attendance(
        date: "02 April 2026",
        checkIn: "08:10",
        checkOut: "17:05",
        status: "Hadir",
      ),
    ];
  }
}