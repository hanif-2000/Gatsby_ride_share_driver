import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../utility/injection.dart';
import '../utility/session_helper.dart';

class WebSocketHelper {
  static final WebSocketHelper _singleton = WebSocketHelper._internal();
  final session = locator<Session>();
  IO.Socket? _socket;
  bool isConnected = false;

  WebSocketHelper._internal();
  factory WebSocketHelper() => _singleton;

  Function? onConnectCallback;
  Function? onReconnectCallback;

  IO.Socket getSocket() => _socket!;

  void _emitJoinDriver() {
    if (_socket == null || !isConnected) return;
    if (session.userId.isEmpty) return;

    _socket!.emit('join_driver', {
      'driver_id': session.userId,
    });

    log("📤 join_driver emitted for driver ${session.userId}");
  }

  void connect() {

    if (session.userId.isEmpty) {
      log("⚠️ Socket connect skipped: userId is empty — retrying in 2s...");
      Future.delayed(const Duration(seconds: 2), () => connect());
      return;
    }

    if (isConnected && _socket != null && _socket!.connected) {
      log("✅ Socket already connected — skipping");
      return;
    }

    if (_socket != null && !_socket!.connected) {
      log("⚠️ Stale socket found — disposing and reconnecting");
      _socket!.dispose();
      _socket = null;
      isConnected = false;
    }

    final url = "https://api.gatsbyrideshare.com";
    log("🔌 SocketUrl => $url  userId=${session.userId}  token=${session.sessionToken.isNotEmpty ? 'SET' : 'EMPTY'}");

    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(3000)
          .setReconnectionDelayMax(30000)
          .setAuth({'token': session.sessionToken})
          .setQuery({
            'room': '0',
            'userID': session.userId,
          })
          .build(),
    );

    _socket!.onConnect((_) {
      isConnected = true;
      log("✅ Socket.io Connected — id: ${_socket!.id}");

      _emitJoinDriver();

      onConnectCallback?.call();
    });

    _socket!.onDisconnect((_) {
      isConnected = false;
      log("❌ Socket.io Disconnected");
    });

    _socket!.onReconnect((_) {
      isConnected = true;
      log("🔄 Socket.io Reconnected");

      _emitJoinDriver();

      onReconnectCallback?.call();
    });

    _socket!.onReconnecting((_) {
      isConnected = false;
      log("🔄 Socket.io Reconnecting...");
    });

    _socket!.onConnectError((data) {
      isConnected = false;
      log("🔴 Socket.io Connect Error: $data");
    });

    _socket!.onError((data) {
      log("🔴 Socket.io Error: $data");
    });

    _socket!.connect();
  }

  void close([int? code, String? reason]) {
    isConnected = false;
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    log("🔌 Socket closed");
  }

  void sendMessage(Map map) {
    if (_socket != null && isConnected) {
      _socket!.emit('message', map);
      log("📤 Message sent: $map");
    } else {
      log("⚠️ Socket sendMessage failed: not connected");
    }
  }
}