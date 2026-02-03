import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/models/Adminquestioner_Model.dart';

class AdminQuestioner {
  final _dio = DioClient.dio;
  // Fetch Admin List
  Future<Map<String, dynamic>> fetchadminlist() async {
    try {
      final response = await _dio.post('points/listadmin');
      print("fetchadminlist ${response.data}");
      return response.data;
    } on DioException catch (e) {
      final err = e.response?.data['message'];
      throw err ?? "Something went wrong";
    }
  }

Future<Adminquestioner> fetchadminrequestquestion() async {
  try {
    final response = await _dio.get('questionnaire/');
    debugPrint("RAW RESPONSE: ${response.data}", wrapWidth: 1024);
    return Adminquestioner.fromJson(response.data);
  } on DioException catch (e) {
    debugPrint("DIO ERROR: ${e.response?.data}");
    throw e.response?.data['message'] ?? "API error";
  }
}

}
