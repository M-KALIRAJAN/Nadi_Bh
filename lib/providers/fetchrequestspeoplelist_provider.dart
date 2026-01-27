import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/services/Requests_points_people.dart';


final fetchrequestpeoplelistprovider = FutureProvider((ref) async{
  final result = await RequestsPointsPeople().fetchrequestspeoplelist();
  return result ;
});