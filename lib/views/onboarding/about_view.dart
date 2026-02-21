import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:nadi_user_app/providers/onbording_provider.dart';
class AboutView extends ConsumerStatefulWidget {
  const AboutView({super.key});
  @override
  ConsumerState<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends ConsumerState<AboutView> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  Future<void> goToLogin() async {
    await AppPreferences.setAboutSeen(true);
    context.go(RouteNames.login);
  }

  void nextPage(int total) {
    if (currentIndex < total - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      goToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final aboutAsync = ref.watch(aboutContentProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// ---------------- TOP IMAGE ----------------
          SizedBox(
            height: 350,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    "assets/images/about.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color.fromARGB(0, 241, 238, 238),
                          Colors.white,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 15,
                  right: 15,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppCircleIconButton(
                        icon: Icons.arrow_back,
                        onPressed: context.pop,
                      ),
                       Text(
                        AppLocalizations.of(context)!.about,
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          //  context.go(RouteNames.login);
                          goToLogin();
                        },
                        child: Container(
                          height: 25,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.6),
                          ),
                          child: Row(
                            children: [
                               Text(
                                AppLocalizations.of(context)!.skip,
                                style: TextStyle(
                                  color: AppColors.btn_primery,
                                  fontSize: 12,
                                  fontFamily: "Poppins",
                                ),
                              ),
                              const SizedBox(width: 4),
                              Image.asset(
                                "assets/icons/skip.png",
                                height: 14,
                                width: 14,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
           Text(
            AppLocalizations.of(context)!.nadiBahrainServices,
            style: TextStyle(
              fontSize: AppFontSizes.xLarge,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            height: 250,
            child: aboutAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(
  child: Text("Error: $err"),
),
              data: (textPages) {
                if (textPages.isEmpty) {
                  return const Center(child: Text("No content available"));
                }

                return PageView.builder(
                  controller: _controller,
                  itemCount: textPages.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  // Inside your PageView.builder itemBuilder:
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) {
                          final offsetAnimation = Tween<Offset>(
                            begin: const Offset(0.0, 0.3),
                            end: Offset.zero,
                          ).animate(animation);

                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          textPages[index],
                          key: ValueKey(textPages[index]),
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            height: 1.5,
                            fontFamily: "Poppins",
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),

                aboutAsync.maybeWhen(
                  data: (textPages) => Row(
                    children: List.generate(
                      textPages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 10,
                        width: 10,
                        decoration: BoxDecoration(
                          color: index == currentIndex
                              ? AppColors.btn_primery
                              : AppColors.btn_primery.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  orElse: () => const SizedBox(),
                ),

                /// Next Button
                GestureDetector(
                  onTap: () {
                    final total = aboutAsync.maybeWhen(
                      data: (list) => list.length,
                      orElse: () => 0,
                    );
                    nextPage(total);
                  },
                  child: Container(
                    height: 38,
                    width: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: AppColors.button_secondary,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
