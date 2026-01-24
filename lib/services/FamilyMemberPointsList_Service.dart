import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/models/FamilyMemberPointsList_Model.dart';

class FamilymemberpointslistService {
   
   final _dio = DioClient.dio;
   Future<FamilyMemberPointsList> fetchfamilypointlist() async{
      try{
        final response = await _dio.get('points/family-members');
        return FamilyMemberPointsList.fromJson(response.data);
      }on DioException catch(e){
        final errmsg = e.response?.data['message'];
        throw errmsg;
      }
   }
}