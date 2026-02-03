 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/services/admin_questioner.dart';

final fetchadminquestionerprovider = FutureProvider((ref)async{
 
  final result = await AdminQuestioner().fetchadminlist();
  return result;
});