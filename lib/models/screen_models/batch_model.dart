class Batch {
  final int? id;
  final String? name;
  final String? batchKe;
  final String? startDate;
  final String? endDate;

  Batch({this.id, this.name, this.batchKe, this.startDate, this.endDate});

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'],
      name: json['name'] ?? "Batch ${json['batch_ke'] ?? ''}",
      batchKe: json['batch_ke']?.toString(),
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "batch_ke": batchKe,
      "start_date": startDate,
      "end_date": endDate,
    };
  }

  /// Display name for dropdown
  String get displayName => "Batch $batchKe";
}
