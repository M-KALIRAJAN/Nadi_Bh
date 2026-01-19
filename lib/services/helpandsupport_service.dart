import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/models/HelpAndSupport_Model.dart';

class HelpandsupportService {
  final _dio = DioClient.dio;

  Future<Helpandsupport> HelpAndSupport() async {
    try {
      final response = await _dio.get("help");
       AppLogger.info(response.data.toString());
      return Helpandsupport.fromJson(response.data);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'something went to wrong';
      throw Exception(message);
    }
  }
}
