import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/providers/AdminQuestionRequest_Provider.dart';
import 'package:nadi_user_app/providers/AdminQuestioner_Provider.dart';
import 'package:nadi_user_app/providers/pointshistory_provider.dart';
import 'package:nadi_user_app/services/admin_questioner.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

class AdminQuestionerview extends ConsumerStatefulWidget {
  const AdminQuestionerview({super.key});

  @override
  ConsumerState<AdminQuestionerview> createState() =>
      _AdminQuestionerviewState();
}

class _AdminQuestionerviewState extends ConsumerState<AdminQuestionerview>
    with SingleTickerProviderStateMixin {
  final Map<int, int> selectedAnswers = {};
  final Map<int, TextEditingController> inputControllers = {};

  final AdminQuestioner adminQuestioner = AdminQuestioner();

  int currentQuestionIndex = 0;
  String? errorMessage;

  bool isSuccess = false;
  bool isSubmitting = false;
  String successMessage = "";
  String pointsEarned = "";
  String totalUserPoints = "";

  AnimationController? _controller;
  Animation<double>? _scaleAnimation;
  Animation<double>? _fadeAnimation;
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.refresh(fetchadminquestionrequestprovider);
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeIn,
    );
  }

  void nextQuestion(int totalQuestions, questions) {
    final currentQuestion = questions[currentQuestionIndex];

    bool isValid = false;

    if (currentQuestion.type == "choose") {
      isValid = selectedAnswers.containsKey(currentQuestionIndex);
    } else if (currentQuestion.type == "input") {
      isValid =
          inputControllers[currentQuestionIndex]?.text.trim().isNotEmpty ??
          false;
    }

    if (!isValid) {
      setState(() {
        errorMessage = "Please answer before moving next";
      });
      return;
    }

    setState(() {
      errorMessage = null;
      if (currentQuestionIndex < totalQuestions - 1) {
        currentQuestionIndex++;
      }
    });
  }

  void previousQuestion() {
    setState(() {
      errorMessage = null;
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
      }
    });
  }

  Future<void> submitQuestions(List questions, String questionnaireId) async {
    setState(() {
      isSubmitting = true; //  START LOADING
    });

    List<Map<String, dynamic>> answers = [];
    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      if (question.type == "choose") {
        answers.add({"questionIndex": i, "selectedOption": selectedAnswers[i]});
      } else if (question.type == "input") {
        answers.add({
          "questionIndex": i,
          "selectedOption": inputControllers[i]?.text.trim() ?? "",
        });
      }
    }

    final payload = {"questionnaireId": questionnaireId, "answers": answers};

    try {
      final response = await adminQuestioner.submitquestiondatas(
        payload: payload,
      );

      setState(() {
        isSuccess = true;
        successMessage = response["message"] ?? "Submitted successfully";
        pointsEarned = response["pointsEarned"].toString();
        totalUserPoints = response["totalUserPoints"].toString();
      });
      _controller?.forward();
      ref.refresh(fetchadminquestionerprovider);
      ref.refresh(pointshistoryprovider);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        isSubmitting = false; // 🔥 STOP LOADING
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adminRequest = ref.watch(fetchadminquestionrequestprovider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Q & A Conversation",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.gold_coin,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isSuccess
          ? successUI()
          : adminRequest.when(
              data: (response) {
                final adminList = response.data;

                if (adminList.isEmpty) {
                  return const Center(child: Text("No admin questions"));
                }

                // Filter only items that have questionnaire
                final validItems = adminList
                    .where((item) => item.questionnaireId != null)
                    .toList();

                if (validItems.isEmpty) {
                  return const Center(child: Text("No questions available"));
                }

                final questionnaire = validItems.first.questionnaireId!;

                if (questionnaire.questions.isEmpty) {
                  return const Center(child: Text("No questions available"));
                }

                final questions = questionnaire.questions;

                final totalQuestions = questions.length;
                final currentQuestion = questions[currentQuestionIndex];

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Question ${currentQuestionIndex + 1} of $totalQuestions",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      /// QUESTION CARD
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 40,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentQuestion.question,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                /// TYPE BASED UI
                                if (currentQuestion.type == "choose")
                                  ...List.generate(currentQuestion.options.length, (
                                    index,
                                  ) {
                                    final isSelected =
                                        selectedAnswers[currentQuestionIndex] ==
                                        index;

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedAnswers[currentQuestionIndex] =
                                              index;
                                          errorMessage = null;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.gold_coin.withOpacity(
                                                  0.1,
                                                )
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.gold_coin
                                                : Colors.grey.shade300,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                currentQuestion.options[index],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            if (isSelected)
                                              Container(
                                                height: 22,
                                                width: 22,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.gold_coin,
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  size: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                                else if (currentQuestion.type == "input")
                                  TextField(
                                    controller: inputControllers.putIfAbsent(
                                      currentQuestionIndex,
                                      () => TextEditingController(),
                                    ),
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    minLines: 3, // starting height
                                    maxLines: null, // grows automatically
                                    decoration: InputDecoration(
                                      hintText: "Enter your answer",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),

                                if (errorMessage != null) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// NAVIGATION BUTTONS
                      Row(
                        children: [
                          if (currentQuestionIndex > 0)
                            Expanded(
                              child: AppButton(
                                height: 47,
                                text: "Previous",
                                color: Colors.grey,
                                width: double.infinity,
                                onPressed: previousQuestion,
                              ),
                            ),
                          if (currentQuestionIndex > 0)
                            const SizedBox(width: 10),
                          Expanded(
                            child: isSubmitting
                                ? Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: AppColors.gold_coin,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                : AppButton(
                                    height: 47,
                                    text:
                                        currentQuestionIndex ==
                                            totalQuestions - 1
                                        ? "Submit"
                                        : "Next",
                                    width: double.infinity,
                                    color: AppColors.gold_coin,
                                    onPressed: () {
                                      if (currentQuestionIndex ==
                                          totalQuestions - 1) {
                                        submitQuestions(
                                          questions,
                                          questionnaire.id,
                                        );
                                      } else {
                                        nextQuestion(totalQuestions, questions);
                                      }
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
            ),
    );
  }

  Widget successUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: FadeTransition(
          opacity: _fadeAnimation ?? const AlwaysStoppedAnimation(1),
          child: ScaleTransition(
            scale: _scaleAnimation ?? const AlwaysStoppedAnimation(1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, size: 90, color: Colors.green),
                const SizedBox(height: 20),
                const Text(
                  "Success!",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(successMessage, textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Text(
                  "+ $pointsEarned Points Earned",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold_coin,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Total Points: $totalUserPoints",
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 30),
                AppButton(
                  text: "Done",
                  color: AppColors.gold_coin,
                  onPressed: () => context.pop(),
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
