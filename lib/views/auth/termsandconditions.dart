import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/auth_service.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

class Termsandconditions extends StatefulWidget {
  const Termsandconditions({super.key});

  @override
  State<Termsandconditions> createState() => _TermsandconditionsState();
}

class _TermsandconditionsState extends State<Termsandconditions> {
  bool isChecked = false;
  bool _isLoading = false;
  AuthService _authService = AuthService();
  Future<void> CompleteRegistration(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final userId = await AppPreferences.getUserId();
      final fcmToken = await AppPreferences.getfcmToken();
      //  AppLogger.error(" fcmToken *******************: $fcmToken");
      final response = await _authService.TermsAndSonditions(
        userId: userId!,
        fcmToken: fcmToken,
      );

      //     final responsesendotp = await _authService.SendOTP(userId: userId!,);
      //    AppLogger.success("CompleteRegistration : $response");
      //     //  AppLogger.success("responsesendotp : $responsesendotp");
      //    if(response != null  && responsesendotp != null  ){
      //       final otp = responsesendotp['otp'].toString();

      // Future.delayed(const Duration(seconds: 1), () {

      //   });

      //    }
      context.push(RouteNames.opt);
    } catch (e) {
      AppLogger.error("CompleteRegistration error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background_clr,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),

              /// Title
              const Text(
                "Terms & Conditions",
                style: TextStyle(
                  fontSize: AppFontSizes.xLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),
              Divider(),
              const SizedBox(height: 20),
              Container(
                height: 276,
                width: 299,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header
                      const Text(
                        "Our Commitments To You",
                        style: TextStyle(
                          color: AppColors.btn_primery,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 150,
                        child: Text(
                          """
There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet.
""",
                          style: TextStyle(fontSize: AppFontSizes.small),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 10,
                        ),
                      ),

                      const Spacer(),

                      const Text(
                        "Read the full Terms & Conditions",
                        style: TextStyle(
                          color: AppColors.btn_primery,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: isChecked,
                      activeColor: AppColors.btn_primery,
                      checkColor: Colors.white,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isChecked = newValue!;
                        });
                      },
                    ),

                    Expanded(
                      child: const Text(
                        "I have read and agree to the Service Connect Terms & Conditions and Privacy Policy",
                        style: TextStyle(fontSize: AppFontSizes.small),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: AppButton(
                  text: "Complete Registration",
                  isLoading: _isLoading,
                  onPressed: () {
                    if (isChecked) {
                      CompleteRegistration(context);
                    }
                  },
                  color: isChecked
                      ? AppColors.btn_primery
                      : AppColors.button_secondary.withOpacity(0.5),
                  width: double.infinity,
                ),
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
