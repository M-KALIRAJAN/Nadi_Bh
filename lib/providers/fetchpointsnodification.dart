import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/services/NotificationApiService.dart';

final fetchpointsnodification = FutureProvider((ref) async{
    final result = await Notificationapiservice().fetchpointsnodification();
     return result;
});