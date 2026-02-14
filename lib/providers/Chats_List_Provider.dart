 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/services/chats_list.dart';

final fetchchatslistprovider = FutureProvider((ref) async {
    final result = await ChatsList().fetchchatlist();
    return result;
});