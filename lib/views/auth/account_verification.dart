import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
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
       const Text(
          "Sign up",
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
        color: AppColors.button_secondary,
      ),
      child: Image.asset(
        "assets/icons/cart.png",
        height: 80,
        width: 100,
      ),
    ),

    SizedBox(height: 15),


  const  Text(
      "Secure Your Account With ID Verification",
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
          const  Text(
              """
To ensure the highest level of security and trust within the Service Connect community, we require all users to complete a simple identity verification process. This helps protect against fraud and maintain a safe environment for everyone.
              """,
              style: TextStyle(fontSize: AppFontSizes.small, height: 1.7),
            ),
               Text(
              """
To ensure the highest level of security and trust within the Service Connect community, we require all users to complete a simple identity verification process. This helps protect against fraud and maintain a safe environment for everyone.
              """,
              style: TextStyle(fontSize: AppFontSizes.small, height: 1.7),
            ),
               Text(
              """
To ensure the highest level of security and trust within the Service Connect community, we require all users to complete a simple identity verification process. This helps protect against fraud and maintain a safe environment for everyone.
              """,
              style: TextStyle(fontSize: AppFontSizes.small, height: 1.7),
            ),
            SizedBox(height: 10),
            Text(
              """
We value your safety and privacy. Your information is securely processed and used only for verification purposes.
              """,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                height: 1.7,
                color: AppColors.btn_primery,
              ),
            ),
          ],
        ),
      ),
    ),

    SizedBox(height: 25),


    AppButton(
      text: "Continue",
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
