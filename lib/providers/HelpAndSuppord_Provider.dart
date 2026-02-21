
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/models/HelpAndSupport_Model.dart';
import 'package:nadi_user_app/providers/language_provider.dart';
import 'package:nadi_user_app/services/helpandsupport_service.dart';


final helpandsupportprovider = FutureProvider<Helpandsupport>((ref)async{
  final locale = ref.watch(languageProvider);
  final lang = locale.languageCode;
   return HelpandsupportService().HelpAndSupport(lang);
});