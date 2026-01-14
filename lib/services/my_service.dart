import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/logger.dart';

class MyService {
  final Dio _dio = DioClient.dio;

  Future<List<Map<String, dynamic>>?> myallservices() async {
    try {
      final response = await _dio.post("user-service");

      if (response.statusCode == 200 && response.data != null) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }

      return null;
    } on DioException catch (e) {
      AppLogger.error("myallservices DioError: ${e.response?.statusCode}");
      AppLogger.error("Message: ${e.response?.data}");
      return null;
    } catch (e) {
      AppLogger.error("myallservices Error: $e");
      return null;
    }
  }
}
