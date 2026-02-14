import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:nadi_user_app/providers/chat_provider.dart';
import 'package:nadi_user_app/providers/chats_history_provider.dart';
import 'package:nadi_user_app/providers/socket_provider.dart';

import 'package:nadi_user_app/widgets/inputs/app_text_field.dart';

class ChatDetailsScreen extends ConsumerStatefulWidget {
  final String? userId;
  final String? userName;

  const ChatDetailsScreen({super.key, this.userId, this.userName});

  @override
  ConsumerState<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends ConsumerState<ChatDetailsScreen> {
  final TextEditingController messageController = TextEditingController();
  String? currentUserId;
  Map<String, String>? chatParams;

  @override
  void initState() {
    super.initState();
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final id = await AppPreferences.getUserId();
    setState(() {
      currentUserId = id;
      if (widget.userId != null) {
        chatParams = {"user1": currentUserId!, "user2": widget.userId!};
      }
    });

    // Fetch initial chat history
   if (chatParams != null) {
      final initialMessages = await ref
          .read(fetchchathistoryprovider(chatParams!).future);

      // Cast to List<Map<String, dynamic>>
      final messages = (initialMessages as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();

      ref.read(chatHistoryProvider.notifier).setMessages(messages);
    }

    // Setup socket listener
    final socket = ref.read(socketProvider);
        socket.emit("join", {
  "userId": currentUserId,
  "role": "user",
});
    socket.on("receive_message", (data) {
      final message = data is Map
          ? Map<String, dynamic>.from(data)
          : Map<String, dynamic>.from(data);
      ref.read(chatHistoryProvider.notifier).addMessage(message);
      print("📩 New message received: $message");
    });
    socket.on("message_sent", (data) {
  final message = Map<String, dynamic>.from(data);
  ref.read(chatHistoryProvider.notifier).addMessage(message);
});

  }

void sendMessage() {
  final text = messageController.text.trim();
  if (text.isEmpty || currentUserId == null) return;

  final socket = ref.read(socketProvider);

  if (!socket.connected) {
    print("⚠️ Socket not connected yet!");
    return;
  }

  socket.emit("send_message", {
    "from": currentUserId,
    "to": widget.userId,
    "fromRole": "user",
    "toRole": "admin",
    "message": text,
  });

  messageController.clear();
}

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null || widget.userId == null || chatParams == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final chatMessages = ref.watch(chatHistoryProvider);

    String firstLetter =
        (widget.userName != null && widget.userName!.isNotEmpty)
            ? widget.userName![0].toUpperCase()
            : "?";

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color.fromRGBO(13, 95, 72, 1),
              child: Text(
                firstLetter,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.userName ?? "",
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    "online",
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.call_outlined), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // CHAT LIST
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                final message = chatMessages[chatMessages.length - 1 - index];
                final isMe = message['from'] == currentUserId;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isMe
                          ? const Color.fromRGBO(13, 95, 72, 1)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: Radius.circular(isMe ? 12 : 0),
                        bottomRight: Radius.circular(isMe ? 0 : 12),
                      ),
                    ),
                    child: Text(
                      message['message'] ?? '',
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // CHAT INPUT BAR
          SafeArea(
            bottom: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      controller: messageController,
                      label: "Type message...",
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(13, 95, 72, 1),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
