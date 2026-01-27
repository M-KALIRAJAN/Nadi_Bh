import 'dart:convert';

class Requestspointspeople {
    final bool success;
    final List<Datum> data;

    Requestspointspeople({
        required this.success,
        required this.data,
    });

    Requestspointspeople copyWith({
        bool? success,
        List<Datum>? data,
    }) => 
        Requestspointspeople(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory Requestspointspeople.fromRawJson(String str) => Requestspointspeople.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Requestspointspeople.fromJson(Map<String, dynamic> json) => Requestspointspeople(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

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

    Datum copyWith({
        BasicInfo? basicInfo,
        String? id,
        int? points,
    }) => 
        Datum(
            basicInfo: basicInfo ?? this.basicInfo,
            id: id ?? this.id,
            points: points ?? this.points,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        basicInfo: BasicInfo.fromJson(json["basicInfo"]),
        id: json["_id"],
        points: json["points"],
    );

    Map<String, dynamic> toJson() => {
        "basicInfo": basicInfo.toJson(),
        "_id": id,
        "points": points,
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

    BasicInfo copyWith({
        String? fullName,
        int? mobileNumber,
        String? email,
    }) => 
        BasicInfo(
            fullName: fullName ?? this.fullName,
            mobileNumber: mobileNumber ?? this.mobileNumber,
            email: email ?? this.email,
        );

    factory BasicInfo.fromRawJson(String str) => BasicInfo.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory BasicInfo.fromJson(Map<String, dynamic> json) => BasicInfo(
        fullName: json["fullName"],
        mobileNumber: json["mobileNumber"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "mobileNumber": mobileNumber,
        "email": email,
    };
}
