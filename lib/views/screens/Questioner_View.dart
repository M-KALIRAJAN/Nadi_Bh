import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/models/Questioner_Model.dart';
import 'package:nadi_user_app/providers/Questioner_Provider.dart';
import 'package:nadi_user_app/providers/userDashboard_provider.dart';
import 'package:nadi_user_app/services/Questioner_Service.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

class QuestionerView extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final QuestionerDatum questionerDatum;

  const QuestionerView({
    super.key,
    required this.scrollController,
    required this.questionerDatum,
  });

  @override
  ConsumerState<QuestionerView> createState() => _QuestionerViewState();
}

class _QuestionerViewState extends ConsumerState<QuestionerView> {
  final Map<int, int> selectedAnswers = {};

  int currentQuestionIndex = 0;
  bool isSubmitting = false;
  String? errorText;

  bool isSuccess = false;
  String successMessage = "";
  String pointsEarned = "";
  String totalUserPoints = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: isSuccess ? successUI() : questionUI(),
      ),
    );
  }

  /// ================= QUESTION UI =================

  Widget questionUI() {
    final questions = widget.questionerDatum.questions;
    final question = questions[currentQuestionIndex];

    final bool isLastQuestion = currentQuestionIndex == questions.length - 1;

    return SingleChildScrollView(
      key: const ValueKey("question"),
      controller: widget.scrollController,
      padding: const EdgeInsets.only(left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Questions ${currentQuestionIndex + 1} of ${questions.length}",
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 5),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(.05)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                ...List.generate(question.options.length, (oIndex) {
                  final bool isSelected =
                      selectedAnswers[currentQuestionIndex] == oIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        errorText = null;
                        selectedAnswers[currentQuestionIndex] = oIndex;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.btn_primery
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                        color: isSelected
                            ? AppColors.btn_primery.withOpacity(.08)
                            : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              question.options[oIndex],
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              size: 18,
                              color: AppColors.btn_primery,
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),

          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                errorText!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.btn_primery,
            ),
            child: Text(
              isSubmitting
                  ? "Submitting..."
                  : (isLastQuestion ? "Submit" : "Next →"),
              style: const TextStyle(color: Colors.white),
            ),
            onPressed: isSubmitting
                ? null
                : () async {
                    if (!selectedAnswers.containsKey(currentQuestionIndex)) {
                      setState(() {
                        errorText = "Please answer this question";
                      });
                      return;
                    }

                    if (!isLastQuestion) {
                      setState(() {
                        currentQuestionIndex++;
                      });
                      return;
                    }

                    await submitAnswers();
                  },
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  /// ================= SUCCESS UI =================

bool isDoneLoading = false;
  Widget successUI() {
    return Center(
      key: const ValueKey("success"),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),

            const SizedBox(height: 16),

            const Text(
              "Success!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(successMessage, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              "Points Earned: ${pointsEarned}",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 8),
            Text(
              "TotalUserPoints: ${totalUserPoints}",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            AppButton(
              isLoading:isDoneLoading ,
              onPressed: () async {
                   setState(() => isDoneLoading = true);
                await Future.delayed(const Duration(seconds: 2));

                if (!mounted) return;

                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
                 setState(() => isDoneLoading = true);
              },
              text: "Done",
              width: double.infinity,
              color: AppColors.btn_primery,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> submitAnswers() async {
    setState(() => isSubmitting = true);

    final payload = {
      "questionnaireId": widget.questionerDatum.id,
      "answers": selectedAnswers.entries
          .map((e) => {"questionIndex": e.key, "selectedOption": e.value})
          .toList(),
    };

    try {
      final response = await QuestionerService().submitQuestionsData(
        payload: payload,
      );

      setState(() {
        isSuccess = true;
        successMessage = response["message"];
        pointsEarned = response["pointsEarned"].toString();
        totalUserPoints = response["totalUserPoints"].toString();
      });

      ref.invalidate(fetchquestionsdataprovider);
      ref.refresh(userdashboardprovider);
    } catch (e) {
      setState(() {
        errorText = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }
}
