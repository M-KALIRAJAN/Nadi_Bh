import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/logger.dart';

class ProfileService {
  final _dio = DioClient.dio;

  Future<Map<String, dynamic>?> profileData({required String userId}) async {
    try {
      final response = await _dio.post(
        "user-account/profile",
        data: {
          "userId": userId,
        },
      );
AppLogger.info("📥 Response data: ${response.data}");

      if (response.statusCode == 200 && response.data != null) {
        return Map<String, dynamic>.from(response.data);
      }

      return null;
    } on DioException catch (e) {
      AppLogger.error("ProfileData DioError: ${e.response?.statusCode}");
      AppLogger.error("Message: ${e.response?.data}");
      return null;
    } catch (e) {
      AppLogger.error("ProfileData Error: $e");
      return null;
    }
  }

  // Edit Profile 
   Future<dynamic> editProfile({required FormData formData}) async {
    final response = await _dio.post(
      "user-account/profile-update",
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
    return response.data;
  }
  }

