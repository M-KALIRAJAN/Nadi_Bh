import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/models/RequestspointspeopleDetails.dart';
import 'package:nadi_user_app/models/Requestspointspeople_Model.dart';

class RequestsPointsPeople {
  final _dio = DioClient.dio;

  Future<Requestspointspeople> fetchrequestspeoplelist() async {
    try {
      final response = await _dio.post('points/people-list');
      print("fetchrequestspeoplelist *****${response.data}");
      return Requestspointspeople.fromJson(response.data);
    } on DioException catch (e) {
      final errmsg = e.response?.data['message'];
      throw errmsg;
    }
  }

  Future<RequestspointspeopleDetails> fetchrequestpeopledetails({
    required String peopleId,
  }) async {
    try {
      final response = await _dio.post(
        'points/requestList',
        data: {"peopleId": peopleId},
      );
      print("fetchrequestpeopledetails****** ${response.data}");
      return RequestspointspeopleDetails.fromJson(response.data);
    } on DioException catch (e) {
      final err = e.response?.data['message'];
      throw err;
    }
  }
   Future<void> fetchacceptorrejectpoints({
    required String requestId,
    required String action
   }) async{
     try{
      final response = await _dio.post(
        'points/transfer-points',
        data: {
        "requestId":requestId,
        "action":action
        }
        );
     } on DioException catch(e){
        throw e;
     }
   }

}
