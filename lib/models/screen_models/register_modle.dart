class RegisterModel {
  final bool? success;
  final String? message;
  final User? user;
  final String? token;

  RegisterModel({this.success, this.message, this.user, this.token});

  factory RegisterModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return RegisterModel();

    final data = json['data'] as Map<String, dynamic>?;

    return RegisterModel(
      success: json['success'],
      message: json['message'],
      user: data != null && data['user'] != null
          ? User.fromJson(data['user'])
          : (data != null ? User.fromJson(data) : null), // Fallback if data directly contains user
      token: data != null && data['token'] != null
          ? data['token']
          : json['token'],
    );
  }
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? jenisKelamin;
  final int? trainingId;
  final int? batchId;

  User({
    this.id,
    this.name,
    this.email,
    this.jenisKelamin,
    this.trainingId,
    this.batchId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      jenisKelamin: json['jenis_kelamin'],
      trainingId: json['training_id'],
      batchId: json['batch_id'],
    );
  }
}
