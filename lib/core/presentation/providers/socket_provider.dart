import 'dart:convert';

import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_client/web_socket_client.dart';

class SocketProvider with ChangeNotifier {
  static final SocketProvider _singleton = SocketProvider._internal();

  factory SocketProvider() {
    return _singleton;
  }

  SocketProvider._internal();

  WebSocket? _socket;
  final session = locator<Session>();

  connectToSocket() {
    logMe('============= Chat Token ${session.chatToken} ================');
    logMe(
        'URL --> ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}');
    _socket = WebSocket(Uri.parse(
        'ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}'));

    logMe('============= Connecting to Socket ================');
    _socket!.connection.listen((event) {
      logMe('Socket on Listen ---> ${event.toString()}');
      if (event is Connected) {
        listenRequests();
      }
    });
  }

  listenRequests() {
    logMe('============= Listening to requests ================');
    _socket!.messages.listen((event) {
      logMe('Data in socket');
      logMe('Request list data socket-----> ${event.toString()}');
    });
  }

  rejectRequestSocket() {
    final map = {
      'serviceType': 'RejectRequest',
      'driverID': session.userId,
    };
    logMe('reject request socket -- > ${map.toString()}');
    _socket!.send(jsonEncode(map));
  }

  acceptRequestSocket() {
    final map = {
      'serviceType': 'AcceptRequest',
      'driverID': session.userId,
    };
    logMe('reject request socket -- > ${map.toString()}');
    _socket!.send(jsonEncode(map));
  }
}
