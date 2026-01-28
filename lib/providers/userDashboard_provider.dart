 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/services/home_view_service.dart';

final userdashboardprovider = FutureProvider((ref)async{
  final result = await HomeViewService().userDashboard();
  return result;
});