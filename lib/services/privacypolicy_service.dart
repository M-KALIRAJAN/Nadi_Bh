 import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/models/Privacypolicy_Model.dart';

class PrivacypolicyService {
   final _dio = DioClient.dio;

   Future<Privacypolicy> PrivacypolicyList( String lang) async{
      try{
        final response = await _dio.get(
          "privacy",
          queryParameters: {
            "lang": lang,
          }
          );
        return Privacypolicy.fromJson(response.data);

      } on DioException catch(e){
        final message = e.response?.data?['message']?? 'Something went wrong';     
  throw Exception(message);
        
      }
   }
 }