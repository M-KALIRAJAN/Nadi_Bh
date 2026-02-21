import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

// final socketProvider = Provider<IO.Socket>((ref) {
//   final socket = IO.io(
//     "http://srv1252888.hstgr.cloud:80",
//     IO.OptionBuilder()
//         .setPath('/socket.io')
//          .setTransports(['polling','websocket']) // IMPORTANT for mobile
//         .disableAutoConnect() // control connection manually
//         .build(),
//   );

//   /// ===== CONNECT =====
//   socket.connect();

//   /// ===== LISTENERS =====
//   socket.onConnect((_) {
//     print("✅ Socket connected: ${socket.id}");
//   });

//   socket.onDisconnect((_) {
//     print("❌ Socket disconnected");
//   });

//   socket.onConnectError((data) {
//     print("⚠️ Connect Error: $data");
//   });

//   socket.onError((err) {
//     print("⚠️ Socket Error: $err");
//   });

//   /// ===== DISPOSE WHEN PROVIDER DESTROYED =====
//   ref.onDispose(() {
//     print("🧹 Disposing socket...");
//     socket.disconnect();
//     socket.dispose();
//   });

//   return socket;
// });






final socketProvider = Provider<IO.Socket>((ref) {
  final socket = IO.io(
    "https://srv1252888.hstgr.cloud", // Use https
    IO.OptionBuilder()
        .setTransports(['websocket']) // force websocket
        .disableAutoConnect()
        .setPath('/socket.io') // optional
        .enableForceNew() // ensures fresh socket each connect
        .build(),
  );

  socket.connect();

  socket.onConnect((_) {
    print("✅ Socket connected: ${socket.id}");
  });

  socket.onDisconnect((_) {
    print("❌ Socket disconnected");
  });

  socket.onConnectError((data) {
    print("⚠️ Connect Error: $data");
  });

  socket.onError((err) {
    print("⚠️ Socket Error: $err");
  });

  ref.onDispose(() {
    socket.disconnect();
    socket.dispose();
  });

  return socket;
});