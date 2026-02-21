
import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// 



class StreamChatService {
  static final StreamChatService _instance =
      StreamChatService._internal();

  factory StreamChatService() => _instance;

  StreamChatService._internal();

  final _dio = DioClient.dio;

  final StreamChatClient client =
      StreamChatClient('3e97f3da7ndg');

  Future<String> ensureStreamUser(String userId) async {
    final response = await _dio.post(
      '/stream-chat/token',
      data: {'userId': userId},
    );

    return response.data['token'];
  }

  Future<void> connectUser(String userId) async {
    final token = await ensureStreamUser(userId);

    await client.connectUser(
      User(id: userId),
      token,
    );

    print("User connected to Stream ✅");
  }
}