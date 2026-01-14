 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/models/Privacypolicy_Model.dart';
import 'package:nadi_user_app/services/privacypolicy_service.dart';

final Privacypolicyprovider = FutureProvider<Privacypolicy>((ref) async{
      return  PrivacypolicyService().PrivacypolicyList();
} );