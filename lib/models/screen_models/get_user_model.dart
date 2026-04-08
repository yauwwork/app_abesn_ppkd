import 'package:app_abesn_ppkd/models/screen_models/batch_model.dart';
import 'package:app_abesn_ppkd/models/screen_models/training_model.dart';

class GetUserModel {
  final String? message;
  final UserData? data;

  GetUserModel({this.message, this.data});

  factory GetUserModel.fromJson(Map<String, dynamic> json) {
    return GetUserModel(
      message: json['message'],
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"message": message, "data": data?.toJson()};
  }
}

class UserData {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? photo;
  final int? trainingId;
  final int? batchId;
  final String? jenisKelamin;

  final Batch? batch;
  final Training? training;

  UserData({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.photo,
    this.trainingId,
    this.batchId,
    this.jenisKelamin,
    this.batch,
    this.training,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],

      // 🔥 HANDLE BANYAK FORMAT BACKEND
      phone: _readString(json, ['phone', 'no_hp', 'nomor_hp']),

      photo: _readString(json, ['photo', 'photo_url', 'profile_photo_url']),

      trainingId: _readInt(json, ['training_id']),
      batchId: _readInt(json, ['batch_id']),
      jenisKelamin: json['jenis_kelamin'],

      batch: json['batch'] != null ? Batch.fromJson(json['batch']) : null,

      training: json['training'] != null
          ? Training.fromJson(json['training'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "photo": photo,
      "training_id": trainingId,
      "batch_id": batchId,
      "jenis_kelamin": jenisKelamin,
      "batch": batch?.toJson(),
      "training": training?.toJson(),
    };
  }

  // 🔥 HELPER BIAR AMAN DARI API BERBEDA-BEDA

  static String? _readString(Map<String, dynamic> json, List<String> keys) {
    for (var key in keys) {
      final val = json[key];
      if (val is String && val.isNotEmpty) {
        return val;
      }
    }
    return null;
  }

  static int? _readInt(Map<String, dynamic> json, List<String> keys) {
    for (var key in keys) {
      final val = json[key];
      if (val is int) return val;
      if (val is String) {
        final parsed = int.tryParse(val);
        if (parsed != null) return parsed;
      }
    }
    return null;
  }
}
