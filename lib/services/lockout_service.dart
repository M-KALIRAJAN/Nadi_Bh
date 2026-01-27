import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';

class LockoutService {
  final Dio _dio = DioClient.dio;

  Future<void> fetchLockout() async {
    try {
      final response = await _dio.post('user-account/logout');

      if (kDebugMode) {
        debugPrint('🔒 Logout API Success');
        debugPrint('Response: ${response.data}');
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Logout API Failed');
      debugPrint('Error: $e');
      debugPrint('StackTrace: $stackTrace');

      rethrow; // important if caller needs to know failure
    }
  }
}
