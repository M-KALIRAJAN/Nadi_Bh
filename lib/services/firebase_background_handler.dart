import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationService.initialize();
  await NotificationService.createChannel();

  final title = message.notification?.title ?? "OTP";
  final body =
      message.notification?.body ?? "Your OTP is ${message.data['otp']}";

  await NotificationService.show(title: title, body: body);
}
