import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:appkey_taxiapp_driver/core/data/models/customer_detail_model.dart';
import 'package:appkey_taxiapp_driver/core/data/models/google_route_response_modal.dart';
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
import '../../data/models/socket_response_model/accept_by_other_driver_model.dart';
import '../../network/socket_helper.dart';
import '../../static/assets.dart';
import '../../utility/app_settings.dart';
import '../../utility/direction_helper.dart';
import 'package:permission_handler/permission_handler.dart' as permission;

import '../../utility/push_notification_helper.dart';

class LatestSocketProvider extends ChangeNotifier {
  final session = locator<Session>();
  var unreadCount = '0';
  final chatController = TextEditingController();
  List<ChatModel> _chatMessagesList = [];
  late StreamSubscription<Position>? locationbackSubscription;
  int currentOrderStatus = 0;
  String rideText = "Start Ride to Pickup Location";
  late GoogleMapController googleMapController;
  LatLng currentLatLng = const LatLng(0.0, 0.0);
  bool isWithIn1Km =false;
  final dio = Dio();

  ///orderDetail
  OrderDetail? orderDetail;

  ///receiptData
  ReceiptData? receiptData;

  Future<void> updateReceiptData({data}) async {
    receiptData = data;
    notifyListeners();
  }

  Future<void> updateZoom(CameraPosition val) async {
    zoom = val.zoom;
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
    log("******* UPDATE CUSTOMER AND RIDE DETALS CALLED");
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
    log("************* customer data model is and UPDATE CUSTOMER DATA CALLED ---->>>>  $data <<<<<<<<<--------------");
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
    log("********** ------>>>>>>> REMOVE ORDER FROM LIST CALLED <<<<<<<<<<------ ***********");
    bookingList.removeWhere((element) {
      return element.id.toString() == orderId.toString();
    });

    notifyListeners();
  }

  //
  late WebSocket _socket;
  bool isSocketConnected = false;

  late WebSocketHelper _socketHelper;

  void onInit() {
    _socketHelper = WebSocketHelper();
    if (!_socketHelper.isConnected) {
      _socketHelper.connect();
    }
    _socket = _socketHelper.getSocket();
    _connectToSocket();
    _listenSocketRequests();
  }

  // -----> function to connect the socket <--------- //
  Future<dynamic> _connectToSocket() async {
    _socket.connection.listen((event) {
      if (event is Connected) {
        isSocketConnected = true;
        log("************ Socket State: Connect ***********");
        updateLatLngAtStarting();
      } else if (event is Disconnected) {
        isSocketConnected = false;
        log("************ Socket State: DisConnect ***********");
      } else if (event is Reconnected) {
        isSocketConnected = true;
        log("************ Socket State: Reconnected ***********");
      } else {
        isSocketConnected = false;
        log("************ Socket State: $event***********");
      }
    });
  }

  void joinExitRoom({int? receiverId, required String type}) {
    try {
      if (!_socketHelper.isConnected) {
        _socketHelper.connect();
      }
      markMessageAsRead(receiverId: receiverId);
      log("join socket called $type");
      log("join socket called $type");

      if (type == 'Join') {
        isLoading = true;
        notifyListeners();
      } else if (type == 'unJoin') {
        getTotalUnreadCount(receiverId);
        // clearChatList();
      }
      final map = {
        'type': 'Driver',
        'serviceType': type,
        'UserID': session.userId,
        'roomID': (int.parse(session.userId) > receiverId!)
            ? '$receiverId-${session.userId}'
            : '${session.userId}-$receiverId',
      };
      logMe('Join Exit room socket -- > ${map.toString()}');
      _socket.send(
        jsonEncode(map),
      );
    } catch (e) {
      print("Error========>>>>>>>>.: $e");
    }
  }

  void updateRideList(Booking data) {
    bookingList.insert(0, data);
    bookingList = bookingList.toSet().toList();
    final Set<String> seenIds = {};
    final uniqueBookings = bookingList
        .where((booking) => seenIds.add(booking.id.toString()))
        .toList();
    bookingList.clear();
    bookingList.addAll(uniqueBookings);
    notifyListeners();
  }

  // Save UserData to SharedPreferences
  void _saveOrderReceipt() {
    session.setIsPaymentDone = false;
    session.setIsRatingGiven = false;
    logMe("save order receipt called");

    if (receiptData != null) {
      logMe("save order receipt called receiptResponseModel ==== NOT NULL");
      session.setOrderReceipt = json.encode(receiptData!);
      // _prefs.setString(_userDataKey, jsonEncode(_userData!.toMap()));
    }
  }

  void _listenSocketRequests() {
    _socket.messages.listen((event)async {
      var response = jsonDecode(event);
      log("socket listen :-->> $response");
      if (response['type'] == "CustomerBookRequest") {
        bookingDataModel = BookingDataModel.fromJson(response);
        bool checkId =
            checkRideWithSameId(orderId: bookingDataModel!.data.id.toString());
        logMe("check id is -> $checkId");
        if (!checkId) {
          bookingList.insert(0, bookingDataModel!.data);
          bookingList.toSet().toList();
          final Set<String> seenIds = {};
          final uniqueBookings = bookingList
              .where((booking) => seenIds.add(booking.id.toString()))
              .toList();
          bookingList.clear();
          bookingList.addAll(uniqueBookings);
        }
        notifyListeners();
      }

      // <------------------ Cancel BY Customer --------->>>>>
      else if (response['type'] == 'CancelByUser') {
        cancelByUserModel = CancelByUserModel.fromJson(response);
        bookingList.removeWhere((element) {
          return element.id.toString() == cancelByUserModel!.orderId.toString();
        });
        notifyListeners();
        await PushNotificationService().clearAllNotifications();
      }

      // <------------------ Accept BY OTHER DRIVER --------->>>>>
      else if (response['type'] == 'AcceptByOther') {
        log("*****----->>> RIDE ACCEPTED BY OTHER -----<<<<<");
        acceptByOtherDriverModel = AcceptByOtherDriverModel.fromJson(response);
        log("Ride details are:-->> $acceptByOtherDriverModel");
        log("Ride details are:-->> $acceptByOtherDriverModel");
        log("Ride details are data:-->> $response");

        if (acceptByOtherDriverModel!.driverId != session.userId) {
          bookingList.removeWhere((element) {
            return element.id == acceptByOtherDriverModel!.data;
          });

          // CustomerDetailModel(data: CustomerDataModel(name: acceptByOtherDriverModel.data., phoneNumber: phoneNumber, photo: photo, id: id, rating: rating) )
          notifyListeners();
        } else if (acceptByOtherDriverModel!.driverId == session.userId) {
          log("driver is mine ");
          log("driver is mine ");
        }
        await PushNotificationService().clearAllNotifications();
      }

      // <------------------ RIDE END OR COMPLETED --------->>>>>
      else if (response['type'] == 'endTrip') {
        updateReceiptData(data: ReceiptData.fromJson(response["data"]));
        _saveOrderReceipt();
        notifyListeners();
        log("my receipt data is:-->> $receiptData");
      }

      // <----------- Checking When request come ---------> //
      else if (response['type'] == 'MessageList') {
        log("messgae type is MESSAGE LIST");
        log('Message list data-----> ${response['data']}');
        isLoading = false;
        notifyListeners();
        if (response['data'] != null) {
          _addChatAll(
            List<ChatModel>.from(
              response["data"].map(
                (x) => ChatModel.fromMap(x),
              ),
            ),
          );
          // dismissLoading();
          log("chat data is :-->>${chatMessageList.length}");
        } else {
          _addChatAll([]);
          // dismissLoading();
        }
      } else if (response['type'] == 'Chat') {
        addSingleChat(
          ChatModel.fromMap(
            response['data'],
          ),
        );

        log("chat data is :-->>${chatMessageList.length}");
      } else if (response['type'] == 'UnreadCount') {
        log("unread message count called");
        updateUnReadMessages(count: response['data']);
      }
    });
  }

  void _addChatAll(List<ChatModel> list) {
    _chatMessagesList = list;
    notifyListeners();
  }

  void addSingleChat(ChatModel chat) {
    log("my single chat data is:-->> $chat");
    _chatMessagesList.insert(0, chat);
    notifyListeners();
  }

  void updateUnReadMessages({required int count}) {
    unreadMessageCount = count;
    log("un read message count is:-->> $unreadMessageCount");
    notifyListeners();
  }

  void sendChatMessage({
    String? message,
    int? receiverId,
    String? messageType = 'Text',
  })async {
    try {
      await _ensureSocketConnection();
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
      log('Message send ---> ${map.toString()}');

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
    } catch (e) {
      print("Error========>>>>>>>>.: $e");
    }
  }

  //   //Get total number of unread message
  void getTotalUnreadCount(int? receiverId)async {
    log("=====================get total count================");
    try {
      await _ensureSocketConnection();
      final map = {
        "userID": session.userId,
        "serviceType": "UnreadCount",
        "room": (int.parse(session.userId) > receiverId!)
            ? '$receiverId-${session.userId}'
            : '${session.userId}-$receiverId',
        "UserType": 'driver'
      };
      log("get total count:$map");
      _socket.send(jsonEncode(map));
      log("customer id is: ${session.customerId} ");
    } catch (e) {
      print("Error========>>>>>>>>.: $e");
    }
  }

  void markMessageAsRead({
    int? receiverId,
  }) async{
    try {
      await _ensureSocketConnection();
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
    } catch (e) {
      print("Error========>>>>>>>>.: $e");
    }
  }

  //   //Initial
  CameraPosition kJapanCoordinate = const CameraPosition(
    target: DEFAULT_LATLNG,
    zoom: 14.4746,
  );

  void _clearChatList() {
    _chatMessagesList.clear();
    _chatMessagesList = [];
    notifyListeners();
  }

  /// ***************************------------------>>>>>>> UPDATE LAT LONG <<<<<<<<<< *****************--------->>>>>..

  void _updateLatLng({LatLng? latLng, double? bearing = 0}) async {
    await _ensureSocketConnection();
    log("=====******* UPDATE LAT LONG CALLED =======*******");
    final map = {
      'serviceType': 'UpdatedLatLong',
      'UserID': session.userId,
      'type': 'driver',
      'Latitude': latLng!.latitude,
      'Longitude': latLng.longitude,
      'OrderID': session.runningOrderId,
      'bearing': bearing
    };
    log('UPDATE DRIVER LAT LONG -- > ${map.toString()}');
    try {
      _socket.send(jsonEncode(map));
      session.setCurrentLat = latLng.latitude;
      session.setCurrentLang = latLng.longitude;
    } catch (e) {
      print("Error========>>>>>>>>.: $e");
    }
  }

  void updateLatLngAtStarting() async {
    log("update lat long at starting called");
    Position currentLatLng = await Geolocator.getCurrentPosition();
    await _ensureSocketConnection();
    log("current latlong:${currentLatLng.latitude},${currentLatLng.longitude}");
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
    log('UPADTE LATLONG -- > ${map.toString()}');
    _socket.send(json.encode(map));
    log(map.toString());
    notifyListeners();
  }

  /// ----------------- *********************      ACCEPT THE RIDE **************** --------------------
  Future<bool> acceptRideRequest({required orderId}) async {
    try {
      await _ensureSocketConnection();
      final map = {
        'serviceType': 'Accept',
        'UserID': session.userId,
        'orderID': orderId
      };
      logMe('accept ride request socket -- > ${map.toString()}');
      try {
        _socket.send(json.encode(map));
        updateLatLngAtStarting();
        _updateLatLng(latLng: LatLng(session.currentLat, session.currentLang));
        session.setRunningOrderStatus = 1;
        session.setIsOrderRunning = true;
        notifyListeners();
        await PushNotificationService().clearAllNotifications();
      } catch (e) {
        log(e.toString());
      }
      return true;
    } catch (e) {
      print("Error========>>>>>>>>.: $e");
      return false;
    }
  }

  /// -------------******************      REJECT THE RIDE     ************------------------------
  Future<bool> rejectRideRequest({required orderId}) async {
    try {
     await _ensureSocketConnection();
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
      await PushNotificationService().clearAllNotifications();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateOrderStatus({
    required String status,
    required String actualTime,
    required String startTime,
    required String endTime,
    String? distance,
    bool isWithin1km=false
  }) async {
    log("updateOrderStatus called with status: $status");
    final payload = _buildPayload(
      status: status,
      actualTime: actualTime,
      startTime: startTime,
      endTime: endTime,
      distance: distance,
      isWithin1KM: isWithin1km
    );
    log('Update Status Payload: $payload');
    try {
      await _ensureSocketConnection();
      await _updateCurrentLocation();
      if (status == "7") {
        await _handleStatus7();
      }
      await Future.delayed(const Duration(milliseconds: 300));
      _socket.send(json.encode(payload));
      dismissLoading();
      await _handleOrderStatusChange(status);
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      log("Error in updateOrderStatus: $e", error: e, stackTrace: stackTrace);
      return false;
    }
  }

// Helper method to build the payload
  Map<String, dynamic> _buildPayload({
    required String status,
    required String actualTime,
    required String startTime,
    required String endTime,
    String? distance,
    bool isWithin1KM = false,
  }) {
    // Base payload
    Map<String, dynamic> payload = {
      'serviceType': 'ChangeStatus',
      'orderID': session.runningOrderId,
      'Status': status,
      'actualTime': actualTime,
      'StartTime': startTime,
      'EndTime': endTime,
      'distance': distance ?? setEstimatedDistance,
    };
    if (status == "7") {
      payload['is_true_within_km'] = isWithin1KM ? 1 : 0;
    }
    return payload;
  }


// Ensure the socket is connected before proceeding
  Future<void> _ensureSocketConnection() async {
    if (!_socketHelper.isConnected) {
      log("Socket not connected. Attempting to connect...");
      _socketHelper.connect();
    }
  }

// Update current location using the correct LatLng
  Future<void> _updateCurrentLocation() async {
    if (currentLatLng.latitude != 0 && currentLatLng.longitude != 0) {
      _updateLatLng(latLng: LatLng(currentLatLng.latitude, currentLatLng.longitude));
    } else {
      _updateLatLng(latLng: LatLng(session.currentLat, session.currentLang));
    }
  }

// Handle specific logic for status "7"
  Future<void> _handleStatus7() async {
    locationbackSubscription?.cancel();
    await Future.delayed(const Duration(milliseconds: 300));
    log("Location updates cancelled for status 7");
  }

// Helper method to handle status changes
  Future<void> _handleOrderStatusChange(String status) async {
    switch (status) {
      case "1":
        await _setOrderState(2, "Reached Pick up Location", "1", false);
        break;
      case "2":
        await _setOrderState(2, "Reached Pick up Location", "2", false);
        break;
      case "3":
        await _setOrderState(3, "Start Trip", "3", true);
        break;

      case "5":
        await _setOrderState(5, "End Trip", "5", true);
        break;
      case "7":
        await _setOrderState(7, "Start Ride to Pick up Location", "7", false);
        break;
      default:
        log("Ride canceled by the driver");
        break;
    }
  }

  Future<void> _setOrderState(int orderStatus, String rideMessage, String changeOrderStatus, bool polylineDirection) async {
    currentOrderStatus = orderStatus;
    rideText = rideMessage;
    setNewChangeOrderStatus = changeOrderStatus;
    session.setRunningOrderStatus = orderStatus;
    dismissLoading();
    if (orderStatus != 7) {
      await setNewPolylineDirection(polylineDirection);
    }
  }

  set setOrderDetails(OrderDetail val) {
    _orderDetail = val;
    notifyListeners();
  }

  ///****************************** Get Order Status *****************************************
  Future<void> getOrderStatus(String id) async {
    if (id.isEmpty) {
      return;
    }
    try {
      // Setup Dio
      final dio = Dio();
      final headers = {'Authorization': 'Bearer ${session.sessionToken}'};
      print(session.sessionToken);
      var response = await dio.get(
        'https://api.gatsbyrideshare.com/api/webservice/driver/order/status/$id',
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 && response.data["data"] != null) {
        final bookingModel = Booking.fromJson(response.data["data"]);
        print("getOrderStatus =========>>>>>${response.data.toString()}");
        if (bookingModel.driver_id == null) {
          updateRideList(bookingModel);
        }
      } else {
        logMe(response.statusMessage);
      }
    } catch (e) {
      logMe("Error in getPushNotificationRoute: $e");
    }
  }



  /// Manage Tracking HERE

  Future<void> setCurrentLocation(OrderDetail orderDetail, CustomerDataModel customerDataModel) async {
    polylineCoordinates.clear();
    newPolylines.clear();
    log("order details are: $orderDetail");
    log("customerDataModel details are: $customerDataModel");
    showLoading();
    try {
      _customerDetail = customerDataModel;
      _orderDetail = orderDetail;

      setOrderDetails = orderDetail;
      var serviceStatus = await Geolocator.requestPermission();

      log("permission status :==>> $serviceStatus");
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
        session.setOriginLong = lngOrigin;
        session.setOriginLat = latOrigin;
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
          infoWindow: InfoWindow(title: appLoc.customerplace),
          icon: await getBytesFromAsset(pickupIcon, 25).then((value) {
            return pickUpMarker = BitmapDescriptor.bytes(value);
          }),
          onTap: () {},
        );
        final Marker markerDestination = Marker(
          anchor: const Offset(0.5, 0.5),
          markerId: markerIdDestination,
          position: destinationLatLng,
          // rotation: tiltValue,
          // zIndex: zIndex,
          infoWindow: InfoWindow(title: appLoc.destinationplace),
          icon: await getBytesFromAsset(destinationIcon, 30).then((value) {
            return destinationMarker = BitmapDescriptor.bytes(value);
          }),
          onTap: () {},
        );

        log("COORDNATES ARE************** ${currentPosition!.latitude}, ${currentPosition!.longitude}");
        final Marker markerDriver = Marker(
          anchor: const Offset(0.5, 0.5),
          markerId: markerIdDriver,
          position: coordinate,
          icon: driverMarker,
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
        // googleMapController.getZoomLevel();
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
    getBytesFromAsset(carIconAsset, 50).then((value) {
      driverMarker = BitmapDescriptor.bytes(value);
    });
    getBytesFromAsset(pickupIcon, 50).then((value) async {
      pickUpMarker = BitmapDescriptor.bytes(value);
    });
    getBytesFromAsset(destinationIcon, 50).then((value) async {
      destinationMarker = BitmapDescriptor.bytes(value);
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
  Set<Polyline> newPolylines = {};
  var receiptProvider = locator<ReceiptProvider>();

  List<LatLng> driverCoordinatesList = [];
  Position? currentPosition;
  double tiltValue = -28;
  double zIndex = 0;
  double lastLatitude = 0;
  double lastLongitude = 0;
  String setEstimatedDistance = "0.0";

  late LatLng originLatLng, destinationLatLng;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late BitmapDescriptor driverMarker;
  late BitmapDescriptor pickUpMarker, destinationMarker;

  set setNewChangeOrderStatus(val) {
    log("change order Status called  ========>>>>> $val");
    if (val == "1") {
      log("order accept called");
      session.setRunningOrderStatus = 1;
      showLoading();
      setNewPolylineDirection(false);
    } else if (val == "2") {
      session.setRunningOrderStatus = 2;
      setNewPolylineDirection(false);
    } else if (val == "3") {
      session.setRunningOrderStatus = 3;
      setNewPolylineDirection(true);
    } else if (val == "5") {
      session.setRunningOrderStatus = 5;
      setNewPolylineDirection(true);
    } else if (val == "7") {
      session.setRunningOrderStatus = 7;
      showLoading();
    }
    notifyListeners();
  }

  FutureOr<void> setNewPolylineDirection(
    bool isFromOrigin,
  ) async {
    newPolylines.clear();
    log("***************************************** IS FROM LOGIN IS--------***********************$isFromOrigin *************--------");
    log("set polylines order details  are:-->> $orderDetail");
    showLoading();
    var latLongOrigin = orderDetail!.startCoordinate;
    var latLongDestination = orderDetail!.endCoordinate;
    log("origin and destiantion coordinates are: $latLongOrigin and $latLongDestination");
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
      log("------------------ GO TO DESTINATION FROM ORIGIN---------- $latDestination,$lngDestination ");

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
          notifyListeners();
          log("Polyline created  from origin $polylineCoordinates");
          log("Polyline created  from newPolylines origin $newPolylines");
          dismissLoading();
        }
      });
      dismissLoading();
    } else {
      /*** GO TO ORIGIN  */
      logMe("Polylinessss ORIGIN created");
      log("------------------ GO TO ORIGIN FROM DRIVER---------- $latOrigin, $lngOrigin");
      await DirectionHelper()
          .getRouteBetweenCoordinates(
              coordinate.latitude, coordinate.longitude, latOrigin, lngOrigin)
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
          notifyListeners();
          log("Polyline created not from origin $polylineCoordinates");
          dismissLoading();
        }
      });
      dismissLoading();
    }
  }

  Future<void> _getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    currentLatLng = LatLng(position.latitude, position.longitude);
    notifyListeners();
    log("------************* >>>>>>. CURRRENT LOCATION IS $currentPosition");
  }

  Future<void> callCustomer() async {
    if (_customerDetail!.phoneNumber != '') {
      final call = Uri.parse('tel:${_customerDetail!.phoneNumber}');
      launchUrl(call);
    } else {
      showToast(message: "No Phone number");
    }
  }

  Future<void> startNavigationInMap() async {
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
      googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latOrigin,$lngOrigin';
      appleUrl = 'https://maps.apple.com/?saddr=&daddr=$latOrigin,$lngOrigin&directionsmode=driving';
    } else {
      url = 'google.navigation:q=$latDestination,$lngDestination&mode=d';
      googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latDestination,$lngDestination';
      appleUrl = 'https://maps.apple.com/?saddr=&daddr=$latDestination,$lngDestination&directionsmode=driving';
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
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    try {
      var status = await getLocationPermissionStatus();
      if (status != null && status) {
        var permissionStatus = await permission.Permission.location.request();
        if (permissionStatus == permission.PermissionStatus.granted) {
          // Get platform-specific location settings
          LocationSettings locationSettings = _getPlatformLocationSettings();
          DateTime? lastUpdate;
          DateTime? lastUpdatePolyLine;
          Duration throttleDuration = const Duration(seconds: 2);
          Duration throttleDurationPolyLine = const Duration(seconds: 5);
          // Listen to location updates
          locationbackSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position? position) async {
              if (position != null && _shouldUpdateLocation(lastUpdate, throttleDuration)) {
                currentLatLng = LatLng(position.latitude, position.longitude);
                await _handleLocationUpdate(position, throttleDurationPolyLine, lastUpdatePolyLine);
                lastUpdate = DateTime.now();
              }
            },
            onError: (e) => log('Error receiving position updates: $e'),
          );
        } else {
          log("Location permission denied");
        }
      } else {
        log("Location services are not enabled");
      }
    } catch (e) {
      log("Error in getCurrentLocation: $e");
    }
  }

  LocationSettings _getPlatformLocationSettings() {
    if (Platform.isAndroid) {
      return AndroidSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 20,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationText: "Location is being used for navigation",
          notificationTitle: "Gatsby Driver",
          enableWakeLock: true,
          setOngoing: true,
          notificationIcon: AndroidResource(name: "@mipmap/launcher_icon"),
        ),
      );
    } else {
      return AppleSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 20,
      );
    }
  }

  bool _shouldUpdateLocation(DateTime? lastUpdate, Duration throttleDuration) {
    return lastUpdate == null ||
        DateTime.now().difference(lastUpdate) > throttleDuration;
  }

  bool _isDistanceMoreThan1Meter(LatLng start, LatLng end) {
    log("=====******* Distance Between =======>>>>>>>>>${Geolocator.distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude)}");
    log("=====******* start =======>>>>>>>>>${start.latitude}, ${start.longitude}");
    log("=====******* end =======>>>>>>>>>${end.latitude}, ${end.longitude}");
    return Geolocator.distanceBetween(
            start.latitude, start.longitude, end.latitude, end.longitude) >
        1;
  }

  Future<void> _handleLocationUpdate(
    Position position,
    Duration throttleDurationPolyLine,
    DateTime? lastUpdatePolyLine,
  ) async {
    final start = LatLng(lastLatitude, lastLongitude);
    final end = LatLng(position.latitude, position.longitude);
    log("New position: ${position.latitude}, ${position.longitude}",
        name: "LOCATION UPDATED");
    if (lastUpdatePolyLine == null ||
        DateTime.now().difference(lastUpdatePolyLine) >
            throttleDurationPolyLine) {
      if ((lastLatitude == 0 && lastLongitude == 0) ||
          _isDistanceMoreThan1Meter(start, end)) {
        lastLatitude = position.latitude;
        lastLongitude = position.longitude;
        await createMarker(driverLatLng: LatLng(position.latitude, position.longitude));
      }
    }
    if ((lastLatitude == 0 && lastLongitude == 0) ||
        _isDistanceMoreThan1Meter(start, end)) {
      if (session.runningOrderStatus == 5 || currentOrderStatus == 5) {
        driverCoordinatesList
            .add(LatLng(position.latitude, position.longitude));
      } else if (session.runningOrderStatus == 7 || currentOrderStatus == 7) {
        return;
      }
      await animateToLocation(position, googleMapController).whenComplete(() {
        _updateLatLng(
          latLng: LatLng(position.latitude, position.longitude),
          bearing: position.heading,
        );
      });
    }
  }

  Future<void> animateToLocation(
      Position position, GoogleMapController controller) async {
    double zoomLevel = zoom;
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      bearing: position.heading,
      zoom: zoomLevel,
    );
    await controller.animateCamera(

      CameraUpdate.newCameraPosition(
        cameraPosition,

      ),
    );
  }

  Future<bool?> getLocationPermissionStatus() async {
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
      await DirectionHelper()
          .getRouteBetweenCoordinates(
              coordinate.latitude, coordinate.longitude, latOrigin, lngOrigin)
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
            //   rotation: currentPosition!.heading+tiltValue,
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
          await DirectionHelper().getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude, latDestination, lngDestination)
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
                  //  rotation: tiltValue,
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
                    CameraPosition(target: coordinate, zoom: zoom),
                  ),
                );
                notifyListeners();
              }
            },
          );
        }
      });
    } else {
      await DirectionHelper().getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude,
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

  //** CHECK IF RIDE WITH SAME ID IS ALREADY PRESENT IN bookinglist or Not/
  bool checkRideWithSameId({required String orderId}) {
    return bookingList.any((element) => element.id.toString() == orderId);
  }

  void resetAfterRideEnd() {
    driverCoordinatesList.clear();
    setEstimatedDistance = "0.0";
    polylineCoordinates.clear();
    newPolylines.clear();
    lastLatitude = 0;
    lastLongitude = 0;
    isWithIn1Km = false;
  }



  Future<bool>  setActualDistance({destinationLat, destinationLong, originLat, originLong,actualDestLat, actualDestLong}) async {
    try {
      var response = await Dio().get('https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destinationLat,$destinationLong&origins=$originLat,$originLong&key=AIzaSyAEcqthk6N17_4Q3pyqDrKAQPpiYURZxJs');
      log(" response of real distance:--->>> ${response.data}");
      var data = GoogleRouteDistanceResponseModal.fromJson(response.data);
      session.setEstimatedDistance = (data.rows[0].elements[0].distance.value / 1000).toString();
      setEstimatedDistance = (data.rows[0].elements[0].distance.value / 1000).toString();
      double distanceInMeters = Geolocator.distanceBetween(
        currentLatLng.latitude,
        currentLatLng.longitude,
        actualDestLat,
        actualDestLong,
      );
      log(distanceInMeters.toString(),name: "Distance From End Trip");
      log(" ${currentLatLng.latitude} ${currentLatLng.longitude}",name: "Distance From End Trip");
      return distanceInMeters<=1000;
    } catch (e,s) {
      print("$e, $s");
      return false;
    }
  }

  Future<void> calculateDistanceCovered2()async {
    try{
      if(currentLatLng.latitude==0 && currentLatLng.longitude==0){
        await _getCurrentLocation();
      }
    session.setEndTime = DateTime.now().toString();
    DateTime startTime = DateTime.parse(session.rideStartTime);
    Duration difference = DateTime.now().difference(startTime);
    double actualTimeInMinutes = difference.inMinutes.toDouble();
    session.setEstimatedTime = (actualTimeInMinutes * 60).toString(); // Store estimated time in seconds
    log("Ride Start Time: $startTime\n Actual time in minutes: $actualTimeInMinutes\n Trip end: estimated time:${session.estimatedTime},\nrip end: estimated distance: ${session.estimatedDistance}", name: "Calculate Time And Distance");
    final latLongOrigin = _orderDetail!.startCoordinate;
    final latLongDestination = _orderDetail!.endCoordinate;
    final splitOrigin = latLongOrigin.split(",");
    final splitDestination = latLongDestination.split(",");
    final latOrigin = double.parse(splitOrigin[0]);
    final lngOrigin = double.parse(splitOrigin[1]);
    final latDestination = double.parse(splitDestination[0]);
    final lngDestination = double.parse(splitDestination[1]);
    final bool isWithIn1km = await setActualDistance(destinationLong: currentLatLng.longitude,
        destinationLat: currentLatLng.latitude,
        originLong: lngOrigin ,originLat: latOrigin,actualDestLat:latDestination,actualDestLong: lngDestination);
    isWithIn1Km = isWithIn1km;
    notifyListeners();
    } catch (e, s) {
      log("Error calculating distance: $e $s");
    }
  }

  // Future<void> calculateDistanceCovered2()async {
  //   session.setEndTime = DateTime.now().toString();
  //   DateTime startTime = DateTime.parse(session.rideStartTime);
  //   Duration difference = DateTime.now().difference(startTime);
  //
  //   double actualTimeInMinutes = difference.inMinutes.toDouble();
  //   session.setEstimatedTime = (actualTimeInMinutes * 60).toString(); // Store estimated time in seconds
  //
  //   log("Ride Start Time: $startTime\n Actual time in minutes: $actualTimeInMinutes\n"
  //       "Trip end: estimated time:${session.estimatedTime},\nrip end: estimated distance: ${session.estimatedDistance}", name: "Calculate Time And Distance");
  //
  //   List<double> differences = [];
  //   log("Driver coordinates list: $driverCoordinatesList");
  //   try {
  //     for (int i = 1; i < driverCoordinatesList.length; i++) {
  //       double difference = Geolocator.distanceBetween(
  //         driverCoordinatesList[i].latitude,
  //         driverCoordinatesList[i].longitude,
  //         driverCoordinatesList[i - 1].latitude,
  //         driverCoordinatesList[i - 1].longitude,
  //       );
  //       differences.add(difference);
  //       log("Difference inSideForLoop between elements: $difference");
  //     }
  //     double totalDistance = differences.fold(0, (prev, element) => prev + element);
  //
  //     log("Total distance traveled: $totalDistance meters");
  //     if (totalDistance > 5000) {
  //       double totalDistanceKm = (totalDistance + 200) / 1000.0;
  //       session.setEstimatedDistance = totalDistanceKm.toString();
  //       setEstimatedDistance = totalDistanceKm.toString();
  //       log("setEstimatedDistance===>>> $setEstimatedDistance In Kilo Meter");
  //     } else {
  //       double totalDistanceKm = totalDistance / 1000.0;
  //       session.setEstimatedDistance = totalDistanceKm.toString();
  //       setEstimatedDistance = totalDistanceKm.toString();
  //       log("setEstimatedDistance===>>> $setEstimatedDistance In Kilo Meter");
  //     }
  //     notifyListeners();
  //   } catch (e, s) {
  //     log("Error calculating distance: $e $s");
  //   }
  //   log("/********** Calculation Exited *************/");
  // }

  clearState() {
    polylineCoordinates.clear();
    newPolylines.clear();
  }
}
