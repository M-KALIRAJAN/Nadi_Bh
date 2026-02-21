import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/providers/language_provider.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/auth_service.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

class Termsandconditions extends ConsumerStatefulWidget {
  const Termsandconditions({super.key});

  @override
  ConsumerState<Termsandconditions> createState() => _TermsandconditionsState();
}

class _TermsandconditionsState extends ConsumerState<Termsandconditions> {
  bool isChecked = false;
  bool _isLoading = false;
  AuthService _authService = AuthService();

  String termsContent = "";
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
  void initState() {
    super.initState();
    fetchtermsandconditions();
  }

  Future<void> fetchtermsandconditions() async {
    try {
          final local = ref.watch(languageProvider);
    final lang = local.languageCode;
      final response = await _authService.TermsAndConditionlist(lang);

      debugPrint("Terms API Response: $response");

      // Safely extract content
      final content =
          response['data']?[0]?['content'] ?? "No content available";

      // Update UI
      setState(() {
        termsContent = content;
      });

      debugPrint("Terms Content: $termsContent");
    } catch (e) {
      debugPrint("Fetch Terms Error: $e");
      setState(() {
        termsContent = "Failed to load terms. Please try again later.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
         
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                 Text(
                 AppLocalizations.of(context)!.termsTitle,
                  style: TextStyle(
                    fontSize: AppFontSizes.xLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Divider(),
                const SizedBox(height: 20),

                // Terms container — remove fixed height
                Container(
                  width: 299,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderGrey),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                       AppLocalizations.of(context)!.ourCommitments,
                        style: TextStyle(
                          color: AppColors.btn_primery,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Show full terms content
                      termsContent.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : Text(
                              termsContent,
                              style: TextStyle(fontSize: AppFontSizes.small),
                            ),

                      const SizedBox(height: 10),
                       Text(
                        AppLocalizations.of(context)!.readFullTerms,
                        style: TextStyle(
                          color: AppColors.btn_primery,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Checkbox
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
                        child:  Text(
                          AppLocalizations.of(context)!.agreeTerms,
                          style: TextStyle(fontSize: AppFontSizes.small),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // Complete Registration button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: AppButton(
                    text: AppLocalizations.of(context)!.completeRegistration,
                    isLoading: _isLoading,
                    onPressed: () {
                      if (isChecked) CompleteRegistration(context);
                    },
                    color: isChecked
                        ? AppColors.btn_primery
                        : AppColors.button_secondary.withOpacity(0.5),
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
