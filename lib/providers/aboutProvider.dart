import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/services/about_service.dart';
import 'package:nadi_user_app/models/About_Model.dart';

final aboutProvider = FutureProvider<About>((ref) async {
  return AboutService().AboutList();
});
