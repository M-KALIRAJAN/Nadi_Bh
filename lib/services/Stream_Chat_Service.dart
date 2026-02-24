// import 'package:nadi_user_app/core/network/dio_client.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// class StreamChatService {
//   static final StreamChatService _instance = StreamChatService._internal();

//   factory StreamChatService() => _instance;

//   StreamChatService._internal();

//   final _dio = DioClient.dio;

//   final StreamChatClient client = StreamChatClient('3e97f3da7ndg');

//   Future<String> ensureStreamUser(String userId,) async {
//     final response = await _dio.post(
//       '/stream-chat/token',
//       data: {
//         'userId': userId,

//       },
//     );
//     return response.data['token'];
//   }

//   Future<void> connectUser(String userId, ) async {
//     // If a user is already connected, disconnect first
//     if (client.state.currentUser != null) {
//       await client.disconnectUser();
//     }

//     final token = await ensureStreamUser(userId);

//     await client.connectUser(
//       User(
//         id: userId,

//       ),
//       token,
//     );

//     print("User connected to Stream ✅");
//   }
// }


import 'package:nadi_user_app/core/network/dio_client.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class StreamChatService {
  static final StreamChatService _instance =
      StreamChatService._internal();

  factory StreamChatService() => _instance;

  StreamChatService._internal();

  final _dio = DioClient.dio;

  late final StreamChatClient _client =
      StreamChatClient(
        '3e97f3da7ndg',
        logLevel: Level.INFO,
      );

  StreamChatClient get client => _client;

  bool _isConnected = false;

  Future<String> _getToken(String userId) async {
    final response = await _dio.post(
      '/stream-chat/token',
      data: {
        'userId': userId,
      },
    );

    return response.data['token'];
  }

  /// ✅ Connect only if not already connected
  Future<void> connectUserIfNeeded(String userId) async {
    if (_isConnected &&
        _client.state.currentUser?.id == userId) {
      return; // already connected
    }

    final token = await _getToken(userId);

    await _client.connectUser(
      User(id: userId),
      token,
    );

    _isConnected = true;

    print("User connected to Stream ✅");
  }

  Future<void> disconnect() async {
    if (_client.state.currentUser != null) {
      await _client.disconnectUser();
      _isConnected = false;
    }
  }
}