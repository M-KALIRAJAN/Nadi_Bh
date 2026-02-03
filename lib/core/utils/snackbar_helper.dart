// ignore_for_file: avoid_single_cascade_in_expression_statements

import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';

class SnackbarHelper {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message,style: TextStyle(color: Colors.white),), backgroundColor: Colors.red),
      );
  }

  static void ShowSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.btn_primery,
        ),
      );
  }
}
