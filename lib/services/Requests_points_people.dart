import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/models/Requestspointspeople_Model.dart';

class RequestsPointsPeople {
  final _dio = DioClient.dio;

  Future<Requestspointspeople> fetchrequestspeoplelist() async{
    try{
     final response = await _dio.post('points/people-list');
     return Requestspointspeople.fromJson(response.data);
    }on DioException catch(e){
      final errmsg = e.response?.data['message'];
      throw errmsg;
    }
  }
}