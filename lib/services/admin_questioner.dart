import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
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
  // Get all admin questions
Future<Adminquestioner> fetchadminrequestquestion() async {
  try {
    final response = await _dio.get('questionnaire/');
    AppLogger.info("RAW RESPONSE: ${response.data}");

    return Adminquestioner.fromJson(response.data);
  } on DioException catch (e) {
    AppLogger.error("DIO ERROR: ${e.response?.data}");
    throw e.response?.data['message'] ?? "API error";
  }
}
//submit al questions 

Future<Map<String,dynamic>> submitquestiondatas({
    required Map<String, dynamic> payload,
}) async{
  try{
     final response = await _dio.post(
      "questionnaire/submit",
      data: payload
      );
      return response.data;
  }on DioException catch(e){
    final err = e.response?.data['message'];
    throw err;
  }
}

}
