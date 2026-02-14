import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final socketProvider = Provider<IO.Socket>((ref) {
  final socket = IO.io(
    "https://srv1252888.hstgr.cloud",
    IO.OptionBuilder()
        .setTransports(['websocket']) // IMPORTANT for mobile
        .disableAutoConnect() // control connection manually
        .setPath('/socket.io')
        .build(),
  );

  /// ===== CONNECT =====
  socket.connect();

  /// ===== LISTENERS =====
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

  /// ===== DISPOSE WHEN PROVIDER DESTROYED =====
  ref.onDispose(() {
    print("🧹 Disposing socket...");
    socket.disconnect();
    socket.dispose();
  });

  return socket;
});
