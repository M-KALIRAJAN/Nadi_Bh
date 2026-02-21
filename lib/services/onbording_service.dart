

import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/logger.dart';

class OnbordingService {
 final _dio = DioClient.dio;
  
  //About Api
Future<Map<String, dynamic>?> fetchAbout( String lang) async {
  try {
    final response = await _dio.get(
      "intro",
           queryParameters: {
        "lang": lang,   
      },
      );

    AppLogger.debug(
      "About API Response:\n${response.data}",
    );

    if (response.statusCode == 200) {
      return response.data;
    }
    return null;
  } catch (e, st) {
    AppLogger.error("About API Error: $e\n$st");
    return null;
  }
}

    // Welcome 

    Future<Map<String,dynamic>?> loading() async{
      try{
         final response = await _dio.get("user/loading/loading-screen");
         if(response.statusCode == 200){
          return response.data ;
         } else{
            return null ;
         } 
      }catch(e){
        AppLogger.error("loading Api $e");
      }
    }
}
