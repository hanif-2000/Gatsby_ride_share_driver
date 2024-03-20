import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:appkey_taxiapp_driver/core/data/models/customer_detail_model.dart';
import 'package:appkey_taxiapp_driver/core/data/models/socket_response_model/cancel_by_user_model.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/chat/data/model/chat_model.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/entities/order_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_client/web_socket_client.dart';

import '../../../features/order/data/models/driver_location_response_model.dart';
import '../../../features/receipt/data/model/new_receipt_model.dart';
import '../../../features/receipt/persentation/provider/receipt_provider.dart';
import '../../data/models/booking_data_model.dart';
import '../../data/models/google_route_response_modal.dart';
import '../../data/models/socket_response_model/accept_by_other_driver_model.dart';
import '../../static/assets.dart';
import '../../utility/app_settings.dart';
import '../../utility/direction_helper.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'dart:math' as Math;

class LatestSocketProvider extends ChangeNotifier {
  // static final LatestSocketProvider _provider = LatestSocketProvider.internal();

  // factory Provider.of<LatestSocketProvider>(locator<GlobalKey<NavigatorState>>().currentContext!) {
  //   return _provider;
  // }

  static final LatestSocketProvider _provider = LatestSocketProvider.internal();

  factory LatestSocketProvider() {
    return _provider;
  }
  // final bool _disposed = false;

  LatestSocketProvider.internal();

  final session = locator<Session>();
  // final orderProvider = locator<OrderProvider>();

  var unreadCount = '0';
  final chatController = TextEditingController();

  List<ChatModel> _chatMessagesList = [];
  int currentOrderStatus = 0;
  String rideText = "Start Ride to Pickup Location";

  late GoogleMapController googleMapController;

  final dio = Dio();

  // CustomerDataModel? customerDataModel;
  OrderDetail? orderDetail;

  ReceiptData? receiptData;

  Future<void> updateReceiptData({data}) async {
    receiptData = data;
    notifyListeners();
  }

  updateCurrentStatus({required int status}) {
    currentOrderStatus = status;
    notifyListeners();
  }

  updateRideText({required String txt}) {
    rideText = txt;
    notifyListeners();
  }

  @override
  // ignore: must_call_super
  void dispose() {}

  // @override
  // void notifyListeners() {
  //   if (!_disposed) {
  //     super.notifyListeners();
  //   }
  // }

  // disposed(){

  // }

  /// UPDATE CUSTOMER AND ORDER DETAILS TO LOCAL

  updateCustomerLocal({
    required String img,
    required String rating,
    required String phn,
    required String name,
  }) {
    session.setCustomerImg = img;
    session.setCustomerRating = rating;
    session.setCustomerPhn = phn;
    session.setCustomerName = name;
    notifyListeners();
  }

  /// CUSTOMER DETAILS

  String customerName = '';
  String customerRating = '';
  String rideNewTotal = '';
  String customerProfilePic = '';
  String rideDistance = '';

  /// UPDATE CUSTOMER --->> and <<<--- RIDE DETAILS

  updateCustomerAndRideDetails({
    required String name,
    required String rating,
    required String newTotal,
    required String profilePic,
    required String distance,
  }) {
    print("******* UPDATE CUSTOMER AND RIDE DETALS CALLED");
    customerName = name;
    customerRating = rating;
    rideNewTotal = newTotal;
    customerProfilePic = profilePic;
    rideDistance = distance;
    notifyListeners();
  }

  int unreadMessageCount = 0;
  bool isLoading = true;
  BookingDataModel? bookingDataModel;
  CancelByUserModel? cancelByUserModel;
  AcceptByOtherDriverModel? acceptByOtherDriverModel;

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

  //UPDATE CUSTOMER DATA MODEL

  Future<bool> updateCustomerData({required CustomerDataModel data}) async {
    print(
        "************* customer data model is and UPDATE CUSTOMER DATA CALLED ---->>>>  $data <<<<<<<<<--------------");
    _customerDetail = data;

    notifyListeners();
    return true;
  }

  //UPDATE ORDER DATA MODEL

  updateOrderData({required OrderDetail data}) {
    orderDetail = data;
    notifyListeners();
  }

// REMOVE ORDER FROM BOOKING LIST
  removeOrderFromList({required orderId}) {
    print(
        "********** ------>>>>>>> REMOVE ORDER FROM LIST CALLED <<<<<<<<<<------ ***********");
    bookingList.removeWhere((element) {
      return element.id.toString() == orderId.toString();
    });

    notifyListeners();
  }

  //
  late WebSocket _socket;

  // -----> function to connect the socket <--------- //
  Future<dynamic> connectToSocket(BuildContext context) async {
    log("-------->CONNECTING TO SOCKET <--------");

    // ws://3.97.35.163:8051
    log('-------> uri === ws://3.97.35.163:8051?token=${session.chatToken}&room=0&userID=${session.userId}');
    print(
        '-------> uri === ws://3.97.35.163:8051?token=${session.chatToken}&room=0&userID=${session.userId}');
    // _socket = WebSocket(
    //   Uri.parse(
    //       "ws://shakti.parastechnologies.in:8051?token=${session.chatToken}&room=0&userID=${session.userId}"),

    _socket = WebSocket(
      Uri.parse("ws://3.97.35.163:8051?token=${session.chatToken}&room=0&userID=${session.userId}"),
      // pingInterval: const Duration(seconds: 5)
    );

    _socket.connection.listen((event) {
      if (event is Connected) {
        log("************ Connectd ***********");
        print("************ Connectd ***********");
        listenSocketRequests(context);
        updateLatLngAtStarting();
      } else if (event is Disconnected) {
        log("************ DisConnectd ***********");
        print("************ DisConnectd ***********");
        // reconnectSocket(context);
      } else if (event is Reconnected) {
        listenSocketRequests(context);
        // updateLatLngAtStarting();
      } else {
        print("************ Socket State: $event***********");
      }
    });
  }

  // reconnectSocket(
  //   BuildContext context,
  // ) {
  //   print("Disconnected=============>>${_socket.connection.state})");
  //   if (_socket.connection.state is Disconnected &&
  //       session.sessionToken.isNotEmpty) {
  //     print("Disconnected=============>>");
  //     Future.delayed(const Duration(seconds: 2), () {
  //       connectToSocket(context);
  //     });
  //   } else {
  //     print("Disconnected=============>> else");
  //   }
  // }

  // Future<void> disconnectSocket() async {
  //   _socket.close(1000);
  // }

  Future<void> disconnectSocket() async {
    _socket.close(1000, "Logout successful");
  }

  joinExitRoom({int? receiverId, required String type}) {
    markMessageAsRead(receiverId: receiverId);
    log("join socket called $type");
    print("join socket called $type");

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
    print('Join Exit room socket -- > ${map.toString()}');

    _socket.send(
      jsonEncode(map),
    );
    // listenRequests();
  }

  updateRideList(Booking data) {
    // bookingDataModel = BookingDataModel.fromJson(data);
    bookingList.insert(0, data);
    bookingList = bookingList.toSet().toList();
    notifyListeners();
  }

  void listenSocketRequests(BuildContext context) {
    _socket.messages.listen((event) {
      var response = jsonDecode(event);
      print("socket listen :-->> $response");

      log('-----Event  ${response.toString()}');

      // <----------- Checking When request come ---------> //
      if (response['type'] == "CustomerBookRequest") {
        print("socket listen CustomerBookRequest:-->> $response");
        bookingDataModel = BookingDataModel.fromJson(response);
        bookingList.insert(0, bookingDataModel!.data);
        notifyListeners();
        print("socket listen bookingList:-->> ${bookingList.length}");
      }

      // <------------------ Cancel BY Customer --------->>>>>
      if (response['type'] == 'CancelByUser') {
        cancelByUserModel = CancelByUserModel.fromJson(response);
        bookingList.removeWhere((element) {
          return element.id == cancelByUserModel!.orderId;
        });
        notifyListeners();
      }

      // <------------------ Accept BY OTHER DRIVER --------->>>>>
      if (response['type'] == 'AcceptByOther') {
        print("*****----->>> RIDE ACCEPTED BY OTHER -----<<<<<");
        acceptByOtherDriverModel = AcceptByOtherDriverModel.fromJson(response);
        print("Ride details are:-->> $acceptByOtherDriverModel");
        print("Ride details are:-->> $acceptByOtherDriverModel");
        print("Ride details are data:-->> $response");

        if (acceptByOtherDriverModel!.driverId != session.userId) {
          bookingList.removeWhere((element) {
            return element.id == cancelByUserModel!.orderId;
          });

          // CustomerDetailModel(data: CustomerDataModel(name: acceptByOtherDriverModel.data., phoneNumber: phoneNumber, photo: photo, id: id, rating: rating) )
          notifyListeners();
        } else if (acceptByOtherDriverModel!.driverId == session.userId) {
          log("driver is mine ");
          print("driver is mine ");
        }
      }
      // Save UserData to SharedPreferences
      void saveOrderReceipt() {
        session.setIsPaymentDone = false;
        session.setIsRatingGiven = false;
        logMe("save order receipt called");

        if (receiptData != null) {
          logMe("save order receipt called receiptResponseModel ==== NOT NULL");

          session.setOrderReceipt = json.encode(receiptData!);
          // _prefs.setString(_userDataKey, jsonEncode(_userData!.toMap()));
        }
      }

      // <------------------ RIDE END OR COMPLETED --------->>>>>
      if (response['type'] == 'endTrip') {
        updateReceiptData(data: ReceiptData.fromJson(response["data"]));

        // receiptData = ReceiptData.fromJson(response);
        notifyListeners();
        saveOrderReceipt();

        log("my receipt data is:-->> $receiptData");
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

    _socket.send(jsonEncode(map));
    addSingleChat(
      ChatModel(
        id: session.runningOrderId.toString(),
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
    print("get total count");

    final map = {
      "userID": session.userId,
      "serviceType": "UnreadCount",
      "room": (int.parse(session.userId) > receiverId!)
          ? '$receiverId-${session.userId}'
          : '${session.userId}-$receiverId',
      "UserType": 'driver'
    };
    log("get total count:$map");
    print("get total count:$map");

    _socket.send(jsonEncode(map));

    print("customer id is: ${session.customerId} ");

    // joinExitRoom(type: 'unJoin', receiverId: session.driverId);

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
    _socket.send(jsonEncode(map));
  }

  //   //Initial
  CameraPosition kJapanCoordinate = const CameraPosition(
    target: DEFAULT_LATLNG,
    zoom: 14.4746,
  );

  clearChatList() {
    _chatMessagesList.clear();
    _chatMessagesList = [];
    notifyListeners();
  }

  // rejectRequestSocket() {
  //   final map = {
  //     'serviceType': 'RejectRequest',
  //     'driverID': session.userId,
  //   };
  //   logMe('reject request socket -- > ${map.toString()}');
  //   _socket!.send(
  //     jsonEncode(map),
  //   );
  // }

  // acceptRequestSocket() {
  //   final map = {
  //     'serviceType': 'AcceptRequest',
  //     'driverID': session.userId,
  //   };
  //   logMe('reject request socket -- > ${map.toString()}');
  //   _socket!.send(jsonEncode(map));
  // }

  /// ***************************------------------>>>>>>> UPDATE LAT LONG <<<<<<<<<< *****************--------->>>>>..

  updateLatLng({LatLng? latLng, double? bearing = 0}) async {
    print("=====******* UPDATE LAT LONG CALLED =======*******");
    print("current latlong:${latLng!.latitude},${latLng.longitude}");
    session.setCurrentLat = latLng.latitude;
    session.setCurrentLang = latLng.longitude;

    final map = {
      'serviceType': 'UpdatedLatLong',
      'UserID': session.userId,
      'type': 'driver',
      'Latitude': latLng.latitude,
      'Longitude': latLng.longitude,
      'OrderID': session.runningOrderId,
      'bearing': bearing
    };
    logMe('UPADTE LATLONG -- > ${map.toString()}');
    print('UPADTE LATLONG -- > ${map.toString()}');

    // _socket!.send(jsonEncode(map));

    try {
      _socket.send(json.encode(map));
      notifyListeners();
    } catch (e) {
      log(e.toString());
    }
  }

  updateLatLngAtStarting() async {
    print("update lat long at starting called");
    Position currentLatLng = await Geolocator.getCurrentPosition();

    print(
        "current latlong:${currentLatLng.latitude},${currentLatLng.longitude}");
    session.setCurrentLat = currentLatLng.latitude;
    session.setCurrentLang = currentLatLng.longitude;

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

    // try {
    //   _socket.connection.listen((event) {
    //     if ((event is Connected) || event is Reconnected) {
    _socket.send(json.encode(map));
    print(map.toString());

    notifyListeners();
    //   }
    // }
    // );
    // } catch (e) {
    //   print(e.toString());
    // }

    // _socket!.send(jsonEncode(map));
  }

  /// ----------------- *********************      ACCEPT THE RIDE **************** --------------------
  Future<bool> acceptRideRequest({required orderId}) async {
    // var orderProvider = locator<OrderProvider>();
    try {
      final map = {
        'serviceType': 'Accept',
        'UserID': session.userId,
        'orderID': orderId
      };
      logMe('accept ride request socket -- > ${map.toString()}');

      try {
        _socket.connection.listen((event) {
          if (event is Connected ||event is Reconnected ) {
            _socket.send(json.encode(map));
            print(map.toString());
            updateLatLngAtStarting();
            updateLatLng(latLng: LatLng(session.currentLat, session.currentLang));

            session.setRunningOrderStatus = 1;

            notifyListeners();
          }
        });
        session.setIsOrderRunning = true;
      } catch (e) {
        print(e.toString());
      }
      // setNewChangeOrderStatus = "1";

      return true;
    } catch (e) {
      return false;
    }
  }

  /// -------------******************      REJECT THE RIDE     ************------------------------
  Future<bool> rejectRideRequest({required orderId}) async {
    try {
      final map = {
        'serviceType': 'Reject',
        'UserID': session.userId,
        'orderID': orderId
      };
      logMe('reject ride request socket -- > ${map.toString()}');
      _socket.send(jsonEncode(map));

      bookingList.removeWhere((element) {
        return element.id == orderId;
      });
      notifyListeners();

      return true;
    } catch (e) {
      return false;
    }
  }

  /// ----------- ****************  UPDATE ORDER RIDE STATUS ********* -------------
  Future<bool> updateOrderStatus(
      {required String status,
      required String actualTime,
      required String startTime,
      required String endTime,
      String? distance,
      required context}) async {
    print("update order status called");
    print("update order status called $status");

    // var orderProvider = Provider.of<OrderProvider>(context, listen: false);
    try {
      final map = {
        'serviceType': 'ChangeStatus',
        'orderID': session.runningOrderId,
        'Status': status,
        'actualTime': actualTime,
        'StartTime': startTime,
        'EndTime': endTime,
        'distance': distance ?? "0"
      };
      logMe('Update Status -- > ${map.toString()}');
      print('Update Status -- > ${map.toString()}');

      try {
        _socket.connection.listen((event) {
          if (event is Connected || event is Reconnected) {
            _socket.send(json.encode(map));
            dismissLoading();
            updateLatLng(latLng: LatLng(session.currentLat, session.currentLang), );
            print(map.toString());
            if (status == "1") {
              currentOrderStatus = 2;
              rideText = "Reached Pick up Location";
              setNewChangeOrderStatus = "1";
              session.setRunningOrderStatus = 1;
              dismissLoading();
              setNewPolylineDirection(false);
            }

            if (status == "2") {
              currentOrderStatus = 2;
              rideText = "Reached Pick up Location";
              setNewChangeOrderStatus = "2";
              // session.setOrderStatus = 2;
              session.setRunningOrderStatus = 2;
              dismissLoading();

              setNewPolylineDirection(false);
            } else if (status == '3') {
              currentOrderStatus = 3;
              setNewChangeOrderStatus = "3";
              // session.setOrderStatus = 3;
              session.setRunningOrderStatus = 3;
              dismissLoading();
              setNewPolylineDirection(true);

              rideText = "Start Trip";
            } else if (status == '5') {
              currentOrderStatus = 5;
              setNewChangeOrderStatus = "5";

              session.setRunningOrderStatus = 5;
              dismissLoading();

              setNewPolylineDirection(true);

              // session.setOrderStatus = 5;

              rideText = "End Trip";
            } else if (status == "7") {
              currentOrderStatus = 7;
              setNewChangeOrderStatus = "7";
              // session.setOrderStatus = 7;
              session.setRunningOrderStatus = 7;
              dismissLoading();

              setNewPolylineDirection(true);

              rideText = "Start Ride to Pick up Location";
            } else {
              log("Ride canceled by the driver");
            }

            notifyListeners();
          } else {
            connectToSocket(context);
          }
        });
      } catch (e) {
        print(e.toString());
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  set setOrderDetails(OrderDetail val) {
    _orderDetail = val;
    notifyListeners();
  }

  /// *****************-------------->>>>>>>. CALCULATE TIME AND DISTANCE WHEN TRIP END <<<<<<<--------   ****************************///////

  Future<void> calculateTimeAndDistanceWhenRideCompeleted() async {
    dismissLoading();
    session.setEndTime = DateTime.now().toString();
    DateTime startTime = DateTime.parse(session.rideStartTime);

    print("ride start time from local storage is :-->$startTime");

    Duration difference = (DateTime.now()).difference(startTime);
    print("Time differencec is -- $difference");

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    print(
        " trip end:-->> total actual distnce in seconds after trip end :-->> $seconds");

    double actualTime = double.parse(difference.inMinutes.toString());

    print("actual time in minute is :-->> $actualTime");

    print("$days day(s) $hours hour(s) $minutes minute(s) $seconds second(s).");

    print("trip end:-->>  estimated time ::==>>${session.estimatedTime}");
    print("trip end:-->> estimated distance ::==>>${session.estimatedDistance}");

    if ((double.parse(session.estimatedTime)) < actualTime) {
      logMe("Actual time is grater ");
      session.setEstimatedTime = (actualTime * 60).toString();
    } else {
      logMe("ESTIMATED time is grater ");

      session.setEstimatedTime = (double.parse(session.estimatedTime.toString()) * 60).toString();
    }
  }

  // updateText(context) {
  //   Provider.of<OrderProvider>(context, listen: false).updateText();
  // }



  /// Manage Tracking HERE


  setCurrentLocation(
      OrderDetail orderDetail, CustomerDataModel customerDataModel) async {
    polylineCoordinates.clear();
    newPolylines.clear();

    print("order details are: $orderDetail");
    print("customerDataModel details are: $customerDataModel");

    showLoading();
    try {
      _customerDetail = customerDataModel;
      _orderDetail = orderDetail;

      setOrderDetails = orderDetail;
      var serviceStatus = await Geolocator.requestPermission();

      print("permission status :==>> $serviceStatus");
      if (serviceStatus == LocationPermission.always ||
          serviceStatus == LocationPermission.whileInUse) {
        await _getCurrentLocation();

        var latLongOrigin = orderDetail.startCoordinate;
        var latLongDestination = orderDetail.endCoordinate;
        var splitOrigin = latLongOrigin.split(",");
        var splitDestination = latLongDestination.split(",");
        var latOrigin = double.parse(splitOrigin[0]);
        var lngOrigin = double.parse(splitOrigin[1]);
        var latDestination = double.parse(splitDestination[0]);
        var lngDestination = double.parse(splitDestination[1]);
        originAddress = orderDetail.startAddress;
        destinationAddress = orderDetail.endAddress;
        originLatLng = LatLng(latOrigin, lngOrigin);
        destinationLatLng = LatLng(latDestination, lngDestination);
        originText = Text(
          originAddress,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        );
        destinationText = Text(
          destinationAddress,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        );
        MarkerId markerIdOrigin = const MarkerId("origin");
        MarkerId markerIdDestination = const MarkerId("destination");
        MarkerId markerIdDriver = const MarkerId("driver");
        var coordinate =
            LatLng(currentPosition!.latitude, currentPosition!.longitude);

        final Marker markerOrigin = Marker(
          anchor: const Offset(0.5, 0.5),
          markerId: markerIdOrigin,
          position: originLatLng,
          rotation: tiltValue,
         // zIndex: zIndex,
          infoWindow: InfoWindow(title: appLoc.customerplace),
          icon: await getBytesFromAsset(pickupIcon, 70).then((value) {
            return pickUpMarker = BitmapDescriptor.fromBytes(value);
          }),
          onTap: () {},
        );
        final Marker markerDestination = Marker(
          anchor: const Offset(0.5, 0.5),
          markerId: markerIdDestination,
          position: destinationLatLng,
          rotation: tiltValue,
         // zIndex: zIndex,
          infoWindow: InfoWindow(title: appLoc.destinationplace),
          icon: await getBytesFromAsset(destinationIcon, 100).then((value) {
            return destinationMarker = BitmapDescriptor.fromBytes(value);
          }),
          onTap: () {},
        );

        print(
            "COORDNATES ARE************** ${currentPosition!.latitude}, ${currentPosition!.longitude}");

        // var coordinate =
        //     LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

        final Marker markerDriver = Marker(
          anchor: const Offset(0.5, 0.5),
          markerId: markerIdDriver,
          position: coordinate,
          icon: driverMarker,
         rotation: tiltValue,
        //  zIndex: zIndex,
          infoWindow: const InfoWindow(title: "driver"),
        );
        markers[markerIdOrigin] = markerOrigin;
        markers[markerIdDestination] = markerDestination;
        markers[markerIdDriver] = markerDriver;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: coordinate,
                zoom: zoom,
                ),
          ),
        );

        notifyListeners();
        dismissLoading();
      } else {
        try {
          var serviceStatusResult = await Geolocator.requestPermission();
          logMe("Service status activated after request: $serviceStatusResult");
          if (serviceStatusResult != LocationPermission.always ||
              serviceStatusResult != LocationPermission.whileInUse) {
            setCurrentLocation(orderDetail, customerDetail!);
            dismissLoading();
          }
        } catch (e) {
          dismissLoading();
          logMe(e.toString());
          print("exception is--------------------------->>>>>>>>>>>$e");
        }
      }
      dismissLoading();
    } on PlatformException catch (e) {
      dismissLoading();
      if (e.toString() == 'PERMISSION_DENIED') {
        logMe(e.toString());
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        logMe(e.message);
      }
    }
  }

  updateGetBytes() {
    getBytesFromAsset(carIconAsset, 120).then((value) {
      driverMarker = BitmapDescriptor.fromBytes(value);

    });
    getBytesFromAsset(pickupIcon, 100).then((value) async {
      pickUpMarker = BitmapDescriptor.fromBytes(value);
    });
    getBytesFromAsset(destinationIcon, 100).then((value) async {
      destinationMarker = BitmapDescriptor.fromBytes(value);
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  DriverLocationResponseModel? get driverLocation => _driverLocation;
  final double _driverLat = 0.0;
  final double _driverLng = 0.0;

  CustomerDataModel? get customerDetail => _customerDetail;

  // OrderDetail? get orderDetail => _orderDetail;

  double get driverLat => _driverLat;

  double? get driverLng => _driverLng;

  CustomerDataModel? _customerDetail;

  double zoom = 16;
  String destinationAddress = "Destination";
  DriverLocationResponseModel? _driverLocation;
  OrderDetail? _orderDetail;

  String originAddress = '';
  bool isFirstTracking = true;
  bool isWithDriver = false;
  late Text originText;
  late Text destinationText;
  List<LatLng> polylineCoordinates = [];
  // Set<Polyline> polylines = {};
  Set<Polyline> newPolylines = {};

  var receiptProvider = locator<ReceiptProvider>();

  late StreamSubscription<Position>? locationbackSubscription;
  List<LatLng> driverCoordinatesList = [];
  Position? currentPosition;
  double tiltValue =-28;
  double zIndex =0;
  String setEstimatedDistance ="0";

  late LatLng originLatLng, destinationLatLng;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late BitmapDescriptor driverMarker;
  late BitmapDescriptor pickUpMarker, destinationMarker;

  set setNewChangeOrderStatus(val) {
    log("change order Status called  ========>>>>> $val");
    // print("ORDER DETAILS ARE  ========>>>>> $orderDetail");
    // print(
    //     "ORDER DETAILS from SOCKET PROVIDER ========>>>>> ${socketProvider.orderDetail}");

    if (val == "1") {
      print("order accept called");
      session.setRunningOrderStatus = 1;
      // session.setOrderStatus = 1;

      showLoading();
      // _orderStatus = OrderStatus.departureToCustomerplace;
      setNewPolylineDirection(false);
    } else if (val == "2") {
      session.setRunningOrderStatus = 2;
      // session.setOrderStatus = 2;
      // _orderStatus = OrderStatus.arriveAtCustomerPlace;
      setNewPolylineDirection(false);
    } else if (val == "3") {
      session.setRunningOrderStatus = 3;
      // session.setOrderStatus = 3;
      setNewPolylineDirection(true);
      // _orderStatus = OrderStatus.departureToDestination;
    } else if (val == "5") {
      session.setRunningOrderStatus = 5;
      // session.setOrderStatus = 5;
      // _orderStatus = OrderStatus.arriveAtDestination;

      setNewPolylineDirection(true);
    } else if (val == "7") {
      session.setRunningOrderStatus = 7;
      // session.setOrderStatus = 7;
      showLoading();
      // _orderStatus = OrderStatus.complete;
    }
    notifyListeners();
  }

  setNewPolylineDirection(
    bool isFromOrigin,
  ) async {
    newPolylines.clear();

    print(
        "***************************************** IS FROM LOGIN IS--------***********************$isFromOrigin *************--------");
    print("set polylines order details  are:-->> $orderDetail");

    showLoading();
    var latLongOrigin = orderDetail!.startCoordinate;
    var latLongDestination = orderDetail!.endCoordinate;

    print(
        "origin and destiantion coordinates are: $latLongOrigin and $latLongDestination");
    // var latLongOrigin = "30.703112393336106, 76.68201047927141";
    // var latLongDestination = "30.706780957567652, 76.68569013476372";

    var splitOrigin = latLongOrigin.split(",");
    var splitDestination = latLongDestination.split(",");
    var latOrigin = double.parse(splitOrigin[0]);
    var lngOrigin = double.parse(splitOrigin[1]);
    var latDestination = double.parse(splitDestination[0]);
    var lngDestination = double.parse(splitDestination[1]);
    await _getCurrentLocation();
    var coordinate =
        LatLng(currentPosition!.latitude, currentPosition!.longitude);
    if (isFromOrigin) {
      print("------------------ GO TO DESTINATION FROM ORIGIN---------- ");
      print(
          "------------------ GO TO DESTINATION FROM ORIGIN---------- $latDestination,$lngDestination ");

      /*** GO TO DESTINATION FROM ORIGIN */
      await DirectionHelper()
          .getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude,
              latDestination, lngDestination)
          .then((result) {
        if (result.isNotEmpty) {
          polylineCoordinates = [];
          for (var point in result) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }

          Polyline polyline = Polyline(
              polylineId: const PolylineId("jalur"),
              color: Colors.black,
              points: polylineCoordinates,
              width: 5,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap);

          newPolylines.add(polyline);
          // updatePolyline(val: polyline);

          // polylines.add(polyline);
          notifyListeners();
          print("Polyline created  from origin $polylineCoordinates");
          print("Polyline created  from newPolylines origin $newPolylines");

          dismissLoading();
        }
      });
      dismissLoading();
    } else {
      /*** GO TO ORIGIN  */
      logMe("Polylinessss ORIGIN created");
      print(
          "------------------ GO TO ORIGIN FROM DRIVER---------- $latOrigin, $lngOrigin");

      await DirectionHelper().getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude, latOrigin, lngOrigin).then((result) {
        if (result.isNotEmpty) {
          polylineCoordinates = [];
          for (var point in result) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }

          Polyline polyline = Polyline(
              polylineId: const PolylineId("jalur"),
              color: Colors.black,
              points: polylineCoordinates,
              width: 5,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap);
          // polylines.add(polyline);
          // updatePolyline(val: polyline);
          newPolylines.add(polyline);

          notifyListeners();
          print("Polyline created not from origin $polylineCoordinates");
          print("Polyline created from not origin newPolylines $newPolylines");

          dismissLoading();
        }
      });
      dismissLoading();
    }
  }

  Future<void> _getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // setState(() {
    currentPosition = position;
    notifyListeners();

    print("------************* >>>>>>. CURRRENT LOCATION IS $currentPosition");
    // });
  }

  callCustomer() async {
    if (_customerDetail!.phoneNumber != '') {
      final call = Uri.parse('tel:${_customerDetail!.phoneNumber}');
      launchUrl(call);
    } else {
      showToast(message: "No Phone number");
    }
  }

  startNavigationInMap() async {
    var latLongOrigin = _orderDetail!.startCoordinate;
    var latLongDestination = _orderDetail!.endCoordinate;
    var splitOrigin = latLongOrigin.split(",");
    var splitDestination = latLongDestination.split(",");
    var latOrigin = double.parse(splitOrigin[0]);
    var lngOrigin = double.parse(splitOrigin[1]);
    var latDestination = double.parse(splitDestination[0]);
    var lngDestination = double.parse(splitDestination[1]);
    String url;
    String appleUrl;
    String googleUrl;

    if ((session.runningOrderStatus == 1) ||
        (session.runningOrderStatus == 2)) {
      url = 'google.navigation:q=$latOrigin,$lngOrigin&mode=d';
      googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$latOrigin,$lngOrigin';
      appleUrl =
          'https://maps.apple.com/?saddr=&daddr=$latOrigin,$lngOrigin&directionsmode=driving';
    } else {
      url = 'google.navigation:q=$latDestination,$lngDestination&mode=d';
      googleUrl =
          'https://www.google.com/maps/search/?api=1&query=$latDestination,$lngDestination';
      appleUrl =
          'https://maps.apple.com/?saddr=&daddr=$latDestination,$lngDestination&directionsmode=driving';
    }
    Uri appleUri = Uri.parse(appleUrl);
    Uri googleUri = Uri.parse(googleUrl);
    Uri urlUri = Uri.parse(url);

    if (Platform.isIOS) {
      if (await canLaunchUrl(appleUri)) {
        await launchUrl(appleUri, mode: LaunchMode.externalApplication);
      } else {
        if (await canLaunchUrl(googleUri)) {
          await launchUrl(googleUri, mode: LaunchMode.externalApplication);
        }
      }
    } else {
      if (await canLaunchUrl(urlUri)) {
        await launchUrl(urlUri, mode: LaunchMode.externalApplication);
      }
    }

    // if (await canLaunchUrl(Uri.parse(url))) {
    //   await launchUrl(Uri.parse(url));
    // } else {
    //   throw 'Could not launch $url';
    // }
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    try {
      var status = await getlocationPermissionStatus();
      if (status != null && status) {
        try {
          var permissionStatus = await permission.Permission.location.request();
          if (permissionStatus == permission.PermissionStatus.granted) {
            LocationSettings locationSettings = const LocationSettings();

            if (Platform.isAndroid) {
              locationSettings = AndroidSettings(
                  accuracy: LocationAccuracy.bestForNavigation,
                  distanceFilter: 10,
                  forceLocationManager: false,
                  intervalDuration: const Duration(seconds: 7),
                  foregroundNotificationConfig:
                      const ForegroundNotificationConfig(
                          notificationText: "Location is being used for navigation",
                          notificationTitle: "Gatsby Driver",
                          enableWakeLock: true,
                          setOngoing: true,
                          notificationIcon: AndroidResource(name: "@mipmap/ic_launcher")));
            } else if (Platform.isIOS) {
              locationSettings = AppleSettings(
                  accuracy: LocationAccuracy.bestForNavigation,
                  activityType: ActivityType.automotiveNavigation,
                  distanceFilter: 10,
                  timeLimit: const Duration(seconds: 10),
                  showBackgroundLocationIndicator: true,
                  allowBackgroundLocationUpdates: true);
            } else {
              locationSettings = const LocationSettings(
                accuracy: LocationAccuracy.high,
                distanceFilter: 10,
              );
            }
            locationbackSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position)async {
              if (position != null) {
                currentPosition = position;

                print(
                    "**************** POSITION :  -->> ${currentPosition!.latitude},${currentPosition!.longitude}");
                updateLatLng(
                    latLng: LatLng(
                      position.latitude,
                      position.longitude,
                    ),
                    bearing: position.heading + 155);

                await createMarker(driverLatLng: LatLng(position.latitude, position.longitude));
                if (((session.runningOrderStatus == 5) || (currentOrderStatus == 5))) {
                  driverCoordinatesList.add(LatLng(position.latitude, position.longitude));
                }
                await animateToLocation(position,googleMapController);
               /* googleMapController.animateCamera(CameraUpdate.newLatLngZoom(
                  LatLng(
                    position.latitude,
                    position.longitude,
                  ),
                  zoom,
                ));*/
                notifyListeners();
                // updateLocation(_currentPosition!);
              }

              // print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
              // SOURCE_LOCATION = LatLng(position?.latitude??0.0, position?.longitude??0.0);
              // if (markers.isNotEmpty) {
              //   updateMapData();
              // }
            });
          }
        } catch (e) {
          print(e.toString());
        }
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
  }


  Future<void> animateToLocation(Position position, GoogleMapController controller)async {
    double zoomLevel = zoom;
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      bearing:position.heading,
      zoom: zoomLevel,
    );
   await controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<bool?> getlocationPermissionStatus() async {
    try {
      var permissionStatus = await permission.Permission.location.request();
      if (permissionStatus == permission.PermissionStatus.granted) {
        return true;
      } else if (permissionStatus == permission.PermissionStatus.denied) {
        return false;
      } else if (permissionStatus ==
          permission.PermissionStatus.permanentlyDenied) {
        //  errorredSnackBar("App location permission is denied forever, Please enable it first");
        return false;
      } else {
        //  errorredSnackBar("Location permission is need to run this app");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> createMarker({required LatLng driverLatLng}) async {
    var latLongOrigin = _orderDetail!.startCoordinate;
    var latLongDestination = _orderDetail!.endCoordinate;
    var splitOrigin = latLongOrigin.split(",");
    var splitDestination = latLongDestination.split(",");
    var latOrigin = double.parse(splitOrigin[0]);
    var lngOrigin = double.parse(splitOrigin[1]);
    var latDestination = double.parse(splitDestination[0]);
    var lngDestination = double.parse(splitDestination[1]);
    var coordinate = LatLng(driverLatLng.latitude, driverLatLng.longitude);
    if ((currentOrderStatus == 1) || (currentOrderStatus == 2)) {
      await DirectionHelper().getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude, latOrigin, lngOrigin).then((result) async {
        if (result.isNotEmpty) {
          polylineCoordinates = [];
          for (var point in result) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
          MarkerId markerIdDriver = const MarkerId("driver");

          final Marker markerDriver = Marker(
            anchor: const Offset(0.5, 0.5),
            markerId: markerIdDriver,
            position: coordinate,
            icon: driverMarker,
            zIndex: zIndex,
            rotation: currentPosition!.heading+tiltValue,
            infoWindow: InfoWindow(
                title:
                    "Driver location: ${coordinate.latitude},${coordinate.longitude}"),
          );

          markers[markerIdDriver] = markerDriver;

          Polyline polyline = Polyline(
              polylineId: const PolylineId("jalur"),
              color: Colors.black,
              points: polylineCoordinates,
              width: 5,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap);
          newPolylines.add(polyline);
          notifyListeners();

        } else {
          logMe("Polylinessss destinationnnn");
          await DirectionHelper()
              .getRouteBetweenCoordinates(coordinate.latitude,
                  coordinate.longitude, latDestination, lngDestination)
              .then(
            (result) {
              if (result.isNotEmpty) {
                polylineCoordinates = [];
                for (var point in result) {
                  polylineCoordinates
                      .add(LatLng(point.latitude, point.longitude));
                }
                MarkerId markerIdDriver = const MarkerId("driver");

                final Marker markerDriver = Marker(
                  anchor: const Offset(0.5, 0.5),
                  markerId: markerIdDriver,
                  position: coordinate,
                  icon: driverMarker,
                //  zIndex: zIndex,
                 rotation: tiltValue,
                );

                markers[markerIdDriver] = markerDriver;

                Polyline polyline = Polyline(
                  polylineId: const PolylineId("jalur"),
                  color: Colors.lightBlue,
                  points: polylineCoordinates,
                  width: 5,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                );
                newPolylines.add(polyline);
                googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: coordinate,
                        zoom: zoom,
                        tilt: zoom,),
                  ),
                );
                notifyListeners();
              }
            },
          );
        }
      });
    } else {
      await DirectionHelper()
          .getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude,
              latDestination, lngDestination)
          .then((result) async {
        if (result.isNotEmpty) {
          polylineCoordinates = [];
          for (var point in result) {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          }
          MarkerId markerIdDriver = const MarkerId("driver");

          final Marker markerDriver = Marker(
            anchor: const Offset(0.5, 0.5),
            markerId: markerIdDriver,
            position: coordinate,
            icon: driverMarker,
         //   zIndex: zIndex,
           rotation:  tiltValue,
            infoWindow: InfoWindow(
                title:
                    "Driver location: ${coordinate.latitude},${coordinate.longitude}"),
          );

          markers[markerIdDriver] = markerDriver;

          Polyline polyline = Polyline(
              polylineId: const PolylineId("jalur"),
              color: Colors.black,
              points: polylineCoordinates,
              width: 5,
              startCap: Cap.roundCap,
              endCap: Cap.roundCap);
          newPolylines.add(polyline);
          // googleMapController.animateCamera(
          //   CameraUpdate.newCameraPosition(
          //     CameraPosition(
          //       target: coordinate,
          //       zoom: zoom,
          //     ),
          //   ),
          // );
          notifyListeners();
          // }
          // },
          // );
        } else {
          logMe("Polylinessss destinationnnn");
          await DirectionHelper().getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude, latDestination, lngDestination).then(
            (result) {
              if (result.isNotEmpty) {
                polylineCoordinates = [];
                for (var point in result) {
                  polylineCoordinates
                      .add(LatLng(point.latitude, point.longitude));
                }
                MarkerId markerIdDriver = const MarkerId("driver");

                final Marker markerDriver = Marker(
                  anchor: const Offset(0.5, 0.5),
                  markerId: markerIdDriver,
                  position: coordinate,
                  icon: driverMarker,
                //  zIndex: zIndex,
                  rotation:  tiltValue,
                );

                markers[markerIdDriver] = markerDriver;

                Polyline polyline = Polyline(
                  polylineId: const PolylineId("jalur"),
                  color: Colors.lightBlue,
                  points: polylineCoordinates,
                  width: 5,
                  startCap: Cap.roundCap,
                  endCap: Cap.roundCap,
                );
                newPolylines.add(polyline);
                googleMapController.animateCamera(
                  CameraUpdate.newCameraPosition(CameraPosition(
                      target: coordinate,
                      zoom: zoom,
                      tilt: zoom,
                  )),
                );
                notifyListeners();
              }
            },
          );
        }
      });
    }
  }

/*// // ------------- Get distance between 2 lat long points
  Future<int> setActualDistance(
      {destinationLat, destinationLong, originLat, originLong}) async {
    var response = await Dio().get(
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destinationLat,$destinationLong&origins=$originLat,$originLong&key=AIzaSyAEcqthk6N17_4Q3pyqDrKAQPpiYURZxJs');
    log(" response of real distance:--->>> ${response.data}");

    var data = GoogleRouteDistanceResponseModal.fromJson(response.data);

    int calculatedDistance = (data.rows[0].elements[0].distance.value);

    notifyListeners();
    log("session distnace:--$calculatedDistance");

    return calculatedDistance;
  }*/


  // // ------------- Get distance between 2 lat long points
  double setActualDistance({destinationLat, destinationLong, originLat, originLong})  {
    double calculatedDistance = Geolocator.distanceBetween(originLat, originLong, destinationLat, destinationLong);
    return calculatedDistance;
  }
//   //calculate distance covered

  // Future<void> calculateDistanceCovered() async {
  //   List<int> differences = [];
  //
  //   log("_lat long list are:-->> $driverCoordinatesList");
  //
  //   for (int i = 1; i < driverCoordinatesList.length; i++) {
  //     // int diff = myList[i] - myList[i - 1];
  //
  //     await setActualDistance(
  //             originLat: driverCoordinatesList[i].latitude,
  //             originLong: driverCoordinatesList[i].longitude,
  //             destinationLat: driverCoordinatesList[i - 1].latitude,
  //             destinationLong: driverCoordinatesList[i - 1].longitude)
  //         .then((value) {
  //       differences.add(value);
  //       print("Differences between elements: $differences");
  //     });
  //   }
  //   print("Differences between elements----: $differences");
  //
  //   int sum = differences.fold(0, (previousValue, element) => previousValue + element);
  //
  //   print("Total sum of elements: $sum");
  //
  //   if (double.parse(session.estimatedDistance) < (sum / 1000)) {
  //     session.setEstimatedDistance = (sum / 1000).toString();
  //   } else {
  //     log("estimated time is greater than actual time");
  //     print("estimated time is greater than actual time");
  //   }
  //   print("/********** Calculation Exited *************/");
  // }


  Future<void> calculateDistanceCovered2() async {
    List<double> differences = [];

    // Log the list of coordinates
    log("Driver coordinates list: $driverCoordinatesList");

    try {
      // Iterate over the list of coordinates
      for (int i = 1; i < driverCoordinatesList.length; i++) {
        // Calculate distance asynchronously
        double difference = setActualDistance(
            originLat: driverCoordinatesList[i].latitude,
            originLong: driverCoordinatesList[i].longitude,
            destinationLat: driverCoordinatesList[i - 1].latitude,
            destinationLong: driverCoordinatesList[i - 1].longitude
        );

        // Add the difference to the list
        differences.add(difference);

        // Print intermediate differences
        print("Difference between elements: $difference");
      }

      // Calculate the total distance covered
      double totalDistance = differences.fold(0, (prev, element) => prev + element);

      // Convert total distance to kilometers
      double totalDistanceKm = totalDistance / 1000.0;

      // Compare with estimated distance and update if necessary
      if (double.parse(session.estimatedDistance) < totalDistanceKm) {
        session.setEstimatedDistance = totalDistanceKm.toString();
        setEstimatedDistance = totalDistanceKm.toString();
        setEstimatedDistance = session.estimatedDistance;
        print("setEstimatedDistance===>>> $setEstimatedDistance");
      } else {
        setEstimatedDistance = session.estimatedDistance;
        print("Estimated distance is greater than actual distance");
        print("setEstimatedDistance===>>> $setEstimatedDistance");
      }
      notifyListeners();
    } catch (e) {
      log("Error calculating distance: $e");
      print("Error calculating distance: $e");
    }

    print("/********** Calculation Exited *************/");
  }

  clearState() {
    polylineCoordinates.clear();
    newPolylines.clear();
  }

  // trackDriverRouteDistance() {
  //   log("track driver route distance called ");

  //   // Timer.periodic(const Duration(seconds: 10), (timer) {
  //   // setState(() {

  //   // locationService.changeSettings(
  //   //     accuracy: LocationAccuracy.high, distanceFilter: 10);

  //   // locationService.onLocationChanged
  //   //     .distinct()
  //   //     .listen((LocationData currentLocation) {
  //   //   log("my current location is : ${currentLocation.latitude},${currentLocation.longitude}");

  //   driverCoordinatesList
  //       .add(LatLng(currentLocation.latitude!, currentLocation.longitude!));
  //   // });
  //   // });
  //   // });
  // }

  /// Get CUSTOMER DETAILS

  // Future<NewCustomerResponseDataModel> getCustomerDetails(
  //     {required int id}) async {
  //   var response = await dio.post(
  //       'https://php.parastechnologies.in/taxi/public/api/webservice/driver/customer',
  //       data: {'user_id': id, 'type': '2'});

  //   if (response.statusCode == 200) {
  //     print(response.data.toString());
  //     log("new customer data is :-->>${response.data}");

  //     NewCustomerResponseDataModel data=NewCustomerResponseDataModel.fromJson(response.data);

  //     // updateCustomerLocal(img: data.data.customerDetail.image, rating: data.data.customerDetail., phn: phn, name: name)
  //   }
  // }
}
