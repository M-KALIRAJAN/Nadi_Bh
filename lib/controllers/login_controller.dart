import 'package:flutter/widgets.dart';
import 'package:nadi_user_app/core/utils/validators.dart';
import 'package:nadi_user_app/models/login_model.dart';

/// Controller for login page
class LoginController {
  final email = TextEditingController();
  final password = TextEditingController();

  /// Email validation
  String? validateEmail(String? value) {
    return Validators.email(value);
  }

  /// Password validation
  String? validatePassword(String? value) {
    return Validators.Password(value);
  }


  LoginModel getLoginData() {
    return LoginModel(
      email: email.text,
      password: password.text,
    );
    
  }
}