import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/models/points_request_model.dart';

class RequestedPoints {
  final _dio = DioClient.dio;
   Future<PointsRequestModel> fetchrequestedpoints() async{
      try{
        final response = await _dio.post('points/requested-list');
         return PointsRequestModel.fromJson(response.data);
      } on DioException catch(e){
          final errmsg = e.response?.data['message'];
          print("fetchrequestedpointserr $errmsg");
          throw errmsg;
      }
   }
}  