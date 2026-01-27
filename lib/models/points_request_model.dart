class PointsRequestModel {
  final BasicInfo basicInfo;
  final int points;
  final String reason;
  final DateTime createdAt;

  PointsRequestModel({
    required this.basicInfo,
    required this.points,
    required this.reason,
    required this.createdAt,
  });

  factory PointsRequestModel.fromJson(Map<String, dynamic> json) {
    return PointsRequestModel(
      basicInfo: BasicInfo.fromJson(
        json['senderId']['basicInfo'],
      ),
      points: int.parse(json['points'].toString()),
      reason: json['reason'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class BasicInfo {
  final String fullName;
  final int mobileNumber;
  final String email;
  final String gender;

  BasicInfo({
    required this.fullName,
    required this.mobileNumber,
    required this.email,
    required this.gender,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      fullName: json['fullName'] ?? '',
      mobileNumber: json['mobileNumber'] ?? 0,
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
    );
  }
}
