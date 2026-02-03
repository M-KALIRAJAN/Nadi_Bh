import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/models/Questioner_Model.dart';

class QuestionerService {
  final _dio = DioClient.dio;

  // Fetch all questions
  Future<Questioner> fetchquestionsdata() async {
    try {
      final response = await _dio.get("popup/");
      print("QuestionerService fetchQuestionsData: ${response.data}");
      return Questioner.fromJson(response.data);
    } on DioException catch (e) {
      final err = e.response?.data['message'] ?? e.message;
      throw err;
    }
  }

  // Submit answers
  Future<Map<String, dynamic>> submitQuestionsData({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await _dio.post(
        "popup/submit", 
        data: payload,
      );
      print("QuestionerService submitQuestionsData: ${response.data}");
      return response.data; // ✅ return raw response map
    } on DioException catch (e) {
      final err = e.response?.data['message'] ?? e.message;
      throw err;
    }
  }
}
