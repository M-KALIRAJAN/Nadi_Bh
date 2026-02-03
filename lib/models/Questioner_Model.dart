import 'dart:convert';

class Questioner {
    final bool success;
    final List<QuestionerDatum> data;

    Questioner({
        required this.success,
        required this.data,
    });

    Questioner copyWith({
        bool? success,
        List<QuestionerDatum>? data,
    }) => 
        Questioner(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory Questioner.fromRawJson(String str) => Questioner.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Questioner.fromJson(Map<String, dynamic> json) => Questioner(
        success: json["success"],
        data: List<QuestionerDatum>.from(json["data"].map((x) => QuestionerDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class QuestionerDatum {
    final String id;
    final String title;
    final int totalPoints;
    final List<Question> questions;
    final bool status;
    final DateTime createdAt;
    final int v;

    QuestionerDatum({
        required this.id,
        required this.title,
        required this.totalPoints,
        required this.questions,
        required this.status,
        required this.createdAt,
        required this.v,
    });

    QuestionerDatum copyWith({
        String? id,
        String? title,
        int? totalPoints,
        List<Question>? questions,
        bool? status,
        DateTime? createdAt,
        int? v,
    }) => 
        QuestionerDatum(
            id: id ?? this.id,
            title: title ?? this.title,
            totalPoints: totalPoints ?? this.totalPoints,
            questions: questions ?? this.questions,
            status: status ?? this.status,
            createdAt: createdAt ?? this.createdAt,
            v: v ?? this.v,
        );

    factory QuestionerDatum.fromRawJson(String str) => QuestionerDatum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory QuestionerDatum.fromJson(Map<String, dynamic> json) => QuestionerDatum(
        id: json["_id"],
        title: json["title"],
        totalPoints: json["totalPoints"],
        questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "totalPoints": totalPoints,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "__v": v,
    };
}

class Question {
    final String question;
    final List<String> options;
    final int correctAnswer;
    final String id;

    Question({
        required this.question,
        required this.options,
        required this.correctAnswer,
        required this.id,
    });

    Question copyWith({
        String? question,
        List<String>? options,
        int? correctAnswer,
        String? id,
    }) => 
        Question(
            question: question ?? this.question,
            options: options ?? this.options,
            correctAnswer: correctAnswer ?? this.correctAnswer,
            id: id ?? this.id,
        );

    factory Question.fromRawJson(String str) => Question.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Question.fromJson(Map<String, dynamic> json) => Question(
        question: json["question"],
        options: List<String>.from(json["options"].map((x) => x)),
        correctAnswer: json["correctAnswer"],
        id: json["_id"],
    );

    Map<String, dynamic> toJson() => {
        "question": question,
        "options": List<dynamic>.from(options.map((x) => x)),
        "correctAnswer": correctAnswer,
        "_id": id,
    };
}
