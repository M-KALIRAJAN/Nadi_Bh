  
import 'package:dio/dio.dart';
import 'package:nadi_user_app/preferences/preferences.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://srv1252888.hstgr.cloud/api/",
      connectTimeout: const Duration(seconds: 100),
      receiveTimeout: const Duration(seconds: 100),
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await AppPreferences.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
}

// onRequest -Runs before every API
// options.headers[...] -  Adds header automatically 

class ImageBaseUrl {
  static const baseUrl = "https://srv1252888.hstgr.cloud/uploads";
}

class ImageAssetUrl{
    static const baseUrl = "https://srv1252888.hstgr.cloud";
}
 