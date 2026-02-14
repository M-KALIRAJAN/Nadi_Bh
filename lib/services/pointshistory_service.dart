 import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/models/PointsHistory_Model.dart';

class PointshistoryService {

  final _dio = DioClient.dio;

  Future<PointsHistory> fetchpointhistory( ) async{
    try{
          final response = await _dio.post('points/history');
       
          return PointsHistory.fromJson(response.data);
    }on DioException catch(e){
       final errmsg = e.response?.data['message'];
       throw errmsg;
    } 
  }
 }