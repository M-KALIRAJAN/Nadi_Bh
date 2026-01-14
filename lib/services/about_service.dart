import 'package:dio/dio.dart';

import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/models/About_Model.dart';

class AboutService{
  final _dio = DioClient.dio;

  Future<About> AboutList() async{
      try{
         final response = await _dio.get("about/");
      // Dio response.data is already Map<String, dynamic>
      AppLogger.warn("response ${ About.fromJson(response.data)}");
      return About.fromJson(response.data);
   
      }on DioException catch(e){
          final message =
          e.response?.data?['message'] ?? 'Something went wrong';
      throw Exception(message);
      }
  }
}