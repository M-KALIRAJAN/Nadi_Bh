import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/services/requested_points.dart';

final fetchrequestedpointsprovider = FutureProvider((ref)async{
   final result = await RequestedPoints().fetchrequestedpoints();
   return result;
});