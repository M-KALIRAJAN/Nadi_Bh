import 'dart:convert';

class PointsNotifations {
  final bool success;
  final List<Datum> data;

  PointsNotifations({
    required this.success,
    required this.data,
  });

  PointsNotifations copyWith({
    bool? success,
    List<Datum>? data,
  }) {
    return PointsNotifations(
      success: success ?? this.success,
      data: data ?? this.data,
    );
  }

  factory PointsNotifations.fromRawJson(String str) =>
      PointsNotifations.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PointsNotifations.fromJson(Map<String, dynamic> json) {
    return PointsNotifations(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? List<Datum>.from(
              json['data'].map((x) => Datum.fromJson(x)),
            )
          : <Datum>[],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class Datum {
  final String id;
  final String message;
  final String type;
  final String userId;
  final DateTime time;
  final int v;

  Datum({
    required this.id,
    required this.message,
    required this.type,
    required this.userId,
    required this.time,
    required this.v,
  });

  Datum copyWith({
    String? id,
    String? message,
    String? type,
    String? userId,
    DateTime? time,
    int? v,
  }) {
    return Datum(
      id: id ?? this.id,
      message: message ?? this.message,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      time: time ?? this.time,
      v: v ?? this.v,
    );
  }

  factory Datum.fromRawJson(String str) =>
      Datum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      id: json['_id'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      userId: json['userId'] ?? '',
      time: json['time'] != null
          ? DateTime.parse(json['time'])
          : DateTime.now(),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'message': message,
      'type': type,
      'userId': userId,
      'time': time.toIso8601String(),
      '__v': v,
    };
  }
}
