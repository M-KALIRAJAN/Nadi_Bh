// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketService {

//   /// SINGLETON
//   static final SocketService _instance = SocketService._internal();
//   factory SocketService() => _instance;
//   SocketService._internal();

//   IO.Socket? socket;

//   /// CONNECT SOCKET
//   void connect({required String url}) {

//     socket = IO.io(
//       url,
//       IO.OptionBuilder()
//           .setTransports(['websocket'])
//           .enableAutoConnect()
//           .build(),
//     );

//     socket!.onConnect((_) {
//       print("✅ Socket Connected");
//     });

//     socket!.onDisconnect((_) {
//       print("❌ Socket Disconnected");
//     });

//     socket!.onError((data) {
//       print("Socket Error: $data");
//     });
//   }

//   /// SEND MESSAGE
//   void sendMessage(Map<String, dynamic> data) {
//     socket?.emit("send_message", data);
//   }

//   /// LISTEN NEW MESSAGE
//   void onReceiveMessage(Function(dynamic) callback) {
//     socket?.on("receive_message", callback);
//   }

//   /// DISCONNECT
//   void disconnect() {
//     socket?.disconnect();
//   }
// }
