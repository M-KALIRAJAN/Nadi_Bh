import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/routing/app_router.dart';

class Accountcreated extends StatefulWidget {
  const Accountcreated({super.key});

  @override
  State<Accountcreated> createState() => _AccountcreatedState();
}

class _AccountcreatedState extends State<Accountcreated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.go(RouteNames.bottomnav);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background_clr,
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/accountcreated.png",
                    height: 190,
                    width: 190,
                  ),
                  const SizedBox(height: 10),

                 const Text(
                    "Account Created",
                    style: TextStyle(
                      fontSize: AppFontSizes.large,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),

                 const Text(
                    "Successfully!",
                    style: TextStyle(
                      fontSize: AppFontSizes.large,
                      fontWeight: FontWeight.w700,
                      color: AppColors.btn_primery,
                    ),
                  ),
                  const SizedBox(height: 15),

                 const Text(
                    "Welcome to Nadi Bahrain Services. You can now\nsign in to your new account.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.borderGrey,
                      fontSize: AppFontSizes.small,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
