import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // for debugPrint
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/models/Chats_List_Model.dart';

class ChatsList {

  final _dio = DioClient.dio;

  Future<ChatModel> fetchchatlist() async {
    try {

      final response =
          await _dio.get("user-account/list-with-last-message");

      /// ✅ FULL RESPONSE LOG
      debugPrint("API RESPONSE => ${response.data}");

      final data = response.data;

      return ChatModel.fromJson(data);

    } on DioException catch (e) {

      /// ✅ ERROR LOG
      debugPrint("API ERROR => ${e.response?.data}");

      throw e.response?.data['message'] ?? "Something went wrong";
    }
  }
}
