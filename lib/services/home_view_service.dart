import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:nadi_user_app/core/utils/logger.dart';
import 'package:nadi_user_app/models/ServiceOverview_Model.dart';
import 'package:nadi_user_app/models/Userdashboard_model.dart';

class HomeViewService {
  final _dio = DioClient.dio;
  // Service List API
  Future<List<Map<String, dynamic>>> servicelists( String lang) async {
    try {
      final response = await _dio.get(
        "service",
        queryParameters: {
          "lang":lang
        }
        );
   /// 🔥 LOG FULL RESPONSE
    AppLogger.info("Service API FULL RESPONSE => ${response.data}");

    /// 🔥 LOG ONLY DATA FIELD
    AppLogger.info("Service API DATA => ${response.data["data"]}");
      return List<Map<String, dynamic>>.from(response.data["data"]);
    } catch (e) {
      AppLogger.error("servicelist Api: $e");
      return [];
    }
  }

  Future<UserdashboardModel> userDashboard() async {
    try {
      final response = await _dio.post("userDashboard");
      final data = response.data['data'];

      return UserdashboardModel.fromJson(data);
    } catch (e) {
      AppLogger.error("userDashboard: $e");
      rethrow;
    }
  }
  Future<ServiceoverviewModel> serviceoverview()async{
    try{
      final response = await _dio.post("userDashboard/service-overview");
          final model =
        ServiceoverviewModel.fromJson(response.data['data']);
        return model;
    }catch(e){
      AppLogger.error("serviceoverview $e");
      rethrow;
    }
  }
}
