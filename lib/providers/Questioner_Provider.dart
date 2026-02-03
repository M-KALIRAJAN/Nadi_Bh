 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/models/Questioner_Model.dart';
import 'package:nadi_user_app/services/Questioner_Service.dart';

final fetchquestionsdataprovider = FutureProvider<Questioner>((ref) async {
   final result = await QuestionerService().fetchquestionsdata();
   return result;
});