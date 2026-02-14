import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/logger.dart';

class OngoingService {
  final _dio = DioClient.dio;

  // UserAppove technisian

  Future<Map<String, dynamic>> fetchaprovetech() async {
  try {
    final response = await _dio.get("/user-service/approve-list");

 
    AppLogger.debug("API Status Code: ${response.statusCode}");


    AppLogger.debug("fetchaprovetech raw response: ${response.data}");

 

      return response.data;

  } on DioException catch (e) {
      final err = e.response?.data['message'];
      throw err;
    }
}


  // Ongoing Service
  Future<Map<String, dynamic>> fetchongoingprocess() async {
    try {
      final response = await _dio.post('user-service/ongoin');
      AppLogger.warn("fetchongoingprocess**********,${response.data}");
      return response.data;
    } on DioException catch (e) {
      final err = e.response?.data['message'];
      throw err;
    }
  }

  // Aprove the Service

  Future<Map<String,dynamic>> fetchabrovework({
    required Map<String,dynamic> payload
  }) async{
    try{
      final response = await _dio.post(
        "user-service/approve-work",
        data: payload
        );
        return response.data;
    }on DioException catch(e){
      final errmsg = e.response?.data['message'];
      throw errmsg;
    } 
  }
}
