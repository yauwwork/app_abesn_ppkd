class Attendance {
  final int? id;
  final String date;
  final String checkIn;
  final String checkOut;
  final String status;
  final double? latitude;
  final double? longitude;
  final double? latitudeOut;
  final double? longitudeOut;
  final String? address;

  Attendance({
    this.id,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    this.latitude,
    this.longitude,
    this.latitudeOut,
    this.longitudeOut,
    this.address,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'],
      date: json['attendance_date'] ?? json['date'] ?? '',
      checkIn: json['check_in'] ?? json['check_in_time'] ?? '--:--',
      checkOut: json['check_out'] ?? json['check_out_time'] ?? '--:--',
      status: json['status'] ?? 'Hadir',
      latitude: _parseDouble(json['latitude'] ?? json['check_in_latitude']),
      longitude: _parseDouble(json['longitude'] ?? json['check_in_longitude']),
      latitudeOut: _parseDouble(json['check_out_latitude']),
      longitudeOut: _parseDouble(json['check_out_longitude']),
      address: json['address'],
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static List<Attendance> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((e) => Attendance.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}