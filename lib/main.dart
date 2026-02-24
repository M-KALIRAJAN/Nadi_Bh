import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:nadi_user_app/l10n/app_localizations.dart';

import 'package:nadi_user_app/providers/language_provider.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/providers/fetchpointsnodification.dart';
import 'package:nadi_user_app/providers/theme_provider.dart';
import 'package:flutter/services.dart';
import 'package:nadi_user_app/routing/route_names.dart';
import 'package:nadi_user_app/services/AppListener.dart';
import 'package:nadi_user_app/services/notification_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
final container = ProviderContainer();

///  STEP 1: ADD THIS HERE (TOP LEVEL, NOT INSIDE CLASS)
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// FIREBASE INIT
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// LOCAL NOTIFICATION INIT
  await NotificationService.initialize();
  await NotificationService.createChannel();

  /// BACKGROUND HANDLER
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  /// REQUEST PERMISSION (iOS)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  /// VERY IMPORTANT FOR IOS TOKEN
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // final userId = await AppPreferences.getUserId();
  // if(userId != null){
  //       await StreamChatService().connectUser(userId);
  // }

  /// GET FCM TOKEN
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    print("🔥 FCM TOKEN = $token");
  } catch (e) {
    print("⚠️ FCM not available on simulator: $e");
  }

  /// TOKEN REFRESH LISTENER
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
    print("🔥 NEW FCM TOKEN = $newToken");
  });

  /// Hive init
  await Hive.initFlutter();
  await Hive.openBox("aboutBox");
  await Hive.openBox("blockbox");
  await Hive.openBox("servicesBox");

  /// FOREGROUND MESSAGE
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationService.show(
      title: message.notification?.title ?? 'OTP',
      body: message.notification?.body ?? 'Your OTP is ${message.data['otp']}',
    );
    container.invalidate(fetchpointsnodification);
  });

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AppListener(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
 final locale = ref.watch(languageProvider);
    //  final StreamChatClient client = StreamChatService().client;
    return MaterialApp.router(
      routerConfig: appRouter,

      debugShowCheckedModeBanner: false,

      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
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
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
    );
  }
}

// class MyApp extends ConsumerWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final themeMode = ref.watch(themeProvider);
//     final locale = ref.watch(languageProvider);
//     final StreamChatClient client = StreamChatService().client;

//     return MaterialApp.router(
//       routerConfig: appRouter,
//       debugShowCheckedModeBanner: false,

//       locale: locale,
//       supportedLocales: AppLocalizations.supportedLocales,
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],

//       themeMode: themeMode,

//       theme: ThemeData(
//         fontFamily: 'Poppins',
//         brightness: Brightness.light,
//         scaffoldBackgroundColor: AppColors.background_clr,
//         colorScheme: const ColorScheme.light(
//           primary: AppColors.btn_primery,
//           secondary: AppColors.button_secondary,
//           surface: Colors.white,
//           onSurface: Colors.black,
//         ),
//       ),

//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: Colors.black,
//         fontFamily: 'Poppins',
//         colorScheme: const ColorScheme.dark(
//           primary: AppColors.btn_primery,
//           secondary: AppColors.button_secondary,
//           surface: Color.fromARGB(255, 56, 56, 56),
//           onSurface: Color.fromARGB(255, 53, 53, 53),
//         ),
//       ),

//       builder: (context, child) {
//         return StreamChat(
//               client: StreamChatService().client,
//           child: child!,
//         );
//       },
//     );
//   }
// }