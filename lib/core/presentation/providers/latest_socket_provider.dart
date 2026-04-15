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
import 'package:socket_io_client/socket_io_client.dart' as IO;
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
  bool isWithIn1Km = false;
  final dio = Dio();

  OrderDetail? orderDetail;
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

  String customerName = '';
  String customerRating = '';
  String rideNewTotal = '';
  String customerProfilePic = '';
  String rideDistance = '';

  updateCustomerAndRideDetails({
    required String name,
    required String rating,
    required String newTotal,
    required String profilePic,
    required String distance,
  }) {
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
  }

  Future<bool> updateCustomerData({required CustomerDataModel data}) async {
    _customerDetail = data;
    notifyListeners();
    return true;
  }

  updateOrderData({required OrderDetail data}) {
    orderDetail = data;
    notifyListeners();
  }

  removeOrderFromList({required orderId}) {
    bookingList.removeWhere((element) {
      return element.id.toString() == orderId.toString();
    });
    notifyListeners();
  }

  IO.Socket? _socket;
  bool isSocketConnected = false;
  late WebSocketHelper _socketHelper;

  bool _listenersAttached = false;

  void onInit() {
    _socketHelper = WebSocketHelper();
    log("SOCKET INIT => userId: ${session.userId}");

    // Connect/Reconnect callbacks set karo
    _socketHelper.onConnectCallback = () {
      isSocketConnected = true;
      log("************ Socket State: Connect ***********");
      _registerDriverOnServer();
      updateLatLngAtStarting();
    };
    _socketHelper.onReconnectCallback = () {
      isSocketConnected = true;
      log("************ Socket State: Reconnected ***********");
      _registerDriverOnServer();
      updateLatLngAtStarting();
    };

    _socketHelper.connect();
    _socket = _socketHelper.getSocket();

    _socket?.onDisconnect((_) {
      isSocketConnected = false;
      log("************ Socket State: DisConnect ***********");
    });
    _socket?.onAny((event, data) {
      log("📥 SOCKET INCOMING => event: '$event'  data: $data");
    });

    if (!_listenersAttached) {
      _listenSocketRequests();
      _listenersAttached = true;
    }
  }


  void _emitMessage(Map map) {
    final serviceType = map['serviceType'] ?? map['type'] ?? 'unknown';
    log("📤 SOCKET OUTGOING => serviceType: '$serviceType'  payload: $map");
    _socket?.emit('message', map);
  }

  void _registerDriverOnServer() {
    try {
      final double lat = session.currentLat != 0.0 ? session.currentLat : 0.0;
      final double lng = session.currentLang != 0.0 ? session.currentLang : 0.0;

      // join_driver emit — server driver ko identify kare
      final joinMap = {
        'driver_id': session.userId,
        'latitude': lat,
        'longitude': lng,
      };
      log('🚗 join_driver emit => $joinMap');
      _socket?.emit('join_driver', joinMap);

      // UpdatedLatLong bhi bhejo
      final map = {
        'serviceType': 'UpdatedLatLong',
        'UserID': session.userId,
        'type': 'driver',
        'Latitude': lat,
        'Longitude': lng,
        'OrderID': session.runningOrderId ?? '',
      };
      log('🔌 REGISTERING DRIVER ON SERVER => ${map.toString()}');
      _emitMessage(map);
    } catch (e) {
      log("_registerDriverOnServer error: $e");
    }
  }

  void joinExitRoom({int? receiverId, required String type}) {
    try {
      if (!_socketHelper.isConnected) {
        _socketHelper.connect();
      }
      markMessageAsRead(receiverId: receiverId);
      if (type == 'Join') {
        isLoading = true;
        notifyListeners();
      } else if (type == 'unJoin') {
        getTotalUnreadCount(receiverId);
      }
      final map = {
        'type': 'Driver',
        'serviceType': type,
        'UserID': session.userId,
        'roomID': (int.parse(session.userId) > receiverId!)
            ? '$receiverId-${session.userId}'
            : '${session.userId}-$receiverId',
      };
      _emitMessage(map);
    } catch (e) {
      log("joinExitRoom error: $e");
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

  void _saveOrderReceipt() {
    session.setIsPaymentDone = false;
    session.setIsRatingGiven = false;
    if (receiptData != null) {
      session.setOrderReceipt = json.encode(receiptData!);
    }
  }

  void _listenSocketRequests() {
    _socket?.on('message', (event) async {
      var response = event is String ? jsonDecode(event) : event;
      log("socket listen :-->> $response");

      if (response['type'] == "CustomerBookRequest") {
        log("📦 CustomerBookRequest raw: $response");
        log("📦 data key: ${response['data']}");
        log("📦 total: ${response['total']} | new_total: ${response['new_total']} | distance: ${response['distance']}");
        log("📦 name: ${response['name']} | customerID: ${response['customerID']}");
        bookingDataModel = BookingDataModel.fromJson(response);
        log("📦 PARSED → total: ${bookingDataModel!.data.total} | newTotal: ${bookingDataModel!.data.newTotal}");
        bool checkId = checkRideWithSameId(orderId: bookingDataModel!.data.id.toString());
        if (!checkId) {
          bookingList.insert(0, bookingDataModel!.data);
          bookingList.toSet().toList();
          final Set<String> seenIds = {};
          final uniqueBookings = bookingList
              .where((booking) => seenIds.add(booking.id.toString()))
              .toList();
          bookingList.clear();
          bookingList.addAll(uniqueBookings);
          PushNotificationService().showNewRideNotification(
            title: "New Ride Request",
            body: bookingDataModel!.data.name?.isNotEmpty == true
                ? "New request from ${bookingDataModel!.data.name}"
                : "You have a new ride request",
          );
        }
        notifyListeners();
      } else if (response['type'] == 'CancelByUser') {
        cancelByUserModel = CancelByUserModel.fromJson(response);
        bookingList.removeWhere((element) {
          return element.id.toString() == cancelByUserModel!.orderId.toString();
        });
        notifyListeners();
        await PushNotificationService().clearAllNotifications();
      } else if (response['type'] == 'AcceptByOther') {
        acceptByOtherDriverModel = AcceptByOtherDriverModel.fromJson(response);
        if (acceptByOtherDriverModel!.driverId != session.userId) {
          bookingList.removeWhere((element) {
            return element.id.toString() == acceptByOtherDriverModel!.data.toString();
          });
          notifyListeners();
        }
        await PushNotificationService().clearAllNotifications();
      } else if (response['type'] == 'endTrip') {
        updateReceiptData(data: ReceiptData.fromJson(response["data"]));
        _saveOrderReceipt();
        notifyListeners();
      } else if (response['type'] == 'MessageList') {
        isLoading = false;
        notifyListeners();
        if (response['data'] != null) {
          _addChatAll(
            List<ChatModel>.from(
              response["data"].map((x) => ChatModel.fromMap(x)),
            ),
          );
        } else {
          _addChatAll([]);
        }
      } else if (response['type'] == 'Chat') {
        addSingleChat(ChatModel.fromMap(response['data']));
      } else if (response['type'] == 'UnreadCount') {
        updateUnReadMessages(count: response['data']);
      }
    });

    // newRideRequest event — server direct is event se bhi bhej sakta hai
    _socket?.on('newRideRequest', (data) {
      log("🚗 newRideRequest received: $data");
      try {
        var response = data is String ? jsonDecode(data) : data;
        bookingDataModel = BookingDataModel.fromJson(response);
        bool checkId = checkRideWithSameId(orderId: bookingDataModel!.data.id.toString());
        if (!checkId) {
          bookingList.insert(0, bookingDataModel!.data);
          final Set<String> seenIds = {};
          final uniqueBookings = bookingList
              .where((booking) => seenIds.add(booking.id.toString()))
              .toList();
          bookingList.clear();
          bookingList.addAll(uniqueBookings);
        }
        notifyListeners();
      } catch (e) {
        log("newRideRequest parse error: $e");
      }
    });
  }

  void _addChatAll(List<ChatModel> list) {
    _chatMessagesList = list;
    notifyListeners();
  }

  void addSingleChat(ChatModel chat) {
    _chatMessagesList.insert(0, chat);
    notifyListeners();
  }

  void updateUnReadMessages({required int count}) {
    unreadMessageCount = count;
    notifyListeners();
  }

  void sendChatMessage({
    String? message,
    int? receiverId,
    String? messageType = 'Text',
  }) async {
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
      _emitMessage(map);
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
      log("sendChatMessage error: $e");
    }
  }

  void getTotalUnreadCount(int? receiverId) async {
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
      _emitMessage(map);
    } catch (e) {
      log("getTotalUnreadCount error: $e");
    }
  }

  void markMessageAsRead({int? receiverId}) async {
    try {
      await _ensureSocketConnection();
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
      _emitMessage(map);
    } catch (e) {
      log("markMessageAsRead error: $e");
    }
  }

  CameraPosition kJapanCoordinate = const CameraPosition(
    target: DEFAULT_LATLNG,
    zoom: 14.4746,
  );

  void _clearChatList() {
    _chatMessagesList.clear();
    _chatMessagesList = [];
    notifyListeners();
  }

  void _updateLatLng({LatLng? latLng, double? bearing = 0}) async {
    if (latLng == null) {
      log("_updateLatLng: latLng is null, skipping emit");
      return;
    }
    if (latLng.latitude == 0.0 && latLng.longitude == 0.0) {
      log("_updateLatLng: lat/lng is 0,0 (invalid), skipping emit");
      return;
    }
    await _ensureSocketConnection();
    final map = {
      'serviceType': 'UpdatedLatLong',
      'UserID': session.userId,
      'type': 'driver',
      'Latitude': latLng.latitude,
      'Longitude': latLng.longitude,
      'OrderID': session.runningOrderId,
      'bearing': bearing
    };
    log('UPDATE DRIVER LAT LONG --> ${map.toString()}');
    try {
      _emitMessage(map);
      session.setCurrentLat = latLng.latitude;
      session.setCurrentLang = latLng.longitude;
    } catch (e) {
      log("_updateLatLng error: $e");
    }
  }

  Future<void> updateLatLngAtStarting() async {
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) {
        log("Location permission permanently denied");
        return;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        log("Location service disabled");
        return;
      }

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 5));

      await _ensureSocketConnection();
      session.setCurrentLat = pos.latitude;
      session.setCurrentLang = pos.longitude;

      final map = {
        'serviceType': 'UpdatedLatLong',
        'UserID': session.userId,
        'type': 'driver',
        'Latitude': pos.latitude,
        'Longitude': pos.longitude,
        'OrderID': ''
      };
      log('UPDATE LATLONG --> ${map.toString()}');
      _emitMessage(map);
      notifyListeners();
    } catch (e) {
      log("updateLatLngAtStarting error: $e");
    }
  }

  Future<bool> acceptRideRequest({required orderId}) async {
    try {
      await _ensureSocketConnection();
      final map = {
        'serviceType': 'Accept',
        'UserID': session.userId,
        'orderID': orderId,
      };
      try {
        _emitMessage(map);
        session.setRunningOrderStatus = 1;
        session.setIsOrderRunning = true;
        notifyListeners();
        await PushNotificationService().clearAllNotifications();
        // fire-and-forget — GPS update blocks nahi karega accept flow ko
        updateLatLngAtStarting();
      } catch (e) {
        log("acceptRideRequest inner error: $e");
      }
      return true;
    } catch (e) {
      log("acceptRideRequest error: $e");
      return false;
    }
  }


  Future<bool> rejectRideRequest({required orderId}) async {
    try {
      await _ensureSocketConnection();
      final map = {
        'serviceType': 'Reject',
        'UserID': session.userId,
        'orderID': orderId
      };
      _emitMessage(map);
      bookingList.removeWhere((element) => element.id == orderId);
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
    bool isWithin1km = false,
  }) async {
    final payload = _buildPayload(
      status: status,
      actualTime: actualTime,
      startTime: startTime,
      endTime: endTime,
      distance: distance,
      isWithin1KM: isWithin1km,
    );
    try {
      await _ensureSocketConnection();
      await _updateCurrentLocation();
      if (status == "7") {
        await _handleStatus7();
      }
      await Future.delayed(const Duration(milliseconds: 300));
      _emitMessage(payload);
      dismissLoading();
      await _handleOrderStatusChange(status);
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      log("Error in updateOrderStatus: $e", error: e, stackTrace: stackTrace);
      return false;
    }
  }

  Map<String, dynamic> _buildPayload({
    required String status,
    required String actualTime,
    required String startTime,
    required String endTime,
    String? distance,
    bool isWithin1KM = false,
  }) {
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

  Future<void> _ensureSocketConnection() async {
    if (!_socketHelper.isConnected) {
      _socketHelper.connect();
      _socket = _socketHelper.getSocket();
    }
  }

  Future<void> _updateCurrentLocation() async {
    if (currentLatLng.latitude != 0 && currentLatLng.longitude != 0) {
      _updateLatLng(latLng: LatLng(currentLatLng.latitude, currentLatLng.longitude));
    } else if (session.currentLat != 0.0 && session.currentLang != 0.0) {
      _updateLatLng(latLng: LatLng(session.currentLat, session.currentLang));
    } else {
      log("_updateCurrentLocation: no cached location, fetching fresh from GPS");
      await _getCurrentLocation();
      if (currentLatLng.latitude != 0 && currentLatLng.longitude != 0) {
        _updateLatLng(latLng: currentLatLng);
      } else {
        log("_updateCurrentLocation: GPS fetch bhi failed, emit skip");
      }
    }
  }

  Future<void> _handleStatus7() async {
    locationbackSubscription?.cancel();
    await Future.delayed(const Duration(milliseconds: 300));
  }

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
      // ✅ Fixed
      locationbackSubscription?.cancel();
      currentOrderStatus = 7;
      rideText = "Ride Completed";
      session.setRunningOrderStatus = 7;
      session.setIsOrderRunning = false;
      session.setIsPaymentDone = false;
      session.setIsRatingGiven = false;
      resetAfterRideEnd();
      dismissLoading();
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
      final ctx = locator<GlobalKey<NavigatorState>>().currentContext;
      if (ctx != null) {
        Navigator.pushNamedAndRemoveUntil(
          ctx,
          '/DriverReceiptPage', 
          (route) => false,
        );
      }
      break;
    default:
      log("Ride canceled by the driver");
      break;
  }
}

  Future<void> _setOrderState(int orderStatus, String rideMessage,
      String changeOrderStatus, bool polylineDirection) async {
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

  Future<void> getOrderStatus(String id) async {
    if (id.isEmpty) return;
    try {
      final dio = Dio();
      final headers = {'Authorization': 'Bearer ${session.sessionToken}'};
      var response = await dio.get(
        'https://api.gatsbyrideshare.com/api/webservice/driver/order/status/$id',
        options: Options(headers: headers),
      );
      if (response.statusCode == 200 && response.data["data"] != null) {
        final bookingModel = Booking.fromJson(response.data["data"]);
        if (bookingModel.driver_id == null) {
          updateRideList(bookingModel);
        }
      }
    } catch (e) {
      log("getOrderStatus error: $e");
    }
  }

  Future<void> setCurrentLocation(
      OrderDetail orderDetail, CustomerDataModel customerDataModel) async {
    polylineCoordinates.clear();
    newPolylines.clear();
    showLoading();
    try {
      _customerDetail = customerDataModel;
      _orderDetail = orderDetail;
      setOrderDetails = orderDetail;
      var serviceStatus = await Geolocator.requestPermission();
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
        originText = Text(originAddress, softWrap: false, overflow: TextOverflow.ellipsis);
        destinationText = Text(destinationAddress, softWrap: false, overflow: TextOverflow.ellipsis);
        MarkerId markerIdOrigin = const MarkerId("origin");
        MarkerId markerIdDestination = const MarkerId("destination");
        MarkerId markerIdDriver = const MarkerId("driver");
        var coordinate = LatLng(currentPosition!.latitude, currentPosition!.longitude);
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
          infoWindow: InfoWindow(title: appLoc.destinationplace),
          icon: await getBytesFromAsset(destinationIcon, 30).then((value) {
            return destinationMarker = BitmapDescriptor.bytes(value);
          }),
          onTap: () {},
        );
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
          CameraUpdate.newCameraPosition(CameraPosition(target: coordinate, zoom: zoom)),
        );
        notifyListeners();
        dismissLoading();
      }
      dismissLoading();
    } on PlatformException catch (e) {
      dismissLoading();
      log("setCurrentLocation error: ${e.toString()}");
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
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
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
    if (val == "1") {
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

  FutureOr<void> setNewPolylineDirection(bool isFromOrigin) async {
    newPolylines.clear();
    showLoading();
    // _orderDetail has actual booking coords, orderDetail is fallback
    final activeOrder = _orderDetail ?? orderDetail;
    if (activeOrder == null) { dismissLoading(); return; }
    var latLongOrigin = activeOrder.startCoordinate;
    var latLongDestination = activeOrder.endCoordinate;
    var splitOrigin = latLongOrigin.split(",");
    var splitDestination = latLongDestination.split(",");
    if (splitOrigin.length < 2 || splitDestination.length < 2) { dismissLoading(); return; }
    var latOrigin = double.tryParse(splitOrigin[0]) ?? 0.0;
    var lngOrigin = double.tryParse(splitOrigin[1]) ?? 0.0;
    var latDestination = double.tryParse(splitDestination[0]) ?? 0.0;
    var lngDestination = double.tryParse(splitDestination[1]) ?? 0.0;
    if (latOrigin == 0.0 || latDestination == 0.0) { dismissLoading(); return; }
    await _getCurrentLocation();
    var coordinate = LatLng(currentPosition!.latitude, currentPosition!.longitude);

    if (isFromOrigin) {
      await DirectionHelper()
          .getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude, latDestination, lngDestination)
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
            endCap: Cap.roundCap,
          );
          newPolylines.add(polyline);
          notifyListeners();
          dismissLoading();
        }
      });
      dismissLoading();
    } else {
      await DirectionHelper()
          .getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude, latOrigin, lngOrigin)
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
            endCap: Cap.roundCap,
          );
          newPolylines.add(polyline);
          notifyListeners();
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
    String googleUrl;
    String appleUrl;

    if (session.runningOrderStatus == 1 || session.runningOrderStatus == 2) {
      googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latOrigin,$lngOrigin';
      appleUrl = 'https://maps.apple.com/?saddr=&daddr=$latOrigin,$lngOrigin&directionsmode=driving';
    } else {
      googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latDestination,$lngDestination';
      appleUrl = 'https://maps.apple.com/?saddr=&daddr=$latDestination,$lngDestination&directionsmode=driving';
    }

    Uri appleUri = Uri.parse(appleUrl);
    Uri googleUri = Uri.parse(googleUrl);

    if (Platform.isIOS) {
      if (await canLaunchUrl(appleUri)) {
        await launchUrl(appleUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(googleUri)) {
        await launchUrl(googleUri, mode: LaunchMode.externalApplication);
      }
    } else {
      if (await canLaunchUrl(googleUri)) {
        await launchUrl(googleUri, mode: LaunchMode.externalApplication);
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
          LocationSettings locationSettings = _getPlatformLocationSettings();
          DateTime? lastUpdate;
          DateTime? lastUpdatePolyLine;
          Duration throttleDuration = const Duration(seconds: 2);
          Duration throttleDurationPolyLine = const Duration(seconds: 5);
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
        }
      }
    } catch (e) {
      log("getCurrentLocation error: $e");
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
    return lastUpdate == null || DateTime.now().difference(lastUpdate) > throttleDuration;
  }

  bool _isDistanceMoreThan1Meter(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude) > 1;
  }

  Future<void> _handleLocationUpdate(
    Position position,
    Duration throttleDurationPolyLine,
    DateTime? lastUpdatePolyLine,
  ) async {
    final start = LatLng(lastLatitude, lastLongitude);
    final end = LatLng(position.latitude, position.longitude);
    if (lastUpdatePolyLine == null || DateTime.now().difference(lastUpdatePolyLine) > throttleDurationPolyLine) {
      if ((lastLatitude == 0 && lastLongitude == 0) || _isDistanceMoreThan1Meter(start, end)) {
        lastLatitude = position.latitude;
        lastLongitude = position.longitude;
        await createMarker(driverLatLng: LatLng(position.latitude, position.longitude));
      }
    }
    if ((lastLatitude == 0 && lastLongitude == 0) || _isDistanceMoreThan1Meter(start, end)) {
      if (session.runningOrderStatus == 5 || currentOrderStatus == 5) {
        driverCoordinatesList.add(LatLng(position.latitude, position.longitude));
      } else if (session.runningOrderStatus == 7 || currentOrderStatus == 7) {
        return;
      }
      await animateToLocation(position, googleMapController).whenComplete(() {
        _updateLatLng(latLng: LatLng(position.latitude, position.longitude), bearing: position.heading);
      });
    }
  }

  Future<void> animateToLocation(Position position, GoogleMapController controller) async {
    LatLng latLng = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition = CameraPosition(target: latLng, bearing: position.heading, zoom: zoom);
    await controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<bool?> getLocationPermissionStatus() async {
    try {
      var permissionStatus = await permission.Permission.location.request();
      if (permissionStatus == permission.PermissionStatus.granted) {
        return true;
      }
      return false;
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

    if (currentOrderStatus == 1 || currentOrderStatus == 2) {
      await DirectionHelper()
          .getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude, latOrigin, lngOrigin)
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
          );
          markers[markerIdDriver] = markerDriver;
          Polyline polyline = Polyline(
            polylineId: const PolylineId("jalur"),
            color: Colors.black,
            points: polylineCoordinates,
            width: 5,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
          );
          newPolylines.add(polyline);
          notifyListeners();
        }
      });
    } else {
      await DirectionHelper()
          .getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude, latDestination, lngDestination)
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
          );
          markers[markerIdDriver] = markerDriver;
          Polyline polyline = Polyline(
            polylineId: const PolylineId("jalur"),
            color: Colors.black,
            points: polylineCoordinates,
            width: 5,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
          );
          newPolylines.add(polyline);
          notifyListeners();
        }
      });
    }
  }

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

  Future<bool> setActualDistance({
    destinationLat,
    destinationLong,
    originLat,
    originLong,
    actualDestLat,
    actualDestLong,
  }) async {
    try {
      var response = await Dio().get(
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destinationLat,$destinationLong&origins=$originLat,$originLong&key=AIzaSyAEcqthk6N17_4Q3pyqDrKAQPpiYURZxJs',
      );
      var data = GoogleRouteDistanceResponseModal.fromJson(response.data);
      session.setEstimatedDistance = (data.rows[0].elements[0].distance.value / 1000).toString();
      setEstimatedDistance = (data.rows[0].elements[0].distance.value / 1000).toString();
      double distanceInMeters = Geolocator.distanceBetween(
        currentLatLng.latitude,
        currentLatLng.longitude,
        actualDestLat,
        actualDestLong,
      );
      return distanceInMeters <= 1000;
    } catch (e, s) {
      log("setActualDistance error: $e $s");
      return false;
    }
  }

  Future<void> calculateDistanceCovered2() async {
    try {
      if (currentLatLng.latitude == 0 && currentLatLng.longitude == 0) {
        await _getCurrentLocation();
      }
      session.setEndTime = DateTime.now().toString();
      DateTime startTime = DateTime.parse(session.rideStartTime);
      Duration difference = DateTime.now().difference(startTime);
      double actualTimeInMinutes = difference.inMinutes.toDouble();
      session.setEstimatedTime = (actualTimeInMinutes * 60).toString();
      final latLongOrigin = _orderDetail!.startCoordinate;
      final latLongDestination = _orderDetail!.endCoordinate;
      final splitOrigin = latLongOrigin.split(",");
      final splitDestination = latLongDestination.split(",");
      final latOrigin = double.parse(splitOrigin[0]);
      final lngOrigin = double.parse(splitOrigin[1]);
      final latDestination = double.parse(splitDestination[0]);
      final lngDestination = double.parse(splitDestination[1]);
      final bool isWithIn1km = await setActualDistance(
        destinationLong: currentLatLng.longitude,
        destinationLat: currentLatLng.latitude,
        originLong: lngOrigin,
        originLat: latOrigin,
        actualDestLat: latDestination,
        actualDestLong: lngDestination,
      );
      isWithIn1Km = isWithIn1km;
      notifyListeners();
    } catch (e, s) {
      log("calculateDistanceCovered2 error: $e $s");
    }
  }

  clearState() {
    polylineCoordinates.clear();
    newPolylines.clear();
  }
}