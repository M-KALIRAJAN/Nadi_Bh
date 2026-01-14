import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';


class AppTimePicker extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function(String)? onTimeSelected;

  const AppTimePicker({
    super.key,
    required this.controller,
    this.label = "Select Time",
    this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );

        if (pickedTime != null) {
          final formattedTime = pickedTime.format(context);
          controller.text = formattedTime;
          if (onTimeSelected != null) {
            onTimeSelected!(formattedTime);
          }
          print("Selected Time: $formattedTime");
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            floatingLabelStyle: const TextStyle(
              color: AppColors.btn_primery,
            ),
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.btn_primery,
                width: 1.5,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
