import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/providers/language_provider.dart';
import 'package:nadi_user_app/services/about_service.dart';
import 'package:nadi_user_app/models/About_Model.dart';

final aboutProvider = FutureProvider<About>((ref) async {
  final local = ref.watch(languageProvider);
  final lang = local.languageCode;
  return AboutService().AboutList(lang);
});
