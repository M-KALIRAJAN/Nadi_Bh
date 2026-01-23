import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';

class AppTimePicker extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final ValueChanged<String>? onTimeSelected;

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
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: false, 
              ),
              child: child!,
            );
          },
        );

        if (pickedTime != null) {
          final String formattedTime = _formatTime(pickedTime);
          controller.text = formattedTime;
          onTimeSelected?.call(formattedTime);
          debugPrint("Selected Time: $formattedTime");
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            labelText: label,
            floatingLabelStyle: const TextStyle(
              color: AppColors.btn_primery,
            ),
            contentPadding: const EdgeInsets.all(14),
            filled: true,
            fillColor: Colors.white,
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
            suffixIcon: const Icon(Icons.access_time),
          ),
        ),
      ),
    );
  }

  // Ensures clean 12-hour format with AM / PM
  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
