import 'dart:convert';

class Advertisementmodel {
    final bool success;
    final List<Datum> data;

    Advertisementmodel({
        required this.success,
        required this.data,
    });

    Advertisementmodel copyWith({
        bool? success,
        List<Datum>? data,
    }) => 
        Advertisementmodel(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory Advertisementmodel.fromRawJson(String str) => Advertisementmodel.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Advertisementmodel.fromJson(Map<String, dynamic> json) => Advertisementmodel(
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
    final dynamic video;
    final List<Ad> ads;
    final bool status;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int v;

    Datum({
        required this.id,
        required this.video,
        required this.ads,
        required this.status,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    Datum copyWith({
        String? id,
        dynamic video,
        List<Ad>? ads,
        bool? status,
        DateTime? createdAt,
        DateTime? updatedAt,
        int? v,
    }) => 
        Datum(
            id: id ?? this.id,
            video: video ?? this.video,
            ads: ads ?? this.ads,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            updatedAt: updatedAt ?? this.updatedAt,
            v: v ?? this.v,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        video: json["video"],
        ads: List<Ad>.from(json["ads"].map((x) => Ad.fromJson(x))),
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "video": video,
        "ads": List<dynamic>.from(ads.map((x) => x.toJson())),
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}

class Ad {
    final String image;
    final String link;
    final String id;

    Ad({
        required this.image,
        required this.link,
        required this.id,
    });

    Ad copyWith({
        String? image,
        String? link,
        String? id,
    }) => 
        Ad(
            image: image ?? this.image,
            link: link ?? this.link,
            id: id ?? this.id,
        );

    factory Ad.fromRawJson(String str) => Ad.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Ad.fromJson(Map<String, dynamic> json) => Ad(
        image: json["image"],
        link: json["link"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "image": image,
        "link": link,
        "_id": id,
    };
}
