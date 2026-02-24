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

  @override
  void initState() {
    super.initState();
    client = StreamChatService().client;
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final userId = await AppPreferences.getUserId();
    final adminId = widget.adminId;

    if (userId == null || adminId == null) return;

    await StreamChatService().connectUserIfNeeded(userId);

    channel = client.channel(
      'messaging',
      extraData: {
        'members': [userId, adminId],
      },
    );

    await channel!.watch();

    if (mounted) setState(() {});
  }
@override
Widget build(BuildContext context) {
  if (channel == null) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.adminName ?? "Chat")),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  return StreamChat(
    client: client, // ✅ REQUIRED
    child: StreamChannel(
      channel: channel!, // ✅ CORRECT
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
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.btn_primery,
                child: Text(
                  widget.adminName != null &&
                          widget.adminName!.isNotEmpty
                      ? widget.adminName![0].toUpperCase()
                      : "A",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.adminName ?? "Admin",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        body: 
   Column(
  children: [
    Expanded(
      child: StreamMessageListView(
        messageBuilder: (context, details, messages, defaultMessage) {
          final message = details.message;
          final currentUser =
              StreamChat.of(context).client.state.currentUser;

          final isMe = message.user?.id == currentUser?.id;

          if (isMe) {
            return defaultMessage.copyWith(
              showUsername: false,
              showUserAvatar: DisplayWidget.gone,
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 4, horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.btn_primery,
                  child: Text(
                    (widget.adminName?.isNotEmpty ?? false)
                        ? widget.adminName![0].toUpperCase()
                        : "A",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: defaultMessage.copyWith(
                    showUsername: false,
                    showUserAvatar: DisplayWidget.gone,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),

    /// ✅ FILE UPLOAD REMOVED HERE
    StreamMessageInput(
      attachmentButtonBuilder: (context, onPressed) {
        return const SizedBox.shrink();
      },
    ),
  ],
),
      ),
    ),
  );
}
}


// import 'package:flutter/material.dart';
// import 'package:nadi_user_app/preferences/preferences.dart';
// import 'package:stream_chat_flutter/stream_chat_flutter.dart';
// import 'package:nadi_user_app/services/Stream_Chat_Service.dart';

// class ChatDetailsScreen extends StatefulWidget {
//   final String? adminId;
//   final String? adminName;

//   const ChatDetailsScreen({
//     super.key,
//     this.adminId,
//     this.adminName,
//   });

//   @override
//   State<ChatDetailsScreen> createState() =>
//       _ChatDetailsScreenState();
// }

// class _ChatDetailsScreenState
//     extends State<ChatDetailsScreen> {
//   late final StreamChatClient client;
//   Channel? channel;

//   @override
//   void initState() {
//     super.initState();
//     client = StreamChatService().client;
//     _initializeChat();
//   }

//   Future<void> _initializeChat() async {
//     final userId = await AppPreferences.getUserId();
//     final adminId = widget.adminId;

//     if (userId == null || adminId == null) return;

//     await StreamChatService().connectUserIfNeeded(userId);

//     channel = client.channel(
//       'messaging',
//       extraData: {
//         'members': [userId, adminId],
//       },
//     );

//     await channel!.watch();

//     if (mounted) setState(() {});
//   }

// @override
// Widget build(BuildContext context) {
//   if (channel == null) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }

//   return StreamChat(
//     client: client,
//     child: StreamChatTheme(
//       data: StreamChatThemeData.light(), // or custom theme
//       child: StreamChannel(
//         channel: channel!,
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text(widget.adminName ?? "Chat"),
//           ),
//           body: Column(
//             children: const [
//               Expanded(
//                 child: StreamMessageListView(),
//               ),
//               StreamMessageInput(
//                 disableAttachments: true, // file upload works
//               ),
//             ],
//           ),
//         ),
//       ),
//     ),
//   );
// }
// }


