import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';

import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/views/languagetoggle.dart';
import 'package:nadi_user_app/views/logoanimation.dart';
import 'package:nadi_user_app/views/onboarding/BottomCurveClipper.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
 
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                ClipPath(
                  clipper: BottomCurveClipper(),
                  child: Container(
                    height: size.height * 0.45,
                    width: double.infinity,
                    color: AppColors.button_secondary,
                    alignment: Alignment.center,
                    child:  Padding(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Text(
                       AppLocalizations.of(context)!.welcome,
                        style: TextStyle(
                          fontSize: 35,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(top: 50, right: 20, child: LanguageView()),
                Positioned(
                  bottom: -150,
                  left: 0,
                  right: 0,
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: 370,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 100),

            Image.asset("assets/icons/nadhil.png", height: 92),

            const SizedBox(height: 40),

            const LogoAnimation(),

            const SizedBox(height: 60),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: AppButton(
                text: AppLocalizations.of(context)!.getStarted,
                onPressed: () {
                  context.go(RouteNames.about);
                },
                color: AppColors.btn_primery,
                width: double.infinity,
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
