import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nadi_user_app/controllers/signup_controller.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/services/auth_service.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';
import 'package:nadi_user_app/widgets/inputs/app_dropdown.dart';
import 'package:nadi_user_app/widgets/inputs/app_text_field.dart';

class AccountFormView extends StatefulWidget {
  final String accountType;
  final VoidCallback onNext;
  final GlobalKey<FormState> formKey;

  const AccountFormView({
    super.key,
    required this.accountType,
    required this.onNext,
    required this.formKey,
  });

  @override
  State<AccountFormView> createState() => _AccountFormViewState();
}

class _AccountFormViewState extends State<AccountFormView> {
  final controller = SignupController();
  final AuthService _basicInfo = AuthService();
  bool _isLoading = false;
  final String name = "";
  Future<void> submitBasicInfo(BuildContext context) async {
    if (!widget.formKey.currentState!.validate()) return;

    if (mounted) setState(() => _isLoading = true);
    controller.saveToModel();
    final data = controller.signupData!;
    AppLogger.info("basic form data **************: ${data.toJson()}");
    final userId = await AppPreferences.getUserId();

    try {
      final response = await _basicInfo.basicInfo(
        userId: userId!,
        fullName: data.fullName,
        mobileNumber: data.mobileNumber,
        email: data.email,
        password: data.password,
        gender: data.gender,
      );
      if (mounted) setState(() => _isLoading = false);
      if (response["message"] == "Basic info saved") {
        await AppPreferences.saveusername(response['name']);
        final mobile = response['mobile'].toString();
        await AppPreferences.savephonenumber("+973 $mobile");
        widget.onNext();
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      if (e is DioException) {
        final errorMessage =
            e.response?.data['message'] ??
            e.response?.data.toString() ??
            "Something went wrong";

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
      } else {
        if (mounted) setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.accountType} ",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),

          // Name
          AppTextField(
            controller: controller.name,
            label: "Enter Full Name*",
            validator: (value) => controller.validateName(value),
          ),
          const SizedBox(height: 17),

          // Mobile
          AppTextField(
            controller: controller.mobile,
            keyboardType: TextInputType.phone,
            label: "Mobile Number*",
            validator: (value) => controller.validateMobile(value),
            prefixText: "+973 ",
          ),
          const SizedBox(height: 17),

          // Email
          AppTextField(
            controller: controller.email,
            label: "Email Address*",
            validator: (_) => controller.validateEmail(),
          ),
          const SizedBox(height: 17),

          // Gender
          AppDropdown(
            label: "Gender*",
            items: ["Male", "Female"],
            value: controller.gender,
            onChanged: (val) {
              setState(() => controller.gender = val);
            },
            validator: (val) =>
                val == null ? "Please select relationship" : null,
          ),
          const SizedBox(height: 17),

          // Password
          AppTextField(
            controller: controller.password,
            label: "Create Password*",
            isPassword: true,
            validator: (value) => controller.validatePassword(),
          ),
          const SizedBox(height: 17),

          AppTextField(
            controller: controller.confirmPassword,
            label: "Confirm Password*",
            isPassword: true,
            validator: (value) => controller.validateConfirmPassword(value),
          ),
          const SizedBox(height: 40),

          AppButton(
            text: "Continue",
            color: AppColors.btn_primery,
            width: double.infinity,

            isLoading: _isLoading,
            onPressed: () {
              submitBasicInfo(context);
            },
          ),
        ],
      ),
    );
  }
}
