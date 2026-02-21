import 'package:flutter/material.dart';
import 'package:nadi_user_app/core/constants/app_consts.dart';
import 'package:nadi_user_app/preferences/preferences.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:nadi_user_app/services/Stream_Chat_Service.dart';

class ChatDetailsScreen extends StatefulWidget {
  final String? adminId;
  final String? adminName;

  const ChatDetailsScreen({super.key, this.adminId, this.adminName});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  late final StreamChatClient client;
  Channel? channel;
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    client = StreamChatService().client;
    setupStreamChat();
  }

  // Future<void> setupStreamChat() async {
  //   // Get current user ID
  //   currentUserId = await AppPreferences.getUserId();
  //   final adminId = widget.adminId!;

  //   // Ensure both users exist in Stream (backend upserts them)
  //   await StreamChatService().ensureStreamUser(currentUserId!);
  //   await StreamChatService().ensureStreamUser(adminId);

  //   // Connect current user only
  //   await StreamChatService().connectUser(currentUserId!);

  //   // Create channel with both users as members
  //   channel = client.channel(
  //     'messaging',
  //     id: '${currentUserId}_${adminId}', // Optional: unique channel id
  //     extraData: {
  //       'members': [currentUserId, adminId]
  //     },
  //   );
  //   await channel!.watch();

  //   setState(() {});
  // }

Future<void> setupStreamChat() async {
  final streamService = StreamChatService();

  final userId = await AppPreferences.getUserId();
  final adminId = widget.adminId!;

  // Connect current user ONLY once
  await streamService.connectUser(userId!);

  // Create channel
  channel = streamService.client.channel(
    'messaging',
    extraData: {
      'members': [userId, adminId]
    },
  );

  await channel!.watch();
  setState(() {});
}
@override
Widget build(BuildContext context) {
  if (channel == null) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.adminName ?? "Chat")),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  return StreamChannel(
    channel: channel!,
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Row(
              children: [
  CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.btn_primery,
              child: Text(
                widget.adminName != null && widget.adminName!.isNotEmpty
                    ? widget.adminName![0].toUpperCase()
                    : "A",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
  
            // Admin Name
            Text(
              widget.adminName ?? "Admin",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
              ],
            ),
            
          ],
        ),
      ),
      body: Column(
        children: const [
          Expanded(child: StreamMessageListView()),
          StreamMessageInput(),
        ],
      ),
    ),
  );
}
}