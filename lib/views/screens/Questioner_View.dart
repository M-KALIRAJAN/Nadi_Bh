import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/models/Questioner_Model.dart';
import 'package:nadi_user_app/services/Questioner_Service.dart';

class QuestionerView extends ConsumerStatefulWidget {
  final QuestionerDatum questionerDatum;

  const QuestionerView({
    super.key,
    required this.questionerDatum,
  });

  @override
  ConsumerState<QuestionerView> createState() => _QuestionerViewState();
}

class _QuestionerViewState extends ConsumerState<QuestionerView> {
  final Map<int, int> selectedAnswers = {};
  final Map<int, String> inputAnswers = {};

  int currentIndex = 0;
  bool isSubmitting = false;
  bool isSuccess = false;

  String successMessage = "";
  String pointsEarned = "";
  String totalPoints = "";
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return    isSuccess ? successUI() : questionUI();
  }

Widget questionUI() {
  final questions = widget.questionerDatum.questions;
  final question = questions[currentIndex];
  final isLast = currentIndex == questions.length - 1;

  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      mainAxisSize: MainAxisSize.min, // ✅ Important
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Question ${currentIndex + 1} of ${questions.length}",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),

        Text(
          question.question,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        /// CHOOSE TYPE
        if (question.type == "choose" &&
            question.options.isNotEmpty)
          ...List.generate(question.options.length, (i) {
            final isSelected =
                selectedAnswers[currentIndex] == i;

            return GestureDetector(
              onTap: () {
                setState(() {
                  errorText = null;
                  selectedAnswers[currentIndex] = i;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.green
                        : Colors.grey.shade300,
                  ),
                  color: isSelected
                      ? Colors.green.withOpacity(.1)
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(question.options[i])),
                    if (isSelected)
                      const Icon(Icons.check,
                          color: Colors.green)
                  ],
                ),
              ),
            );
          }),

        /// INPUT TYPE
        if (question.type == "input")
          TextField(
            decoration: const InputDecoration(
              hintText: "Type your answer",
              border: OutlineInputBorder(),
            ),
            onChanged: (val) {
              inputAnswers[currentIndex] = val;
            },
          ),

        if (errorText != null) ...[
          const SizedBox(height: 10),
          Text(
            errorText!,
            style: const TextStyle(color: Colors.red),
          )
        ],

        const SizedBox(height: 24),

        /// BUTTON
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isSubmitting
                ? null
                : () async {
                    if (question.type == "choose" &&
                        !selectedAnswers.containsKey(
                            currentIndex)) {
                      setState(() =>
                          errorText =
                              "Please select an option");
                      return;
                    }

                    if (question.type == "input" &&
                        (inputAnswers[currentIndex] ==
                                null ||
                            inputAnswers[currentIndex]!
                                .trim()
                                .isEmpty)) {
                      setState(() =>
                          errorText =
                              "Please enter your answer");
                      return;
                    }

                    if (!isLast) {
                      setState(() => currentIndex++);
                      return;
                    }

                    await submit();
                  },
            child: Text(isLast ? "Submit" : "Next"),
          ),
        ),
      ],
    ),
  );
}

  Widget successUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Success!",
              style:
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(successMessage),
            const SizedBox(height: 10),
            Text("Points Earned: $pointsEarned"),
            Text("Total Points: $totalPoints"),
            const SizedBox(height: 20),
            ElevatedButton(
             onPressed: () async {
  await Future.delayed(const Duration(seconds: 3));
  if (context.mounted) {
    Navigator.pop(context);
  }
},
              child: const Text("Done"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> submit() async {
    setState(() => isSubmitting = true);

    final payload = {
      "questionnaireId": widget.questionerDatum.id,
      "answers": List.generate(
        widget.questionerDatum.questions.length,
        (index) {
          final question =
              widget.questionerDatum.questions[index];

          return {
            "questionIndex": index,
            "selectedOption":
                question.type == "choose"
                    ? selectedAnswers[index]
                    : null,
            "inputAnswer":
                question.type == "input"
                    ? inputAnswers[index]
                    : null,
          };
        },
      ),
    };

    try {
      final response = await QuestionerService()
          .submitQuestionsData(payload: payload);

      setState(() {
        isSuccess = true;
        successMessage = response["message"] ?? "";
        pointsEarned =
            response["pointsEarned"].toString();
        totalPoints =
            response["totalUserPoints"].toString();
      });
    } catch (e) {
      setState(() => errorText = e.toString());
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }
}