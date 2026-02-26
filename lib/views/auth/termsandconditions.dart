import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/providers/language_provider.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/auth_service.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

class TermsAndConditions extends ConsumerStatefulWidget {
  const TermsAndConditions({super.key});

  @override
  ConsumerState<TermsAndConditions> createState() =>
      _TermsAndConditionsState();
}

class _TermsAndConditionsState extends ConsumerState<TermsAndConditions> {
  bool isChecked = false;
  bool _isLoading = false;
  bool _isFetchingTerms = true;
  String termsContent = "";
  String? errorMessage;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    fetchTermsAndConditions();
  }

  Future<void> fetchTermsAndConditions() async {
    setState(() {
      _isFetchingTerms = true;
      errorMessage = null;
    });

    try {
      // Use ref.read here to get languageProvider value outside build
      final local = ref.read(languageProvider);
      final lang = local.languageCode;

      final response = await _authService.TermsAndConditionlist(lang);

      final content = response['data']?[0]?['content'];
      if (content == null || content.isEmpty) {
        setState(() {
          errorMessage = "No terms available at the moment.";
        });
      } else {
        setState(() {
          termsContent = content;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Failed to load terms. Please try again later.";
      });
    } finally {
      setState(() => _isFetchingTerms = false);
    }
  }

  Future<void> completeRegistration(BuildContext context) async {
    if (!isChecked) return;

    setState(() => _isLoading = true);

    try {
      final userId = await AppPreferences.getUserId();
      final fcmToken = await AppPreferences.getfcmToken();

      await _authService.TermsAndSonditions(
        userId: userId!,
        fcmToken: fcmToken,
      );

      context.push(RouteNames.opt);
    } catch (e) {
      debugPrint("CompleteRegistration error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                l10n.termsTitle,
                style: TextStyle(
                  fontSize: AppFontSizes.xLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Divider(),
              const SizedBox(height: 20),

              // Terms container
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 20,
                ),
                child: _isFetchingTerms
                    ? const Center(child: CircularProgressIndicator())
                    : errorMessage != null
                        ? Center(
                            child: Text(
                              errorMessage!,
                              style: TextStyle(
                                fontSize: AppFontSizes.medium,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.ourCommitments,
                                style: TextStyle(
                                  color: AppColors.app_background_clr,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                termsContent,
                                style: TextStyle(
                                  fontSize: AppFontSizes.small,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Text(
                              //   l10n.readFullTerms,
                              //   style: TextStyle(
                              //     color: AppColors.btn_primery,
                              //     fontSize: 15,
                              //     fontWeight: FontWeight.w600,
                              //   ),
                              // ),
                            ],
                          ),
              ),

              const SizedBox(height: 25),

              // Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: isChecked,
                    activeColor: AppColors.app_background_clr,
                    checkColor: Colors.white,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isChecked = newValue!;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      l10n.agreeTerms,
                      style: TextStyle(fontSize: AppFontSizes.small),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Complete Registration button
              AppButton(
                text: l10n.completeRegistration,
                isLoading: _isLoading,
                onPressed: () => completeRegistration(context),
                color: isChecked
                    ? AppColors.btn_primery
                    : AppColors.button_secondary.withOpacity(0.5),
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}