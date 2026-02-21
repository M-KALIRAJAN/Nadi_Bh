import 'package:nadi_user_app/core/network/dio_client.dart';

class NotificationToggleService {
  final _dio = DioClient.dio;

  
  Future<bool> fetchCheckStatus() async {
    try {
      final response = await _dio.post("user-account/status");

      return response.data["data"] ?? true;

    } catch (e) {
      throw Exception("Failed to fetch notification status");
    }
  }

    Future<void> updateNotificationStatus(bool status) async {
    try {
      await _dio.post(
        "/user-account/notification-status",
        data: {
          "status": status,
        },
      );
    } catch (e) {
      throw Exception("Failed to update notification status");
    }
  }
}