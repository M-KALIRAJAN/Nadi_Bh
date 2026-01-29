import 'package:dio/dio.dart';
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/models/PointsNotifations_Model.dart';

class Notificationapiservice {
  final _dio = DioClient.dio;
   
   Future<PointsNotifations> fetchpointsnodification() async{
    try{
       final response = await _dio.post('user-account/notification');
       return PointsNotifations.fromJson(response.data);
    }on DioException catch(e){
      final errmsg = e.response?.data['message'];
      throw errmsg;
    } 
   }
    Future<void> deleteonenotification ({
  required String id
}) async {
  try {
    final response = await _dio.post("userNotifications/clear-notification/$id");
    print("deleteonenotification ${response.data}");
  } on DioException catch(e){
    throw e;
  }
}

Future<void>  deleteallnotification()async{
   try {
    final response = await _dio.post("userNotifications/clear");
    print("deleteonenotification ${response.data}");
  } on DioException catch(e){
    throw e;
  }
}

}