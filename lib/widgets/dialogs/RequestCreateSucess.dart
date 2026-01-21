import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';

class Requestcreatesucess extends StatefulWidget {
  final String serviceRequestId;
  const Requestcreatesucess({super.key, required this.serviceRequestId});

  @override
  State<Requestcreatesucess> createState() => _RequestcreatesucessState();
}

class _RequestcreatesucessState extends State<Requestcreatesucess>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _starController;
  late final AnimationController _checkController;

  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _starOpacity;
  late final Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _mainController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeIn));

    // ⭐ Star animation controller
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _starOpacity = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _starController, curve: Curves.easeInOut),
    );

    // check icon pulse animation
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _checkScale = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _checkController, curve: Curves.easeInOut),
    );

    // Start animations
    _mainController.forward();
    _starController.repeat(reverse: true);
    _checkController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _mainController.dispose();
    _starController.dispose();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget animatedStar({
      required Animation<double> opacity,
      required double size,
      required double top,
      required double left,
    }) {
      return Positioned(
        top: top,
        left: left,
        child: FadeTransition(
          opacity: opacity,
          child: Icon(Icons.star, size: size, color: AppColors.btn_primery),
        ),
      );
    }
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background_clr,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromRGBO(142, 205, 188, 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            // Stars
                            animatedStar(
                              opacity: _starOpacity,
                              size: 17,
                              top: -20,
                              left: 40,
                            ),
                            animatedStar(
                              opacity: _starOpacity,
                              size: 15,
                              top: 10,
                              left: -30,
                            ),
                            animatedStar(
                              opacity: _starOpacity,
                              size: 12,
                              top: 10,
                              left: 110,
                            ),
                            animatedStar(
                              opacity: _starOpacity,
                              size: 17,
                              top: 85,
                              left: 90,
                            ),
                            animatedStar(
                              opacity: _starOpacity,
                              size: 12,
                              top: 85,
                              left: -5,
                            ),
                            animatedStar(
                              opacity: _starOpacity,
                              size: 18,
                              top: -20,
                              left: 100,
                            ),

                            //  Pulsing check icon
                            ScaleTransition(
                              scale: _checkScale,
                              child: Container(
                                height: 90,
                                width: 90,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.btn_primery,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "Request ID: ${widget.serviceRequestId}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.btn_primery,
                          ),
                        ),
                        const Text(
                          "Service request submitted successfully.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Your request id has been received and is being processed",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        const SizedBox(height: 20),
                        AppButton(
                          text: "View My Request",
                          onPressed: () {
                            context.push(RouteNames.bottomnav);
                          },
                          color: AppColors.btn_primery,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
