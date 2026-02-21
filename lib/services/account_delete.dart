import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:nadi_user_app/core/network/dio_client.dart';

class AccountDelete {
  final _dio = DioClient.dio;
  // Reson for Account Delete
  Future<Map<String, dynamic>> fetchdeletereson(String lang) async {
    try {
          // ✅ PRINT URL
    debugPrint("API CALL => delete-Reasons?lang=$lang");
      final response = await _dio.get(
        "delete-Reasons",
          queryParameters: {
          "lang": lang,
        },
        );
      return response.data;
    } on DioException catch (e) {
      final err = e.response?.data['message'];
      throw err;
    }
  }

  // Account delete

  Future<Map<String, dynamic>> fetchdeleteaccount({
    required String reasonId,
  }) async {
    try {
      final response = await _dio.post(
        "user-account/delete",
        data: {"reasonId": reasonId},
      );
      return response.data;
    } on DioException catch (e) {
      final err = e.response?.data['message'];
      throw err;
    }
  }
}
