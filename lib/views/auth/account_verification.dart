import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

class AccountVerification extends StatefulWidget {
  const AccountVerification({super.key});

  @override
  State<AccountVerification> createState() => _AccountVerificationState();
}

class _AccountVerificationState extends State<AccountVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCircleIconButton(icon: Icons.arrow_back, onPressed: () {}),
                  Text(
                    AppLocalizations.of(context)!.signUp,
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),

              SizedBox(height: 20),

              Container(
                height: 177,
                width: 177,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.app_background_clr,
                ),
                child:Icon(
  Icons.perm_identity,
  size: 90,
  color: Colors.white,
)
              ),

              SizedBox(height: 15),

              Text(
                AppLocalizations.of(context)!.accountVerificationTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.xLarge,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 15),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.accountVerificationDesc1,
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          height: 1.7,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.accountVerificationDesc2,
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          height: 1.7,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.accountVerificationDesc1,
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          height: 1.7,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        AppLocalizations.of(context)!.accountVerificationDesc2,
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          height: 1.7,
                          color: AppColors.app_background_clr,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 25),

              AppButton(
                text: AppLocalizations.of(context)!.continueButton,
                onPressed: () {
                  context.push(RouteNames.uploadcard);
                },
                color: AppColors.btn_primery,
                width: double.infinity,
              ),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
