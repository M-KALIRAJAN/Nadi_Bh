import 'dart:convert';

Requestspointspeople requestspointspeopleFromJson(String str) =>
    Requestspointspeople.fromJson(json.decode(str));

String requestspointspeopleToJson(Requestspointspeople data) =>
    json.encode(data.toJson());

class Requestspointspeople {
  final bool success;
  final List<Datum> data;

  Requestspointspeople({
    required this.success,
    required this.data,
  });

  factory Requestspointspeople.fromJson(Map<String, dynamic> json) {
    return Requestspointspeople(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<Datum>.from(
              json['data'].map((x) => Datum.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data.map((x) => x.toJson()).toList(),
      };
}

class Datum {
  final String id;
  final BasicInfo basicInfo;
  final int? points;

  Datum({
    required this.id,
    required this.basicInfo,
    this.points,
  });

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json['_id'] ?? '',
      basicInfo: BasicInfo.fromJson(json['basicInfo'] ?? {}),
      points: json['points'] is int ? json['points'] : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'basicInfo': basicInfo.toJson(),
        'points': points,
      };
}

class BasicInfo {
  final String fullName;
  final int mobileNumber;
  final String email;

  BasicInfo({
    required this.fullName,
    required this.mobileNumber,
    required this.email,
  });

  factory BasicInfo.fromJson(Map<String, dynamic> json) {
    return BasicInfo(
      fullName: json['fullName'] ?? '',
      mobileNumber: json['mobileNumber'] is int
          ? json['mobileNumber']
          : int.tryParse(json['mobileNumber']?.toString() ?? '0') ?? 0,
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'mobileNumber': mobileNumber,
        'email': email,
      };
}
