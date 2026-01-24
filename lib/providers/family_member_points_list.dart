import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/models/FamilyMemberPointsList_Model.dart';
import 'package:nadi_user_app/services/FamilyMemberPointsList_Service.dart';

final FamilymemberpointslistProvider =
    FutureProvider<FamilyMemberPointsList>((ref) async {
  return FamilymemberpointslistService().fetchfamilypointlist();
});