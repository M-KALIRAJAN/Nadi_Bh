import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/language_provider.dart';

class LanguageView extends ConsumerWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final locale = ref.watch(languageProvider);
    final isEnglish = locale.languageCode == 'en';

    return Container(
      height: 27,
      decoration: BoxDecoration(
        color: const Color(0xFF82B3A5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          GestureDetector(
            onTap: () {
              ref.read(languageProvider.notifier)
                  .changeLanguage('en');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isEnglish ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "Eng",
                style: TextStyle(
                  color: isEnglish
                      ? const Color(0xFF206A56)
                      : Colors.white,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: () {
              ref.read(languageProvider.notifier)
                  .changeLanguage('ar');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: !isEnglish ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text("عربي"),
            ),
          ),
        ],
      ),
    );
  }
}
