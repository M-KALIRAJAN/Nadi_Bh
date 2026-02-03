import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/models/Questioner_Model.dart';




class QuestionerView extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final Function(Map<int, int>)? onSubmit;
  final QuestionerDatum questionerDatum; 

  const QuestionerView({
    super.key,
    required this.scrollController,
    required this.questionerDatum,
    this.onSubmit,
  });

  @override
  ConsumerState<QuestionerView> createState() => _QuestionerViewState();
}

class _QuestionerViewState extends ConsumerState<QuestionerView> {
  final Map<int, int> selectedAnswers = {};

  @override
  Widget build(BuildContext context) {
    final questions = widget.questionerDatum.questions;

    return Scrollbar(
      thumbVisibility: true,
      controller: widget.scrollController,
      child: ListView.builder(
        controller: widget.scrollController,
        itemCount: questions.length,
        itemBuilder: (context, qIndex) {
          final question = questions[qIndex];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.questionerDatum.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    question.question,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  ...List.generate(question.options.length, (oIndex) {
                    return RadioListTile<int>(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                     value: oIndex ,
                      groupValue: selectedAnswers[qIndex],
                      onChanged: (value) {
                        setState(() {
                          selectedAnswers[qIndex] = value!;
                        });

                        if (widget.onSubmit != null) {
                          widget.onSubmit!(selectedAnswers);
                        }
                      },
                      title: Text(question.options[oIndex]),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
 

