class IzinModel {
  final String date;
  final String alasanIzin;

  IzinModel({
    required this.date,
    required this.alasanIzin,
  });

  // 🔥 convert ke JSON (buat request body)
  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "alasan_izin": alasanIzin,
    };
  }
}