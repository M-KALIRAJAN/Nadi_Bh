import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/providers/AdminQuestionRequest_Provider.dart';
import 'package:nadi_user_app/providers/AdminQuestioner_Provider.dart';
import 'package:nadi_user_app/services/admin_questioner.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

class AdminQuestionerview extends ConsumerStatefulWidget {
  const AdminQuestionerview({super.key});

  @override
  ConsumerState<AdminQuestionerview> createState() =>
      _AdminQuestionerviewState();
}

class _AdminQuestionerviewState extends ConsumerState<AdminQuestionerview> {
  final Map<int, int> selectedAnswers = {};
  final AdminQuestioner adminQuestioner = AdminQuestioner();
  int currentQuestionIndex = 0;
  String? errorMessage; // Holds validation error
  bool isSuccess = false;
  String successMessage = "";
  String pointsEarned = "";
  String totalUserPoints = "";

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.refresh(fetchadminquestionrequestprovider);
    });
  }

  Future<void> submitthequestion(BuildContext context, payload) async {
    try {
      final response = await adminQuestioner.submitquestiondatas(
        payload: payload,
      );
      setState(() {
        isSuccess = true;
        successMessage = response["message"];
        pointsEarned = response["pointsEarned"].toString();
        totalUserPoints = response["totalUserPoints"].toString();
      });

      ref.refresh(fetchadminquestionerprovider);
    } catch (e) {
      print(e);
    }
  }

  void nextQuestion(int totalQuestions) {
    // Validate before moving
    if (!selectedAnswers.containsKey(currentQuestionIndex)) {
      setState(() {
        errorMessage = "Please select an answer before moving to next question";
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
        elevation: 0,
      ),
      body: isSuccess
          ? successUI()
          : adminRequest.when(
              data: (response) {
                final adminList = response.data;
                if (adminList.isEmpty) {
                  return const Center(child: Text("No admin questions"));
                }

                final questions = adminList.first.questionnaireId.questions;
                final totalQuestions = questions.length;

                if (questions.isEmpty) {
                  return const Center(child: Text("No questions found"));
                }

                final currentQuestion = questions[currentQuestionIndex];
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Image.asset(
                          "assets/images/qusimg.png",
                          filterQuality: FilterQuality.high,
                        ),
                        const SizedBox(height: 10),
                        // Question progress
                        Text(
                          "Question ${currentQuestionIndex + 1} of $totalQuestions",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: AppColors.gold_coin,
                                      child: Text(
                                        "${currentQuestionIndex + 1}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        currentQuestion.question,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                ...List.generate(
                                  currentQuestion.options.length,
                                  (oIndex) {
                                    final isSelected =
                                        selectedAnswers[currentQuestionIndex] ==
                                        oIndex;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedAnswers[currentQuestionIndex] =
                                              oIndex;
                                          errorMessage =
                                              null; // Clear error when selected
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color.fromARGB(
                                                  255,
                                                  255,
                                                  255,
                                                  231,
                                                )
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.gold_coin
                                                : Colors.grey.shade300,
                                            width: 1.2,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                currentQuestion.options[oIndex],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            isSelected
                                                ? const Icon(
                                                    Icons.check_circle,
                                                    color: AppColors.gold_coin,
                                                  )
                                                : const Icon(
                                                    Icons.circle_outlined,
                                                    color: Colors.grey,
                                                  ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Error message
                        if (errorMessage != null)
                          Container(
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),

                        // Navigation buttons
                        // Navigation buttons
                        Row(
                          children: [
                            // Previous button
                            if (currentQuestionIndex > 0)
                              AppButton(
                                text: "Previous",
                                width: 150,
                                color: Colors.grey,
                                height: 50,
                                onPressed: previousQuestion,
                              )
                            else
                              const SizedBox(
                                width: 150,
                              ), // Keep space so Next is at right

                            const Spacer(), // Push Next to the right
                            // Next or Submit button
                            if (currentQuestionIndex < totalQuestions - 1)
                              AppButton(
                                text: "Next",
                                width: 150,
                                color: AppColors.gold_coin,
                                height: 50,
                                onPressed: () => nextQuestion(totalQuestions),
                              )
                            else
                              SizedBox(
                                width: 150,
                                child: AppButton(
                                  width: 150,
                                  text: "Submit",
                                  color: AppColors.gold_coin,
                                  height: 50,
                                  onPressed: () {
                                    if (!selectedAnswers.containsKey(
                                      currentQuestionIndex,
                                    )) {
                                      setState(() {
                                        errorMessage =
                                            "Please select an answer before submitting";
                                      });
                                      return;
                                    }
                                    final payload = {
                                      "questionnaireId":
                                          adminList.first.questionnaireId.id,
                                      "answers": selectedAnswers.entries.map((
                                        e,
                                      ) {
                                        return {
                                          "questionIndex": e.key,
                                          "selectedOption": e.value,
                                        };
                                      }).toList(),
                                    };
                                    submitthequestion(context, payload);
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              error: (e, _) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                });

                return const SizedBox();
              },
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
    );
  }

  Widget successUI() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: const Color(0xfff8f8f8),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Success Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffe8f5e9),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 60,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Success!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  successMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 20),

                /// Points highlight box
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold_coin.withOpacity(.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
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
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                AppButton(
                  text: "Done",
                  color: AppColors.gold_coin,
                  width: double.infinity,
                  onPressed: () {
                    context.pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
