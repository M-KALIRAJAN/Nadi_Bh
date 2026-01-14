import 'package:flutter/material.dart';

class LanguageView extends StatefulWidget {
  const LanguageView({super.key});

  @override
  State<LanguageView> createState() => _LanguageViewState();
}

class _LanguageViewState extends State<LanguageView> {
  bool isEnglish = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 27,
      decoration: BoxDecoration(
        color: const Color(0xFF82B3A5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// English Button
          GestureDetector(
            onTap: () => setState(() => isEnglish = true),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              decoration: BoxDecoration(
                color: isEnglish ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "Eng",
                style: TextStyle(
                  color: isEnglish ? const Color(0xFF206A56) : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          /// Arabic Button
          GestureDetector(
            onTap: () => setState(() => isEnglish = false),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: !isEnglish ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                "عربي",
                style: TextStyle(
                  color: !isEnglish ? const Color(0xFF206A56) : Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
