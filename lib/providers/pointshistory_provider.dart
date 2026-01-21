 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/services/pointshistory_service.dart';

final pointshistoryprovider = FutureProvider((ref) async{
  final result = await PointshistoryService().fetchpointhistory();
  return result;
});