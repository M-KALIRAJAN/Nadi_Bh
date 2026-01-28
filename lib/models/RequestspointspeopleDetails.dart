import 'dart:convert';

class RequestspointspeopleDetails {
    final List<Datum> data;

    RequestspointspeopleDetails({
        required this.data,
    });

    RequestspointspeopleDetails copyWith({
        List<Datum>? data,
    }) => 
        RequestspointspeopleDetails(
            data: data ?? this.data,
        );

    factory RequestspointspeopleDetails.fromRawJson(String str) => RequestspointspeopleDetails.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RequestspointspeopleDetails.fromJson(Map<String, dynamic> json) => RequestspointspeopleDetails(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    final String id;
    final String request;
    final String senderId;
    final String receiverId;
    final String points;
    final String status;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int v;
    final String? reason;

    Datum({
        required this.id,
        required this.request,
        required this.senderId,
        required this.receiverId,
        required this.points,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        this.reason,
    });

    Datum copyWith({
        String? id,
        String? request,
        String? senderId,
        String? receiverId,
        String? points,
        String? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? v,
        String? reason,
    }) => 
        Datum(
            id: id ?? this.id,
            request: request ?? this.request,
            senderId: senderId ?? this.senderId,
            receiverId: receiverId ?? this.receiverId,
            points: points ?? this.points,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            v: v ?? this.v,
            reason: reason ?? this.reason,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        request: json["request"],
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        points: json["points"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        reason: json["reason"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "request": request,
        "senderId": senderId,
        "receiverId": receiverId,
        "points": points,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "reason": reason,
    };
}
