class IzinModel {
  final String date;
  final String alasanIzin;
  final String status;

  IzinModel({
    required this.date,
    required this.alasanIzin,
    this.status = "Pending",
  });

  Map<String, dynamic> toJson() {
    return {"date": date, "alasan_izin": alasanIzin};
  }
}
