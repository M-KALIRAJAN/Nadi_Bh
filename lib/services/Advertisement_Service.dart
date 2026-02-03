import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/models/Advertisement_Model.dart';

class AdvertisementService {

  final _dio = DioClient.dio;
  Future<Advertisementmodel> fetchadvertisementdata () async{
     try{
        final response = await _dio.get("advertisement");
print("AdvertisementService ${response.data}");
        return Advertisementmodel.fromJson(response.data);
     }on DioException catch(e){
      final error = e.response?.data['message'];
      throw error;
     } 
  }
}