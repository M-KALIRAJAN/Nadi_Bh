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
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.refresh(fetchadminquestionrequestprovider);
    });
  }

  Future<void> submitthequestion(BuildContext context, payload) async {
    try {
      await adminQuestioner.submitquestiondatas(payload: payload);
      ref.refresh(fetchadminquestionerprovider);
      context.pop();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Adminrequest = ref.watch(fetchadminquestionrequestprovider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Q & A Conversation",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.gold_coin,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Adminrequest.when(
        data: (response) {
          final adminList = response.data;

          if (adminList.isEmpty) {
            return const Center(child: Text("No admin questions"));
          }

          final questions = adminList.first.questionnaireId.questions;

          if (questions.isEmpty) {
            return const Center(child: Text("No questions found"));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(fetchadminquestionrequestprovider);
            },
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  "assets/images/qusimg.png",
                  filterQuality: FilterQuality.high,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final q = questions[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 7,
                        ),
                        child: Card(
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
                                        "${index + 1}",
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
                                        q.question,
                                        softWrap: true,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                ...List.generate(q.options.length, (oIndex) {
                                  final isSelected =
                                      selectedAnswers[index] == oIndex;

                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedAnswers[index] = oIndex;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 8),
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
                                        borderRadius: BorderRadius.circular(14),
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
                                              q.options[oIndex],
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
                                }),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  child: AppButton(
                    text: "Submit The Question",
                    width: double.infinity,
                    color: AppColors.gold_coin,
                    height: 50,
                    onPressed: () {
                      final payload = {
                        "questionnaireId": adminList.first.questionnaireId.id,
                        "answers": selectedAnswers.entries.map((e) {
                          return {
                            "questionIndex": e.key,
                            "selectedOption": e.value,
                            // "question": questions[e.key].question,
                            // "selectedAnswer": questions[e.key].options[e.value],
                          };
                        }).toList(),
                      };
                      submitthequestion(context, payload);
                      debugPrint("===== SUBMIT QUESTION PAYLOAD =====");
                      debugPrint(payload.toString());
                      debugPrint("===================================");
                    },
                  ),
                ),
              ],
            ),
          );
        },
        error: (e, _) => Text(e.toString()),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }
}
