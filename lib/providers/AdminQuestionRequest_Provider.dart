import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/models/Adminquestioner_Model.dart';
import 'package:nadi_user_app/services/admin_questioner.dart';

final fetchadminquestionrequestprovider = FutureProvider<Adminquestioner>((ref) async {
  final result = await AdminQuestioner().fetchadminrequestquestion();
  return result;
});
