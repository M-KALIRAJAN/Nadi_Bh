import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/providers/fetchpointsnodification.dart';
import 'package:nadi_user_app/providers/language_provider.dart';
import 'package:nadi_user_app/providers/profile_provider.dart';
import 'package:nadi_user_app/providers/serviceProvider.dart';
import 'package:nadi_user_app/providers/theme_provider.dart';
import 'package:nadi_user_app/routing/app_router.dart';
import 'package:nadi_user_app/services/account_delete.dart';
import 'package:nadi_user_app/services/lockout_service.dart';
import 'package:nadi_user_app/services/notification_toggle_service.dart';
import 'package:nadi_user_app/widgets/app_back.dart';

class SettingsView extends ConsumerStatefulWidget {
  const SettingsView({super.key});

  @override
  ConsumerState<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  bool isToggleOn = false; // default temporary
bool isLoadingToggle = true;
  final LockoutService _lockoutService = LockoutService();
  final NotificationToggleService _notificationService =
      NotificationToggleService();
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
            ? AppColors.app_background_clr
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
                  color:  const Color.fromARGB(255, 166, 176, 219),
                ),
                child: Padding(padding: const EdgeInsets.all(10), child: icon),
              ),
              const SizedBox(width: 15),
              Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
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
    final locale = ref.watch(languageProvider);

    bool isActive =
        (value == "ENG" && locale.languageCode == 'en') ||
        (value == "BH" && locale.languageCode == 'ar');

    return GestureDetector(
      onTap: () {
        if (value == "ENG") {
          ref.read(languageProvider.notifier).changeLanguage('en');
        } else if (value == "BH") {
          ref.read(languageProvider.notifier).changeLanguage('ar');
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.app_background_clr
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
     void initState() {
       super.initState();
       loadNotificationStatus();
     }

     Future<void> loadNotificationStatus() async {
  try {
    final status = await _notificationService.fetchCheckStatus();

    if (!mounted) return;

    setState(() {
      isToggleOn = status;
      isLoadingToggle = false;
    });

  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoadingToggle = false;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    Future<void> _logout(BuildContext context) async {
      try {
        ///  get FCM token
        final token = await FirebaseMessaging.instance.getToken();

        ///  send token to backend
        await _lockoutService.fetchLockout(token);

        /// clear local storage
        await AppPreferences.clearAll();
        await AppPreferences.setLoggedIn(false);

        /// invalidate providers
        ref.invalidate(profileprovider);
        ref.invalidate(serviceListProvider);
        ref.invalidate(fetchpointsnodification);

        context.go(RouteNames.splash);
      } catch (e) {
        /// still force logout
        await AppPreferences.clearAll();
        await AppPreferences.setLoggedIn(false);

        context.go(RouteNames.splash);
      }
    }

    final AccountDelete _accountDelete = AccountDelete();

    List<dynamic> deleteReasons = [];
    String? selectedReasonId;
    bool isLoadingReasons = false;
   
    Future<void> _showDeleteAccountDialog(BuildContext context) async {
      setState(() {
        isLoadingReasons = true;
      });

      try {
        final locale = ref.watch(languageProvider);
        final lang = locale.languageCode;

        debugPrint("Selected Language = $lang");
        final response = await _accountDelete.fetchdeletereson(lang);

        deleteReasons = response["data"] ?? [];
      } catch (e) {
        debugPrint("Error loading reasons: $e");
      }

      setState(() {
        isLoadingReasons = false;
      });

      showDialog(
        context: context,
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text(l10n.deleteAccountTitle),
                content: SizedBox(
                  width: double.maxFinite,
                  child: isLoadingReasons
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(l10n.deleteAccountDescription),

                            const SizedBox(height: 15),

                            /// ✅ RADIO LIST FROM API
                            Flexible(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: deleteReasons.length,
                                itemBuilder: (context, index) {
                                  final item = deleteReasons[index];

                                  return RadioListTile<String>(
                                    value: item["_id"],
                                    groupValue: selectedReasonId,
                                    title: Text(item["reason"]),
                                    onChanged: (value) {
                                      setDialogState(() {
                                        selectedReasonId = value;
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(l10n.cancel),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (selectedReasonId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.pleaseSelectReason)),
                        );
                        return;
                      }
                      await _accountDelete.fetchdeleteaccount(
                        reasonId: selectedReasonId!,
                      );
                      await AppPreferences.clearAll();
                      await AppPreferences.setLoggedIn(false);
                      context.go(RouteNames.splash);
                    },
                    child: Text(
                      l10n.delete,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  
    Future<void> notificationToggle() async {
      final newValue = !isToggleOn;

      setState(() {
        isToggleOn = newValue;
      });
      AppLogger.info("notificationToggle $newValue");
      try {
        await _notificationService.updateNotificationStatus(newValue);

        // Optional: handle FCM topic
        // if (newValue) {
        //   await FirebaseMessaging.instance.subscribeToTopic("all");
        // } else {
        //   await FirebaseMessaging.instance.unsubscribeFromTopic("all");
        // }
      } catch (e) {
        // ❌ If API fails → revert toggle
        setState(() {
          isToggleOn = !newValue;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to update notification setting"),
          ),
        );
      }
    }


    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppCircleIconButton(
                      icon: Icons.arrow_back,
                      onPressed: () => context.push(RouteNames.bottomnav),
                    ),
                    Text(
                      AppLocalizations.of(context)!.settings,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: AppColors.app_background_clr
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),

              const Divider(),
              const SizedBox(height: 10),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Column(
                          children: [
                            settingItem(
                              text: AppLocalizations.of(context)!.aboutApp,
                              icon: Image.asset("assets/icons/i.png"),
                              onTap: () {
                                context.push(RouteNames.aboutscreen);
                              },
                            ),
                            const SizedBox(height: 15),
                            settingItem(
                              text: AppLocalizations.of(context)!.helpSupport,
                              icon: Image.asset("assets/icons/help.png"),
                              onTap: () {
                                context.push(RouteNames.helpSupport);
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
                                        color: const Color.fromARGB(255, 166, 176, 219)
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Image.asset(
                                          "assets/icons/noti.png",
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      AppLocalizations.of(
                                        context,
                                      )!.notification,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: notificationToggle,
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 45,
                                    height: 25,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isToggleOn
                                          ? AppColors.app_background_clr
                                          : Colors.grey,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: AnimatedAlign(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
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
                                    color: const Color.fromARGB(255, 166, 176, 219)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.asset(
                                      "assets/icons/global.png",
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  AppLocalizations.of(context)!.changeLanguage,
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
                                    color: const Color.fromARGB(255, 166, 176, 219),
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
                              text: AppLocalizations.of(context)!.history,
                              icon: Image.asset("assets/icons/menu.png"),
                              onTap: () {
                                context.push(RouteNames.viewalllogs);
                              },
                            ),
                            const SizedBox(height: 15),
                            settingItem(
                              text: AppLocalizations.of(context)!.privacyPolicy,

                              icon: Image.asset("assets/icons/policy.png"),
                              onTap: () {
                                context.push(RouteNames.privacyPolicy);
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
                                    color: const Color.fromARGB(255, 166, 176, 219),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Image.asset("assets/icons/idea.png"),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  AppLocalizations.of(context)!.theme,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color.fromARGB(255, 166, 176, 219)
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(themeProvider.notifier)
                                              .changeTheme(ThemeMode.light);
                                        },
                                        child: themeOption("Light"),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(themeProvider.notifier)
                                              .changeTheme(ThemeMode.dark);
                                        },
                                        child: themeOption("Dark"),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          ref
                                              .read(themeProvider.notifier)
                                              .changeTheme(ThemeMode.system);
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: settingItem(
                          text: AppLocalizations.of(context)!.logout,
                          icon: Image.asset("assets/icons/logout.png"),
                          onTap: () {
                            _logout(context);
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 5,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: settingItem(
                          text: AppLocalizations.of(context)!.accountDelete,
                          icon: Image.asset("assets/icons/logout.png"),
                          onTap: () {
                            _showDeleteAccountDialog(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




// Replace Container background -  color: Theme.of(context).colorScheme.surface, // ✅ surface adapts to light/dark
// Use theme for Text -    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                                  //   fontWeight: FontWeight.w600,
                                                    //   fontSize: 20,
                                                                 // ),
// textTheme.titleLarge automatically adapts to light / dark mode text color

