// To parse this JSON data, do
//
//     final privacypolicy = privacypolicyFromJson(jsonString);

import 'dart:convert';

Privacypolicy privacypolicyFromJson(String str) => Privacypolicy.fromJson(json.decode(str));

String privacypolicyToJson(Privacypolicy data) => json.encode(data.toJson());

class Privacypolicy {
    bool success;
    String message;
    List<Datum> data;

    Privacypolicy({
        required this.success,
        required this.message,
        required this.data,
    });

    factory Privacypolicy.fromJson(Map<String, dynamic> json) => Privacypolicy(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String id;
    String title;
    List<String> content;
    String link;
    String media;
    List<String> subs;
    bool isActive;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    Datum({
        required this.id,
        required this.title,
        required this.content,
        required this.link,
        required this.media,
        required this.subs,
        required this.isActive,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        title: json["title"],
        content: List<String>.from(json["content"].map((x) => x)),
        link: json["link"],
        media: json["media"],
        subs: List<String>.from(json["subs"].map((x) => x)),
        isActive: json["isActive"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "content": List<dynamic>.from(content.map((x) => x)),
        "link": link,
        "media": media,
        "subs": List<dynamic>.from(subs.map((x) => x)),
        "isActive": isActive,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}
