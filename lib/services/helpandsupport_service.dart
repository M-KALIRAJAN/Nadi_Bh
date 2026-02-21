import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/models/HelpAndSupport_Model.dart';

class HelpandsupportService {
  final _dio = DioClient.dio;
  
  Future<Helpandsupport> HelpAndSupport( String lang) async {
    try {
      final response = await _dio.get(
        "help",
        queryParameters: {
          "lang":lang
        }
        );
       AppLogger.info(response.data.toString());
      return Helpandsupport.fromJson(response.data);
    } on DioException catch (e) {
      final message = e.response?.data?['message'] ?? 'something went to wrong';
      throw Exception(message);
    }
  }

  // Enquiry Form 

Future<Map<String, dynamic>> fetchenquiry(Map<String, dynamic> data) async {
  try {
    final response = await _dio.post(
      'enquiry/send',
      data: data, // pass the JSON here
    );
    return response.data;
  } on DioException catch (e) {
    final err = e.response?.data['message'] ?? "Something went wrong";
    throw err;
  }
}
}
