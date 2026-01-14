import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

class LanguangeView extends StatefulWidget {
  const LanguangeView({super.key});

  @override
  State<LanguangeView> createState() => _LanguangeViewState();
}

class _LanguangeViewState extends State<LanguangeView> {
    bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 350,
                child: Center(
                  child: Image.asset(
                    "assets/icons/language.png",
                    height: 180,
                    width: 213,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                      const  Text(
                          "Choose The Language",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: AppFontSizes.xLarge,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 30),

                        AppButton(
                           text: "عربي",
                          onPressed: () {
                            // context.go(RouteNames.accountverfy);
                             _showLanguageInProcessDialog(context);
                          },
                          color: AppColors.btn_primery,
                          width: double.infinity,
                        ),

                        const SizedBox(height: 25),
                       
                        AppButton(
                          text: "English",
                          onPressed: ()async {
                             setState(() => _isLoading = true); 
                            await Future.delayed(const Duration(seconds: 1));
                            if (!mounted) return; //  safety check
                            context.go(RouteNames.welcome);
                          },
                          color: AppColors.button_secondary,
                          width: double.infinity,
                          isLoading:_isLoading
                        ),

                        const SizedBox(height: 10),

                       const Text(
                          "Your language preference can be changed any time in Settings",

                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: Color(0xFF79747E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _showLanguageInProcessDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap OK
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          "Language",
          textAlign: TextAlign.center,
        ),
        content: const Text(
          "Arabic language is in process",
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      );
    },
  );
}

}
