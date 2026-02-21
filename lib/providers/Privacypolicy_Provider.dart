 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/models/Privacypolicy_Model.dart';
import 'package:nadi_user_app/providers/language_provider.dart';
import 'package:nadi_user_app/services/privacypolicy_service.dart';

final Privacypolicyprovider = FutureProvider<Privacypolicy>((ref) async{
  
  final locale = ref.watch(languageProvider);
  final lang = locale.languageCode;
      return  PrivacypolicyService().PrivacypolicyList(lang);
} );