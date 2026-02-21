  
import 'package:dio/dio.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

          /// ✅ Add Language automatically
          // final prefs = await SharedPreferences.getInstance();
          // final lang = prefs.getString('lang') ?? 'en';

          // options.queryParameters['lang'] = lang;
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Retry logic for 429 Too Many Requests
          if (error.response?.statusCode == 429) {
            int retryCount = error.requestOptions.extra['retryCount'] ?? 0;
            if (retryCount < 3) {
              // Exponential backoff: 2^retryCount seconds
              final delay = Duration(seconds: 1 << retryCount);
              await Future.delayed(delay);
              final options = error.requestOptions;
              options.extra['retryCount'] = retryCount + 1;
              try {
                final response = await dio.fetch(options);
                return handler.resolve(response);
              } catch (e) {
                return handler.next(error);
              }
            }
          }
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
 