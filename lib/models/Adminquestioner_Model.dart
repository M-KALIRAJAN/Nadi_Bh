import 'dart:convert';

class Adminquestioner {
    final bool success;
    final List<Datum> data;

    Adminquestioner({
        required this.success,
        required this.data,
    });

    Adminquestioner copyWith({
        bool? success,
        List<Datum>? data,
    }) => 
        Adminquestioner(
            success: success ?? this.success,
            data: data ?? this.data,
        );

    factory Adminquestioner.fromRawJson(String str) => Adminquestioner.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Adminquestioner.fromJson(Map<String, dynamic> json) => Adminquestioner(
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
    final QuestionnaireId questionnaireId;
    final bool status;
    final DateTime assignedAt;
    final int v;

    Datum({
        required this.id,
        required this.userId,
        required this.questionnaireId,
        required this.status,
        required this.assignedAt,
        required this.v,
    });

    Datum copyWith({
        String? id,
        String? userId,
        QuestionnaireId? questionnaireId,
        bool? status,
        DateTime? assignedAt,
        int? v,
    }) => 
        Datum(
            id: id ?? this.id,
            userId: userId ?? this.userId,
            questionnaireId: questionnaireId ?? this.questionnaireId,
            status: status ?? this.status,
            assignedAt: assignedAt ?? this.assignedAt,
            v: v ?? this.v,
        );

    factory Datum.fromRawJson(String str) => Datum.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["_id"],
        userId: json["userId"],
        questionnaireId: QuestionnaireId.fromJson(json["questionnaireId"]),
        status: json["status"],
        assignedAt: DateTime.parse(json["assignedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "questionnaireId": questionnaireId.toJson(),
        "status": status,
        "assignedAt": assignedAt.toIso8601String(),
        "__v": v,
    };
}

class QuestionnaireId {
    final String id;
    final String title;
    final int totalPoints;
    final List<Question> questions;
    final DateTime createdAt;
    final int v;

    QuestionnaireId({
        required this.id,
        required this.title,
        required this.totalPoints,
        required this.questions,
        required this.createdAt,
        required this.v,
    });

    QuestionnaireId copyWith({
        String? id,
        String? title,
        int? totalPoints,
        List<Question>? questions,
        DateTime? createdAt,
        int? v,
    }) => 
        QuestionnaireId(
            id: id ?? this.id,
            title: title ?? this.title,
            totalPoints: totalPoints ?? this.totalPoints,
            questions: questions ?? this.questions,
            createdAt: createdAt ?? this.createdAt,
            v: v ?? this.v,
        );

    factory QuestionnaireId.fromRawJson(String str) => QuestionnaireId.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory QuestionnaireId.fromJson(Map<String, dynamic> json) => QuestionnaireId(
        id: json["_id"],
        title: json["title"],
        totalPoints: json["totalPoints"],
        questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "totalPoints": totalPoints,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
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
