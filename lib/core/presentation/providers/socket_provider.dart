import 'dart:convert';
import 'dart:developer';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/chat/data/model/chat_model.dart';
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
  // final chatProvider = locator<ChatProvider>();

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
        log("Socket event is connected");
        // listenRequests();
      }
    });
  }

  Future<void> disconnectSocket() async {
    _socket!.close();
  }

  listenRequests() {
    logMe('============= Listening to requests ================');

    _socket!.messages.listen(
      (event) {
        final response = jsonDecode(event);
        logMe('Message list data-----> ${response.toString()}');
        if (response['type'] == 'MessageList') {
          logMe(
              'Message list data WHEN TYPE IS MESSAGELIST-----> ${response['data']}');
          if (response['data'] != null) {
            addChatAll(
              List<ChatModel>.from(
                response["data"].map(
                  (x) => ChatModel.fromMap(x),
                ),
              ),
            );
          } else {
            addChatAll([]);
          }
        }
        if (response['type'] == 'Chat') {
          addSingleChat(
            ChatModel.fromMap(
              response['data'],
            ),
          );
        }
      },
    );
  }

  rejectRequestSocket() {
    final map = {
      'serviceType': 'RejectRequest',
      'driverID': session.userId,
    };
    logMe('reject request socket -- > ${map.toString()}');
    _socket!.send(
      jsonEncode(map),
    );
  }

  acceptRequestSocket() {
    final map = {
      'serviceType': 'AcceptRequest',
      'driverID': session.userId,
    };
    logMe('reject request socket -- > ${map.toString()}');
    _socket!.send(jsonEncode(map));
  }

  joinExitRoom({int? receiverId, String type = 'Join'}) {
    final map = {
      'type': 'Driver',
      'serviceType': type,
      'UserID': session.userId,
      'roomID': (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
    };
    logMe('Join Exit room socket -- > ${map.toString()}');
    _socket!.send(
      jsonEncode(map),
    );
    // listenRequests();
  }

  sendChatMessage({
    String? message,
    int? receiverId,
    String? messageType = 'Text',
  }) {
    // final chatProvider = locator<ChatProvider>();
    final map = {
      "userID": session.userId,
      "serviceType": "Chat",
      "recieverID": receiverId,
      "msg": message,
      "room": (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
      "MessageType": "Text",
      "SenderType": "Driver",
      "RecieverType": "Customer",
      "type": "Chat"
    };
    print('Message send ---> ${map.toString()}');
    _socket!.send(jsonEncode(map));
    addSingleChat(
      ChatModel(
        id: '1',
        messageType: 'Text',
        roomId: (int.parse(session.userId) > receiverId)
            ? '$receiverId-${session.userId}'
            : '${session.userId}-$receiverId',
        message: message,
        senderType: 'Driver',
        recieverType: 'Customer',
        sourceUserId: session.userId,
        targetUserId: receiverId.toString(),
        createdOn: DateTime.now(),
        modifiedOn: DateTime.now(),
      ),
    );
  }

  markMessageAsRead({
    int? receiverId,
  }) {
    final map = {
      "userID": session.userId,
      "serviceType": "Chat",
      "recieverID": receiverId,
      "room": (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
      "SenderType": "Driver",
      "RecieverType": "Customer",
      "type": "read"
    };
    _socket!.send(jsonEncode(map));
  }

  final chatController = TextEditingController();

  List<ChatModel> _chatMessagesList = [];

  List<ChatModel> get chatMessageList => _chatMessagesList;

  clearChatList() {
    _chatMessagesList.clear();
    _chatMessagesList = [];
    notifyListeners();
  }

  addChatAll(List<ChatModel> list) {
    _chatMessagesList = list;
    notifyListeners();
  }

  addSingleChat(ChatModel chat) {
    _chatMessagesList.insert(0, chat);
    notifyListeners();
  }
}
