class ProfileModel {
  final String name;
  final String email;
  final String? phone;
  final String? position;
  final String? batch;
  final String? photo;

  ProfileModel({
    required this.name,
    required this.email,
    this.phone,
    this.position,
    this.batch,
    this.photo,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? {};

    return ProfileModel(
      name: data["name"] ?? "-",
      email: data["email"] ?? "-",

      // 🔥 gak ada di API lo
      phone: data["no_hp"] ?? "-",

      // 🔥 ambil dari API asli
      position: data["training_title"] ?? "-",

      // 🔥 ambil dari API asli
      batch: data["batch_ke"] ?? "-",

      photo: data["profile_photo"],
    );
  }
}
