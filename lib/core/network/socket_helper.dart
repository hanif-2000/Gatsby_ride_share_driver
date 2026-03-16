import 'dart:async';

import 'package:web_socket_client/web_socket_client.dart';

import '../utility/injection.dart';
import '../utility/session_helper.dart';

class WebSocketHelper {
  static final WebSocketHelper _singleton = WebSocketHelper._internal();
  final Duration _timeout;
  final ConstantBackoff _backoff;
  late WebSocket _socket;
  final session = locator<Session>();
  bool isConnected=false;
  late Uri _uri;

  WebSocketHelper._internal()
      : _timeout = const Duration(seconds: 10),
        _backoff = const ConstantBackoff(Duration(seconds: 5)) {
    _updateUri();
  }

  factory WebSocketHelper() => _singleton;

  void _updateUri() {
    _uri =  Uri.parse("ws://3.97.35.163:8051?token=${session.chatToken}&room=0&userID=${session.userId}");
    print("SocketUrl =>$_uri");
  }


  WebSocket getSocket()  => _socket;


  void connect() {
    if (session.userId.isNotEmpty) {
      _updateUri(); // Update URI with the latest token and user ID
      // Don't create new socket if already connected or reconnecting
      try {
        final state = _socket.connection.state;
        if (state is Connected || state is Reconnecting) {
          isConnected = state is Connected;
          return;
        }
      } catch (_) {
        // _socket not yet initialized, proceed to create
      }
      _socket = WebSocket(_uri, timeout: _timeout, backoff: _backoff);
      _socket.connection.listen((event) {
        print('Websocket Connection state: "$event"',);
        if(event is Connected){
          isConnected = true;
        }else if(event is Reconnected){
          isConnected = true;
        }else{
          isConnected = false;
        }
      });
    }
  }

  void close([int? code, String? reason]) {
    isConnected = false;
    if (_socket.connection.state is Disconnected) return;
    _socket.close(code, reason);
  }

  void sendMessage(Map map) {
    _socket.send(map);
  }

}