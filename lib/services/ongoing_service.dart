import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';

class OngoingService {
  final _dio = DioClient.dio;
  Future<Map<String, dynamic>> fetchongoingprocess() async {
    try {
      final response = await _dio.post('user-service/ongoin');
      debugPrint("fetchongoingprocess**********,${response.data}");
      return response.data;
    } on DioException catch (e) {
      final err = e.response?.data['message'];
      throw err;
    }
  }
}
