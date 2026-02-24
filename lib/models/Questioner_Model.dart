class Questioner {
  final bool success;
  final List<QuestionerDatum> data;

  Questioner({
    required this.success,
    required this.data,
  });

  factory Questioner.fromJson(Map<String, dynamic> json) {
    return Questioner(
      success: json["success"] ?? false,
      data: (json["data"] as List? ?? [])
          .map((e) => QuestionerDatum.fromJson(e))
          .toList(),
    );
  }
}

class QuestionerDatum {
  final String id;
  final String title;
  final int totalPoints;
  final List<Question> questions;
  final bool status;

  QuestionerDatum({
    required this.id,
    required this.title,
    required this.totalPoints,
    required this.questions,
    required this.status,
  });

  factory QuestionerDatum.fromJson(Map<String, dynamic> json) {
    return QuestionerDatum(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      totalPoints: json["totalPoints"] ?? 0,
      status: json["status"] ?? false,
      questions: (json["questions"] as List? ?? [])
          .map((e) => Question.fromJson(e))
          .toList(),
    );
  }
}

class Question {
  final String id;
  final String question;
  final List<String> options;
  final int? correctAnswer;
  final String type;
  final String? inputAnswer;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.type,
    this.inputAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json["_id"] ?? "",
      question: json["question"] ?? "",
      options: (json["options"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      correctAnswer: json["correctAnswer"],
      type: (json["type"] ?? "choose").toString().toLowerCase(),
      inputAnswer: json["inputAnswer"],
    );
  }
}