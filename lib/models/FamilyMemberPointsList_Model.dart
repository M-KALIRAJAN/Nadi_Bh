import 'dart:convert';

class FamilyMemberPointsList {
  final bool success;
  final List<Datum> data;

  FamilyMemberPointsList({
    required this.success,
    required this.data,
  });

  factory FamilyMemberPointsList.fromRawJson(String str) =>
      FamilyMemberPointsList.fromJson(json.decode(str));

  factory FamilyMemberPointsList.fromJson(Map<String, dynamic> json) {
    return FamilyMemberPointsList(
      success: json["success"] ?? false,
      data: json["data"] == null
          ? []
          : List<Datum>.from(
              json["data"].map((x) => Datum.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  final BasicInfo basicInfo;
  final String id;
  final int points;

  Datum({
    required this.basicInfo,
    required this.id,
    required this.points,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      basicInfo: BasicInfo.fromJson(json["basicInfo"] ?? {}),
      id: json["_id"]?.toString() ?? "",
      points: json["points"] is int
          ? json["points"]
          : int.tryParse(json["points"].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "basicInfo": basicInfo.toJson(),
        "_id": id,
        "points": points,
      };
}

class BasicInfo {
  final String fullName;
  final String mobileNumber;
  final String email;

  BasicInfo({
    required this.fullName,
    required this.mobileNumber,
    required this.email,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      fullName: json["fullName"]?.toString() ?? "",
      mobileNumber: json["mobileNumber"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "mobileNumber": mobileNumber,
        "email": email,
      };
}
