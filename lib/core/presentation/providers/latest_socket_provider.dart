import 'dart:convert';
import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/chat/data/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../data/models/booking_data_model.dart';

class LatestSocketProvider extends ChangeNotifier {
  static final LatestSocketProvider _provider = LatestSocketProvider.internal();

  factory LatestSocketProvider() {
    return _provider;
  }

  LatestSocketProvider.internal();
  final session = locator<Session>();

  var unreadCount = '0';
  final chatController = TextEditingController();

  List<ChatModel> _chatMessagesList = [];

  int unreadMessageCount = 0;
  bool isLoading = true;
  BookingDataModel? bookingDataModel;

  List<ChatModel> get chatMessageList => _chatMessagesList;

  List<Booking> bookingList = [];

  clearBookingList() {
    bookingList.clear();
    notifyListeners();
  }

  updateUnreadCount(val) {
    unreadCount = val;
    notifyListeners();

    log("unrad count :-->> $unreadCount");
  }

  //
  WebSocket? _socket;

  // -----> function to connect the socket <--------- //
  Future<dynamic> connectToSocket(BuildContext context) async {
    log("-------->CONNECTING TO SOCKET <--------");
    log('-------> uri === ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}');
    print(
        '-------> uri === ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}');

    _socket = WebSocket(Uri.parse(
        "ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}"));

    _socket!.connection.listen((event) {
      if (event is Connected) {
        log("************ Connectd ***********");
        print("************ Connectd ***********");
        updateLatLng();

        listenSocketRequests(context);
      } else {
        log("************ DisConnectd ***********");
        print("************ DisConnectd ***********");
      }
    });
  }

  Future<void> disconnectSocket() async {
    _socket!.close();
  }

  joinExitRoom({int? receiverId, required String type}) {
    markMessageAsRead(receiverId: receiverId);
    log("join socket called $type");
    if (type == 'Join') {
      isLoading = true;
      notifyListeners();
    } else if (type == 'unJoin') {
      getTotalUnreadCount(receiverId);
      // clearChatList();
    }
    // if (type == 'join') {
    //   markMessageAsRead(receiverId: receiverId);
    // }
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

  void listenSocketRequests(BuildContext context) {
    _socket!.messages.listen((event) {
      //  Decoding data
      var response = jsonDecode(event);

      print("socket listen :-->> $response");

      log('-----Event  ${response.toString()}');

      // <----------- Checking When request come ---------> //
      if (response['type'] == 'CustomerBookRequest') {
        bookingDataModel = BookingDataModel.fromJson(response);
        bookingList.add(bookingDataModel!.data);
        notifyListeners();
      }

      // <----------- Checking When request come ---------> //
      if (response['type'] == 'MessageList') {
        log("messgae type is MESSAGE LIST");
        log('Message list data-----> ${response['data']}');
        isLoading = false;
        notifyListeners();
        if (response['data'] != null) {
          addChatAll(
            List<ChatModel>.from(
              response["data"].map(
                (x) => ChatModel.fromMap(x),
              ),
            ),
          );
          // dismissLoading();
          log("chat data is :-->>${chatMessageList.length}");
        } else {
          addChatAll([]);
          // dismissLoading();
        }
      }
      if (response['type'] == 'Chat') {
        addSingleChat(
          ChatModel.fromMap(
            response['data'],
          ),
        );

        log("chat data is :-->>${chatMessageList.length}");
      }
      if (response['type'] == 'UnreadCount') {
        log("unread message count called");

        updateUnReadMessages(count: response['data']);
      }

      log('-----Event  ${response.toString()}');
    });
  }

  addChatAll(List<ChatModel> list) {
    _chatMessagesList = list;
    notifyListeners();
  }

  addSingleChat(ChatModel chat) {
    log("my single chat data is:-->> $chat");
    _chatMessagesList.insert(0, chat);
    notifyListeners();
  }

  updateUnReadMessages({required int count}) {
    unreadMessageCount = count;

    log("un read message count is:-->> $unreadMessageCount");
    notifyListeners();
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
        id: session.orderId,
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

  //   //Get total number of unread message
  getTotalUnreadCount(int? receiverId) {
    log("get total count");
    final map = {
      "userID": session.userId,
      "serviceType": "UnreadCount",
      "room": (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
      "UserType": 'driver'
    };
    log("get total count:$map");
    _socket!.send(jsonEncode(map));

    // listenRequests();
    // disconnectSocket();
    // connectToSocket();
    // listenRequests();
  }

  markMessageAsRead({
    int? receiverId,
  }) {
    log("mark message as read  called");
    final map = {
      "userID": session.userId,
      "serviceType": "",
      "recieverID": receiverId,
      "room": (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
      "SenderType": "Driver",
      "RecieverType": "Customer",
      "type": "read"
    };

    log("mark as read $map");
    _socket!.send(jsonEncode(map));
  }

  clearChatList() {
    _chatMessagesList.clear();
    _chatMessagesList = [];
    notifyListeners();
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

  /// ***************************------------------>>>>>>> UPDATE LAT LONG <<<<<<<<<< *****************--------->>>>>..

  updateLatLng() async {
    Position currentLatLng = await Geolocator.getCurrentPosition();

    print(
        "current latlong:${currentLatLng.latitude},${currentLatLng.longitude}");

    final map = {
      'serviceType': 'UpdatedLatLong',
      'UserID': session.userId,
      'type': 'driver',
      'Latitude': currentLatLng.latitude,
      'Longitude': currentLatLng.longitude,
      'OrderID': ''
    };
    logMe('UPADTE LATLONG -- > ${map.toString()}');
    print('UPADTE LATLONG -- > ${map.toString()}');

    _socket!.send(jsonEncode(map));
  }

  /// ----------------- *********************      ACCEPT THE RIDE **************** --------------------
  acceptRideRequest({required orderId}) {
    final map = {
      'serviceType': 'Accept',
      'UserID': session.userId,
      'orderID': orderId
    };
    logMe('accept ride request socket -- > ${map.toString()}');
    _socket!.send(jsonEncode(map));
  }

  /// -------------******************      REJECT THE RIDE     ************------------------------
  rejectRideRequest({required orderId}) {
    final map = {
      'serviceType': 'Reject',
      'UserID': session.userId,
      'orderID': orderId
    };
    logMe('reject ride request socket -- > ${map.toString()}');
    _socket!.send(jsonEncode(map));
  }
}
