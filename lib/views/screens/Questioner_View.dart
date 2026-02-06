import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/models/Questioner_Model.dart';
import 'package:nadi_user_app/providers/Questioner_Provider.dart';
import 'package:nadi_user_app/providers/userDashboard_provider.dart';
import 'package:nadi_user_app/services/Questioner_Service.dart';

class QuestionerView extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final QuestionerDatum questionerDatum;
  final VoidCallback? onSubmitted;

  const QuestionerView({
    super.key,
    required this.scrollController,
    required this.questionerDatum,
    this.onSubmitted,
  });

  @override
  ConsumerState<QuestionerView> createState() => _QuestionerViewState();
}

class _QuestionerViewState extends ConsumerState<QuestionerView> {

  final Map<int, int> selectedAnswers = {};
  int currentQuestionIndex = 0;
  bool isSubmitting = false;
  String? errorText;

  @override
  Widget build(BuildContext context) {

    final questions = widget.questionerDatum.questions;
    final question = questions[currentQuestionIndex];

    final bool isLastQuestion =
        currentQuestionIndex == questions.length - 1;

    return Column(
      children: [

        /// SCROLL AREA
        Expanded(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Question ${currentQuestionIndex + 1} of ${questions.length}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          question.question,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10),

                        ...List.generate(question.options.length, (oIndex) {

                          return RadioListTile<int>(
                            value: oIndex,
                            groupValue:
                                selectedAnswers[currentQuestionIndex],
                            activeColor: AppColors.btn_primery,
                            onChanged: (value) {

                              setState(() {
                                errorText = null;
                                selectedAnswers[currentQuestionIndex] = value!;
                              });
                            },
                            title: Text(question.options[oIndex]),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// ERROR TEXT
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        /// BUTTON
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(

              child: Text(
                isSubmitting
                    ? "Submitting..."
                    : (isLastQuestion ? "Submit" : "Next"),
              ),

              onPressed: isSubmitting ? null : () async {

                /// validation
                if (!selectedAnswers.containsKey(currentQuestionIndex)) {

                  setState(() {
                    errorText = "Please answer this question";
                  });

                  return;
                }

                /// next question
                if (!isLastQuestion) {

                  setState(() {
                    currentQuestionIndex++;
                  });

                  return;
                }

                /// FINAL SUBMIT
                setState(() => isSubmitting = true);

                final payload = {
                  "questionnaireId": widget.questionerDatum.id,
                  "answers": selectedAnswers.entries.map((e) => {
                    "questionIndex": e.key,
                    "selectedOption": e.value,
                  }).toList(),
                };

                try {

                  await QuestionerService()
                      .submitQuestionsData(payload: payload);

                  ref.invalidate(fetchquestionsdataprovider);
                  ref.refresh(userdashboardprovider);

                  widget.onSubmitted?.call();

                } catch (e) {

                  setState(() {
                    errorText = e.toString();
                  });

                } finally {

                  if (mounted) {
                    setState(() => isSubmitting = false);
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
