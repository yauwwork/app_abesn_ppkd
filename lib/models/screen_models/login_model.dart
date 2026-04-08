class LoginModel {
  final String? message;
  final String? token;
  final User? user;

  const LoginModel({this.message, this.token, this.user});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return LoginModel(
      message: json['message'],
      token: data?['token'] ?? json['token'],
      user: data != null && data['user'] != null
          ? User.fromJson(data['user'])
          : json['user'] != null
              ? User.fromJson(json['user'])
              : null,
    );
  }
}

// ================= USER =================

class User {
  final int? id;
  final String? name;
  final String? email;

  const User({this.id, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], name: json['name'], email: json['email']);
  }
}
