// ================= TOP LEVEL =================

class Adminquestioner {
  final bool success;
  final List<Datum> data;

  Adminquestioner({
    required this.success,
    required this.data,
  });

  factory Adminquestioner.fromJson(Map<String, dynamic> json) {
    return Adminquestioner(
      success: json["success"] ?? false,
      data: (json["data"] as List<dynamic>?)
              ?.map((e) => Datum.fromJson(e))
              .toList() ??
          [],
    );
  }
}

// ================= DATUM =================

class Datum {
  final QuestionnaireId? questionnaireId;

  Datum({this.questionnaireId});

  factory Datum.fromJson(Map<String, dynamic> json) {
    return Datum(
      questionnaireId: json["questionnaireId"] != null
          ? QuestionnaireId.fromJson(json["questionnaireId"])
          : null,
    );
  }
}

// ================= QUESTIONNAIRE =================
// ================= QUESTIONNAIRE =================

class QuestionnaireId {
  final String id;           // ✅ ADD THIS
  final String title;        // optional but good
  final List<Question> questions;

  QuestionnaireId({
    required this.id,
    required this.title,
    required this.questions,
  });

  factory QuestionnaireId.fromJson(Map<String, dynamic> json) {
    return QuestionnaireId(
      id: json["_id"] ?? "",                // ✅ VERY IMPORTANT
      title: json["title"] ?? "",
      questions: (json["questions"] as List<dynamic>?)
              ?.map((e) => Question.fromJson(e))
              .toList() ??
          [],
    );
  }
}
// ================= QUESTION =================

class Question {
  final String question;
  final List<String> options;
  final int? correctAnswer;
  final String type;
  final String id;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.type,
    required this.id,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        question: json["question"] ?? "",
        options: (json["options"] as List<dynamic>?)
                ?.map((x) => x.toString())
                .toList() ??
            [],
        correctAnswer: json["correctAnswer"],
        type: json["type"] ?? "choose",
        id: json["_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "options": options,
        "correctAnswer": correctAnswer,
        "type": type,
        "_id": id,
      };
}