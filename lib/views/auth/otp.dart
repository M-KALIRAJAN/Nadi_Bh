import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/auth_service.dart';

import 'package:nadi_user_app/widgets/buttons/primary_button.dart';
import 'package:pinput/pinput.dart';

class Otp extends StatefulWidget {
  final String? receivedOtp;
  const Otp({super.key, this.receivedOtp});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final otpController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isOtpError = false;
  bool isLoading = false;
  String? phoneNumber;
  int _secountleft = 60;
  Timer? _timer;
  bool _canResend = false;
  @override
  void initState() {
    super.initState();

    /// AUTO FILL OTP
    if (widget.receivedOtp != null) {
      otpController.text = widget.receivedOtp!;
    }
    _startTimer();
    _loadPhoneNumber();
    sendOtp(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _loadPhoneNumber() async {
    final phone = await AppPreferences.getphonenumber();
    setState(() {
      phoneNumber = phone;
    });
  }

  void _showOtpError(String message) {
    setState(() => isOtpError = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: Colors.red)),
      ),
    );
  }

  Future<void> sendOtp(BuildContext context) async {
    final userId = await AppPreferences.getUserId();
    // final fcmToken = await AppPreferences.getfcmToken();
    setState(() {
      isOtpError = false;
      otpController.clear();
    });

    try {
      final response = await _authService.SendOTP(userId: userId!);
      AppLogger.success("Resend OTP response: $response");
    } on DioException catch (e) {
      final message = e.response?.data["message"] ?? "Failed to resend OTP";
      _showOtpError(message);
    }
  }

  Future<void> verifyOtp(BuildContext context) async {
    final userId = await AppPreferences.getUserId();
    final otp = otpController.text.trim();

    setState(() => isLoading = true);

    try {
      final response = await _authService.OTPverify(otp: otp, userId: userId!);
      if (response["message"] == "OTP verified successfully") {
        final completeuseraccount = await _authService.CompleteuserAccount(
          userId: userId,
        );

        AppLogger.warn("prettyString $completeuseraccount");
        if (completeuseraccount != null &&
            completeuseraccount.containsKey('token')) {
          await AppPreferences.saveToken(completeuseraccount['token']);
          await AppPreferences.saveAccountType(
            completeuseraccount['accountType'],
          );
        }
        await AppPreferences.setLoggedIn(true);
        //  await AppPreferences.setLoggedIn(true);
        context.push(RouteNames.accountcreated);
      } else {
        _showOtpError(response["message"] ?? "Invalid OTP");
      }
    } on DioException catch (e) {
      final errorResponse = e.response?.data;
      final message = (errorResponse is Map && errorResponse["message"] != null)
          ? errorResponse["message"]
          : "Something went wrong";

      _showOtpError(message);
    } finally {
      setState(() => isLoading = false);
    }
  }

  final errorPinTheme = PinTheme(
    width: 50,
    height: 50,
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.red,
    ),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.red),
    ),
  );

  void _startTimer() {
    _secountleft = 60;
    _canResend = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secountleft == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secountleft--);
      }
    });
  }

  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;
    @override
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black
      ),
      decoration: BoxDecoration(
        // color: isDark ? Colors.black : Colors.black,
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter Verification code",
                style: TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              const Text(
                "We have sent you a 4 digit verification code on",
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  color: AppColors.borderGrey,
                ),
              ),
              SizedBox(height: 10),
              Text(
                phoneNumber != null ? phoneNumber! : "",
                style: TextStyle(
                  fontSize: AppFontSizes.medium,
                  color: AppColors.borderGrey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Pinput(
                    controller: otpController,
                    length: 4,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyDecorationWith(
                      border: Border.all(color: AppColors.button_secondary),
                    ),
                    submittedPinTheme: defaultPinTheme.copyDecorationWith(
                      border: Border.all(color: Colors.green),
                    ),
                    errorPinTheme: errorPinTheme,
                    forceErrorState: isOtpError,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      if (isOtpError) setState(() => isOtpError = false);
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _canResend
                      ? InkWell(
                          onTap: () {
                            _startTimer();
                            sendOtp(context);
                          },
                          child: const Text(
                            "Resend OTP",
                            style: TextStyle(
                              color: AppColors.btn_primery,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Text(
                          "Resend OTP in 00:${_secountleft.toString().padLeft(2, '0')}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(top: 90, left: 25, right: 25),
                child: AppButton(
                  text: "Sign In",
                  onPressed: () {
                    if (otpController.text.length == 4) {
                      verifyOtp(context);
                    } else {
                      _showOtpError("Please enter 4 digit OTP");
                    }
                  },
                  color: AppColors.btn_primery,
                  width: double.infinity,
                ),
              ),

              Row(children: [Container(width: 30, height: 1)]),
            ],
          ),
        ),
      ),
    );
  }
}
