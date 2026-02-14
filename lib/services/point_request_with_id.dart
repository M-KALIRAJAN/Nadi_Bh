import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';

class PointRequestWithId {
   final _dio = DioClient.dio;

   Future<void> fetchrequestwithid({
    required String receiverId,
    required String points
   }) async{
    try{
      final  response = await _dio.post(
        "points/request-with-id",
        data: {
          "receiverId":receiverId,
          "points":points
        } 
     
        );
   
    }on DioException catch(e){
      final err = e.response?.data['message'];
      throw err;
    }
   }
}