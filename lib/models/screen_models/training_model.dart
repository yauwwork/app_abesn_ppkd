class Training {
  final int id;
  final String title;

  Training({required this.id, required this.title});

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "title": title};
  }

  /// 🔥 helper convert list API → List<Training>
  static List<Training> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((e) => Training.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
