import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/providers/HelpAndSuppord_Provider.dart';
import 'package:nadi_user_app/providers/Privacypolicy_Provider.dart';
import 'package:nadi_user_app/providers/aboutProvider.dart';
import 'package:nadi_user_app/providers/theme_provider.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/widgets/app_back.dart';
import 'package:nadi_user_app/widgets/buttons/primary_button.dart';
import 'package:nadi_user_app/widgets/dialogs/common_app_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool isToggleOn = false;

  // Reusable theme selector
  Widget themeOption(String type) {
    final currentTheme = ref.watch(themeProvider);

    bool isActive = false;

    if (type == "Light" && currentTheme == ThemeMode.light) {
      isActive = true;
    } else if (type == "Dark" && currentTheme == ThemeMode.dark) {
      isActive = true;
    } else if (type == "System" && currentTheme == ThemeMode.system) {
      isActive = true;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color.fromRGBO(13, 95, 72, 1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 12,
          color: isActive ? Colors.white : Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget settingItem({
    required String text,
    required Image icon,
    required VoidCallback onTap,
    bool showArrow = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromRGBO(76, 149, 129, 0.3),
                ),
                child: Padding(padding: const EdgeInsets.all(10), child: icon),
              ),
              const SizedBox(width: 15),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String selectedLanguage = "ENG";
  Widget languageOption(String value) {
    bool isActive = selectedLanguage == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLanguage = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromRGBO(13, 95, 72, 1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _logout(BuildContext context) async {
      // Clear all local storage
      await AppPreferences.clearAll();
      await AppPreferences.setLoggedIn(false);
      // Optional: reset theme to system
      // ref.read(themeProvider.notifier).changeTheme(ThemeMode.system);

      context.go(RouteNames.splash);
    }

    return Scaffold(
      backgroundColor: AppColors.background_clr,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCircleIconButton(
                    icon: Icons.arrow_back,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Settings",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                  const SizedBox(width: 30),
                ],
              ),
            ),

            const Divider(),
            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    settingItem(
                      text: "About App",
                      icon: Image.asset("assets/icons/i.png"),
                      onTap: () {
                        showAppDialog(context);
                      },
                    ),
                    const SizedBox(height: 15),
                    settingItem(
                      text: "Help & Support",
                      icon: Image.asset("assets/icons/help.png"),
                      onTap: () {
                        showHelpAndSupport(context);
                      },
                    ),
                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color.fromRGBO(76, 149, 129, 0.3),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset("assets/icons/noti.png"),
                              ),
                            ),
                            const SizedBox(width: 15),
                            const Text(
                              "Notification",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => setState(() => isToggleOn = !isToggleOn),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 45,
                            height: 25,
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: isToggleOn
                                  ? AppColors.btn_primery
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: AnimatedAlign(
                              duration: const Duration(milliseconds: 200),
                              alignment: isToggleOn
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    // settingItem(
                    //   text: "Change Language",
                    //   icon: Image.asset("assets/icons/global.png"),
                    //   onTap: () {},
                    // ),
                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromRGBO(76, 149, 129, 0.3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset("assets/icons/global.png"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Change Language",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color.fromRGBO(178, 209, 202, 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              languageOption("BH"),
                              languageOption("ENG"),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),
                    settingItem(
                      text: "History",
                      icon: Image.asset("assets/icons/menu.png"),
                      onTap: () {
                        context.push(RouteNames.viewalllogs);
                      },
                    ),
                    const SizedBox(height: 15),
                    settingItem(
                      text: "Privacy Policy",
                      icon: Image.asset("assets/icons/policy.png"),
                      onTap: () {
                        showPrivacyPolicyDialog(context);
                      },
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromRGBO(76, 149, 129, 0.3),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset("assets/icons/idea.png"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Theme",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: const Color.fromRGBO(178, 209, 202, 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // ref
                                  //     .read(themeProvider.notifier)
                                  //     .changeTheme(ThemeMode.light);
                                },
                                child: themeOption("Light"),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // ref
                                  //     .read(themeProvider.notifier)
                                  //     .changeTheme(ThemeMode.dark);
                                },
                                child: themeOption("Dark"),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // ref
                                  //     .read(themeProvider.notifier)
                                  //     .changeTheme(ThemeMode.system);
                                },
                                child: themeOption("System"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: settingItem(
                  text: "Log Out",
                  icon: Image.asset("assets/icons/logout.png"),
                  onTap: () {
                    _logout(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

void showAppDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Consumer(
        builder: (context, ref, _) {
          final aboutAsync = ref.watch(aboutProvider);

          return aboutAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => CommonAppDialog(
              title: "Error",
              content: Text(e.toString()),
            ),
            data: (about) {
              final item = about.data.first;

              return CommonAppDialog(
                title: item.title,
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...item.content.map(
                        (text) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            text,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Version ${item.version}",
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}


void showHelpAndSupport(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Consumer(
        builder: (context, ref, _) {
          final helpAsync = ref.watch(helpandsupportprovider);

          return helpAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => CommonAppDialog(
              title: "Error",
              content: Text(e.toString()),
            ),
            data: (help) {
              final item = help.data.first;

              return CommonAppDialog(
                title: "Help And Support",
                content: SingleChildScrollView(
                  child: Text(item.content),
                ),
              );
            },
          );
        },
      );
    },
  );
}



void showPrivacyPolicyDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) {
      return Consumer(
        builder: (context, ref, _) {
          final privacyAsync = ref.watch(Privacypolicyprovider);

          return privacyAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => CommonAppDialog(
              title: "Error",
              content: Text(e.toString()),
            ),
            data: (privacy) {
              final item = privacy.data.first;

              return CommonAppDialog(
                title: item.title,
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl:
                            "${ImageBaseUrl.baseUrl}/${item.media}",
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 10),
                      ...item.content.map(
                        (text) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(text, textAlign: TextAlign.center),
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          await launchUrl(
                            Uri.parse(item.link),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                        child: Text(
                          item.link,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                closeButtonColor: AppColors.btn_primery,
              );
            },
          );
        },
      );
    },
  );
}
}




// Replace Container background -  color: Theme.of(context).colorScheme.surface, // ✅ surface adapts to light/dark
// Use theme for Text -    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  //   fontWeight: FontWeight.w600,
                                                    //   fontSize: 20,
                                                                 // ),
// textTheme.titleLarge automatically adapts to light / dark mode text color

