import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/models/UserLogModel%20.dart';

class LogsService {
  final _dio = DioClient.dio;

  Future<List<Userlogmodel>> getUserLogs() async {
    try {
      final response = await _dio.post("user-log");

      if (response.statusCode == 200 && response.data['success'] == true) {
        final List list = response.data['data'];
        return list
            .map((e) => Userlogmodel.fromJson(e))
            .toList();
      } else {
        throw Exception("Invalid response from server");
      }
    } on DioException catch (e) {
      AppLogger.error("Dio error: ${e.message}");
      throw Exception("Network error");
    } catch (e) {
      AppLogger.error("Unknown error: $e");
      throw Exception("Something went wrong");
    }
  }
}
// Internet illatti → DioException

 // API down → catch

 // Wrong response → exception

 // UI-la message show panna mudiyum

