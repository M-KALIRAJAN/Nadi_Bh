import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/models/RequestspointspeopleDetails.dart';
import 'package:nadi_user_app/services/Requests_points_people.dart';

final fetchrequestpeopledetailsprovider = FutureProvider.family<RequestspointspeopleDetails,String>((ref,peopleId) async {
  final result = await RequestsPointsPeople().fetchrequestpeopledetails(peopleId: peopleId);
  return result;
});