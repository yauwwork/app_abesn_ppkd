class ProfileModel {
  final String name;
  final String email; // 🔥 tetap original
  final String phone;
  final String position;
  final String batch;
  final String photo;

  ProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.position,
    required this.batch,
    required this.photo,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? {};

    return ProfileModel(
      name: data["name"]?.toString() ?? "-",

      // 🔥 EMAIL JANGAN DIUTAK-ATIK
      email: data["email"] ?? "-",

      // 🔥 sisanya tetap aman
      phone: data["no_hp"]?.toString() ?? "-",
      position: data["training_title"]?.toString() ?? "-",
      batch: data["batch_ke"]?.toString() ?? "-",
      photo: data["profile_photo"]?.toString() ?? "",
    );
  }
}