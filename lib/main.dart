import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';

import 'package:nadi_user_app/providers/theme_provider.dart';

import 'package:flutter/services.dart';
import 'package:nadi_user_app/routing/route_names.dart';
import 'package:nadi_user_app/services/firebase_background_handler.dart';
import 'package:nadi_user_app/services/notification_service.dart';

///  STEP 1: ADD THIS HERE (TOP LEVEL, NOT INSIDE CLASS)
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  ///  STEP 2: INITIALIZE FIREBASE
  await Firebase.initializeApp();

  await NotificationService.initialize();
  await NotificationService.createChannel();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  /// Hive init
  await Hive.initFlutter();
  await Hive.openBox("aboutBox");
  await Hive.openBox("blockbox");
  await Hive.openBox("servicesBox");
  // ✅ Add this here: Foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationService.show(
      title: message.notification?.title ?? 'OTP',
      body: message.notification?.body ?? 'Your OTP is ${message.data['otp']}',
    );
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        fontFamily: 'Poppins',
        brightness: Brightness.light,

        scaffoldBackgroundColor: AppColors.background_clr,

        colorScheme: const ColorScheme.light(
          primary: AppColors.btn_primery,
          secondary: AppColors.button_secondary,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.btn_primery,
          secondary: AppColors.button_secondary,
           surface: Color.fromARGB(255, 56, 56, 56),
          onSurface: Color.fromARGB(255, 53, 53, 53),
        ),
        textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white),
  ),
      ),
    );
  }
}
