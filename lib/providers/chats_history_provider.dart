import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/services/chats_history_service.dart';

final fetchchathistoryprovider = FutureProvider.family<dynamic, Map<String, String>>(
  (ref, params) async {
    final result = await ChatsHistoryService().fetchathistory(
      user1: params['user1']!,
      user2: params['user2']!,
    );
    return result;
  },
);
