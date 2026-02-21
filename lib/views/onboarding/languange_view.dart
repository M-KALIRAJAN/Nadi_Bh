import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/providers/language_provider.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

class LanguangeView extends ConsumerStatefulWidget {
  const LanguangeView({super.key});

  @override
  ConsumerState<LanguangeView> createState() => _LanguangeViewState();
}

class _LanguangeViewState extends ConsumerState<LanguangeView> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
        final locale = ref.watch(languageProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          bottom: false,
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
                    color: Theme.of(context).colorScheme.surface,
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
                        const Text(
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
                          onPressed: () async {
                         ref.read(languageProvider.notifier)
                  .changeLanguage('ar');
                   await Future.delayed(const Duration(seconds: 1));
                            if (!mounted) return; //  safety check
                            context.go(RouteNames.welcome);
                          },
                          color: AppColors.btn_primery,
                          width: double.infinity,
                        ),

                        const SizedBox(height: 25),

                        AppButton(
                          text: "English",
                          onPressed: () async {
                                ref.read(languageProvider.notifier)
                  .changeLanguage('en');
                            setState(() => _isLoading = true);

                            await Future.delayed(const Duration(seconds: 1));
                            if (!mounted) return; //  safety check
                            context.go(RouteNames.welcome);
                          },
                          color: AppColors.button_secondary,
                          width: double.infinity,
                          isLoading: _isLoading,
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

 
}
