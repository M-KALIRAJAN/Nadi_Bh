import 'dart:convert';

class PointsHistory {
    final bool success;
    final List<Datum> data;

    PointsHistory({
        required this.success,
        required this.data,
    });

    PointsHistory copyWith({
        bool? success,
        List<Datum>? data,
    }) => 
        PointsHistory(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory PointsHistory.fromRawJson(String str) => PointsHistory.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory PointsHistory.fromJson(Map<String, dynamic> json) => PointsHistory(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    final String id;
    final String userId;
    final String history;
    final int points;
    final DateTime time;
    final String status;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int v;

    Datum({
        required this.id,
        required this.userId,
        required this.history,
        required this.points,
        required this.time,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    Datum copyWith({
        String? id,
        String? userId,
        String? history,
        int? points,
        DateTime? time,
        String? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? v,
    }) => 
        Datum(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            history: history ?? this.history,
            points: points ?? this.points,
            time: time ?? this.time,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            v: v ?? this.v,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        userId: json["userId"],
        history: json["history"],
        points: json["points"],
        time: DateTime.parse(json["time"]),
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "history": history,
        "points": points,
        "time": time.toIso8601String(),
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
