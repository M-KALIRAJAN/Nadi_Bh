// To parse this JSON data, do
//
//     final helpandsupport = helpandsupportFromJson(jsonString);

import 'dart:convert';

Helpandsupport helpandsupportFromJson(String str) => Helpandsupport.fromJson(json.decode(str));

String helpandsupportToJson(Helpandsupport data) => json.encode(data.toJson());

class Helpandsupport {
    bool success;
    List<Datum> data;

    Helpandsupport({
        required this.success,
        required this.data,
    });

    factory Helpandsupport.fromJson(Map<String, dynamic> json) => Helpandsupport(
        success: json["success"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    String content;
    String link;
    bool isActive;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    Datum({
        required this.id,
        required this.content,
        required this.link,
        required this.isActive,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        content: json["content"],
        link: json["link"],
        isActive: json["isActive"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "content": content,
        "link": link,
        "isActive": isActive,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
