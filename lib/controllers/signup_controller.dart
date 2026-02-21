import 'package:flutter/material.dart';
import 'package:nadi_user_app/models/SignupModel.dart';

import 'package:nadi_user_app/core/utils/validators.dart';

class SignupController {
  // Text controllers
  final name = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  // Address controllers
  final doorNo = TextEditingController();
  final street = TextEditingController();
  final city = TextEditingController();
  final pincode = TextEditingController();

  // Account Type
  String accountType = "Individual"; // default

  // Gender
  String? gender;


  // Form key
  final formKey = GlobalKey<FormState>();

  // MODEL OBJECT TO STORE FINAL SUBMITTED DATA
  SignupModel? signupData;

  // Validators
  String? validateName(String? v) => v == null || v.isEmpty ? "Enter full name" : null;

  String? validateMobile(String? v) {
    if (v == null || v.isEmpty) return "Enter mobile number";
    if (v.length != 8) return "Mobile must be 8 digits";
    if (!RegExp(r'^[0-9]+$').hasMatch(v)) return "Only digits allowed";
    return null;
  }

  String? validateEmail() => Validators.email(email.text);

  String? validatePassword() => Validators.Password(password.text);

  String? validateConfirmPassword(String? v) =>
      v != password.text ? "Passwords do not match" : null;

  String? validateGender(String? v) => v == null ? "Select gender" : null;



  // Save all the data into a model
  void saveToModel() {
    signupData = SignupModel(
      accountType: accountType,
      fullName: name.text,
      mobileNumber: mobile.text,
      email: email.text,
      gender: gender!.toLowerCase(),
      password: password.text,

    );
  }
}
