import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/logger.dart';

class RequestSerivices {
  final _dio = DioClient.dio;

  Future<List<Map<String, dynamic>>?> IssuseList() async {
    try {
      final response = await _dio.get("issue");
      final dataList = List<Map<String, dynamic>>.from(response.data["data"]);
      return dataList;
    } catch (e) {
      AppLogger.error("IssuseList $e");
    }
  }

  Future<Map<String, dynamic>?> createServiceRequestes({
    required String serviceId,
    required String issuesId,
    required String feedback,
    required String scheduleService,
    required bool immediateAssistance,
    required List<File> images,
    File? voiceFile,
  }) async {
    try {
      final formData = FormData();

      //  Fields
      formData.fields.addAll([
        MapEntry("serviceId", serviceId),
        MapEntry("issuesId", issuesId),
        MapEntry("feedback", feedback),
        MapEntry("scheduleService", scheduleService),
        MapEntry("immediateAssistance", immediateAssistance ? "true" : "false"),
      ]);

      //  Images (multiple)
      for (var image in images) {
        formData.files.add(
          MapEntry(
            "media",
            await MultipartFile.fromFile(
              image.path,
              filename: image.path.split('/').last,
            ),
          ),
        );
      }

      // Voice file (optional)
      if (voiceFile != null) {
        formData.files.add(
          MapEntry(
            "voice",
            await MultipartFile.fromFile(
              voiceFile.path,
              filename: voiceFile.path.split('/').last,
            ),
          ),
        );
      }

      final response = await _dio.post(
        "user-service/create",
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );

      return response.data;
    } on DioException catch (e) {
      AppLogger.error("CreateServiceRequest ${e.response?.statusCode}");
      AppLogger.error("CreateServiceRequest ${e.response?.data}");
      return e.response?.data;
    }
  }
}
