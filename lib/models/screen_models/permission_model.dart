class PermissionModel {
  final String type;
  final String startDate;
  final String endDate;
  final String reason;
  final String notes;
  final String status;
  final String? imagePath;

  PermissionModel({
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.notes,
    required this.status,
    this.imagePath,
  });
}

// 🔥 TEMP STORAGE (kayak database sementara)
List<PermissionModel> permissionList = [];
