// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

// class NotificationService {

//    static void initialize(BuildContext context) {
//     // FOREGROUND MESSAGE

//     FirebaseMessaging.onMessage.listen((RemoteMessage message){
//       if(message.notification != null){
//         String title = message.notification!.title ?? "";
//         String body = message.notification!.body ?? "";

//         //Show UI(Snackbar)
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(title,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold
//                 ),),
//                 Text(body)
//               ],
//             ),
//             duration: Duration(seconds: 7),
//             )
//         );
//       }
//     });
//    }
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings, // ✅ ADD THIS
      macOS: iosSettings, // ✅ mac uses same Darwin settings
    );

    await _plugin.initialize(settings);
  }

  static Future<void> createChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for OTP notifications',
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<void> show({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.high,
          priority: Priority.high,
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}
