import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/services/profile_service.dart';

final profileprovider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final userId = await AppPreferences.getUserId();
  if (userId == null || userId.isEmpty) return null;

  final result = await ProfileService().profileData(userId: userId);
  return result;
});
