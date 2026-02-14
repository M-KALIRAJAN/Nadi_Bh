import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';

class ChatsHistoryService {

  final _dio = DioClient.dio;

  Future fetchathistory({
    required String user1,
    required String user2,
  }) async {

    debugPrint("");
    debugPrint("========== CHAT HISTORY API START ==========");

    try {


      debugPrint("user1 => $user1");
      debugPrint("user2 => $user2");


      final response = await _dio.post(
        'chat/history',
        data: {
          "user1": user1,
          "user2": user2, 
        },
      );

  
print("========== FULL RESPONSE ==========");
print("STATUS => ${response.statusCode}");
print("URL => ${response.requestOptions.uri}");
print("HEADERS => ${response.headers}");
print("DATA TYPE => ${response.data.runtimeType}");
print("DATA => ${response.data}");
print("====================================");

      return response.data;

    } on DioException catch (e) {

      debugPrint("******** DIO ERROR ********");

      debugPrint("ERROR TYPE => ${e.type}");

      debugPrint("ERROR MESSAGE => ${e.message}");

      debugPrint("STATUS CODE => ${e.response?.statusCode}");

      debugPrint("ERROR RESPONSE DATA => ${e.response?.data}");

      debugPrint("REQUEST URL => ${e.requestOptions.uri}");

      debugPrint("REQUEST HEADERS => ${e.requestOptions.headers}");

      debugPrint("REQUEST DATA => ${e.requestOptions.data}");

      debugPrint("STACK TRACE => ${e.stackTrace}");

      debugPrint("***************************");

      throw e.response?.data?['message'] ?? "Unknown API error";

    } catch (e, stack) {

      debugPrint("!!!!! UNKNOWN ERROR !!!!!");

      debugPrint("ERROR => $e");

      debugPrint("STACK TRACE => $stack");

      rethrow;
    }
  }
}
