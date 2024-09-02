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

class LatestSocketProvider extends ChangeNotifier {
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
  late StreamSubscription<Position>? locationbackSubscription;
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

  @override
  // ignore: must_call_super
  void dispose() {}

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

  void onInit(){
    _socketHelper = WebSocketHelper();
    if(!_socketHelper.isConnected){
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
        // listenSocketRequests();
        updateLatLngAtStarting();
      } else if (event is Disconnected) {
        isSocketConnected = false;
        log("************ Socket State: DisConnect ***********");
        // reconnectSocket(context);
      } else if (event is Reconnected) {
        isSocketConnected = true;
        log("************ Socket State: Reconnected ***********");
        // listenSocketRequests();
        // updateLatLngAtStarting();
      } else {
        isSocketConnected = false;
        log("************ Socket State: $event***********");
      }
    });
  }

  Future<void> disconnectSocket() async {
    if (isSocketConnected) {
      _socket.close(1000, "Logout successful");
    }
  }

  void joinExitRoom({int? receiverId, required String type}) {
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
    log('Join Exit room socket -- > ${map.toString()}');

    _socket.send(
      jsonEncode(map),
    );
    // listenRequests();
  }

  void updateRideList(Booking data) {
    // bookingDataModel = BookingDataModel.fromJson(data);
    bookingList.insert(0, data);
    bookingList = bookingList.toSet().toList();
    final Set<String> seenIds = {};
    final uniqueBookings = bookingList.where((booking) => seenIds.add(booking.id.toString())).toList();
    bookingList.clear();
    bookingList.addAll(uniqueBookings);
    notifyListeners();
  }

  void _listenSocketRequests() {
    _socket.messages.listen((event) {
      var response = jsonDecode(event);
      log("socket listen :-->> $response");
      if (response['type'] == "CustomerBookRequest") {
        bookingDataModel = BookingDataModel.fromJson(response);
        bool checkId = checkRideWithSameId(orderId: bookingDataModel!.data.id.toString());
        logMe("check id is -> $checkId");
        if (!checkId) {
          bookingList.insert(0, bookingDataModel!.data);
          bookingList.toSet().toList();
          final Set<String> seenIds = {};
          final uniqueBookings = bookingList.where((booking) => seenIds.add(booking.id.toString())).toList();
          bookingList.clear();
          bookingList.addAll(uniqueBookings);
        }
        notifyListeners();
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
    });
  }

  void addChatAll(List<ChatModel> list) {
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
  }

  //   //Get total number of unread message
  void getTotalUnreadCount(int? receiverId) {
    log("get total count");
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
    log("get total count:$map");

    _socket.send(jsonEncode(map));

    log("customer id is: ${session.customerId} ");
  }

  void markMessageAsRead({
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

  void clearChatList() {
    _chatMessagesList.clear();
    _chatMessagesList = [];
    notifyListeners();
  }

  /// ***************************------------------>>>>>>> UPDATE LAT LONG <<<<<<<<<< *****************--------->>>>>..

  void updateLatLng({LatLng? latLng, double? bearing = 0}) async {
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
      //  _socketHelper.reconnect();
      session.setCurrentLat = latLng.latitude;
      session.setCurrentLang = latLng.longitude;
    } catch (e) {
      log(e.toString());
    }
  }

  void updateLatLngAtStarting() async {
    log("update lat long at starting called");
    Position currentLatLng = await Geolocator.getCurrentPosition();
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
      final map = {
        'serviceType': 'Accept',
        'UserID': session.userId,
        'orderID': orderId
      };
      logMe('accept ride request socket -- > ${map.toString()}');

      try {
        _socket.connection.listen((event) {
          if (event is Connected || event is Reconnected) {
            isSocketConnected = true;
            _socket.send(json.encode(map));
            log(map.toString());
            updateLatLngAtStarting();
            updateLatLng(
                latLng: LatLng(session.currentLat, session.currentLang));
            session.setRunningOrderStatus = 1;

            notifyListeners();
          }
        });
        session.setIsOrderRunning = true;
      } catch (e) {
        log(e.toString());
      }
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
    log("update order status called");
    log("update order status called $status");
    try {
      final map = {
        'serviceType': 'ChangeStatus',
        'orderID': session.runningOrderId,
        'Status': status,
        'actualTime': actualTime,
        'StartTime': startTime,
        'EndTime': endTime,
        'distance': setEstimatedDistance
      };
      log('Update Status -- > ${map.toString()}');

      try {
        _socket.connection.listen((event) {
          if (event is Connected || event is Reconnected) {
            isSocketConnected = true;
            _socket.send(json.encode(map));
            dismissLoading();
            updateLatLng(
              latLng: LatLng(session.currentLat, session.currentLang),
            );
            log(map.toString());
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
              //setNewPolylineDirection(true);
              locationbackSubscription?.cancel();
              rideText = "Start Ride to Pick up Location";
            } else {
              log("Ride canceled by the driver");
            }

            notifyListeners();
          } else {
            disconnectSocket();
            onInit();
            // connectToSocket(context);
          }
        });
      } catch (e) {
        log(e.toString());
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
///****************************** Get Order Status *****************************************
  Future<void> getOrderStatus(String id) async {
    if(id.isEmpty){
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
        if(bookingModel.driver_id == null){
          updateRideList(bookingModel);
        }
       /* updateRideList(Booking(
          id: myData["id"].toString(),
          startCoordinate: myData["start_coordinate"].toString(),
          endCoordinate: myData["end_coordinate"].toString(),
          startAddress: myData["start_address"].toString(),
          endAddress: myData["end_address"].toString(),
          distance: myData["distance"].toString(),
          paymentMethod: myData["payment_method"].toString(),
          estimatedTime: myData["estimated_time"].toString(),
          actualTime: myData["actual_time"].toString(),
          total: myData["total"].toString(),
          pendingAmount: myData["pending_amount"].toString(),
          newTotal: myData["new_total"].toString(),
          customerId: myData["customerID"].toString(),
          name: myData["name"].toString(),
          image: myData["image"].toString(),
          longitude: myData["Longitude"].toString(),
          latitude: myData["Latitude"].toString(),
          phone: myData["phone"].toString(),
          customerRating: myData["CustomerRating"].toString(),
        ));*/
      } else {
        logMe(response.statusMessage);
      }
    } catch (e) {
      logMe("Error in getPushNotificationRoute: $e");
    }
  }







  /// *****************-------------->>>>>>>. CALCULATE TIME AND DISTANCE WHEN TRIP END <<<<<<<--------   ****************************///////

  Future<void> calculateTimeAndDistanceWhenRideCompleted() async {
    session.setEndTime = DateTime.now().toString();
    DateTime startTime = DateTime.parse(session.rideStartTime);

    log("ride start time from local storage is :-->$startTime");
    log("ride start time from local storage is :-->${session.orderDetails}");

    Duration difference = (DateTime.now()).difference(startTime);
    log("Time differencec is -- $difference");

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;
    int seconds = difference.inSeconds % 60;

    log(" trip end:-->> total actual distnce in seconds after trip end :-->> $seconds");

    double actualTime = double.parse(difference.inMinutes.toString());

    log("actual time in minute is :-->> $actualTime");

    log("$days day(s) $hours hour(s) $minutes minute(s) $seconds second(s).");

    log("trip end:-->>  estimated time ::==>>${session.estimatedTime}");
    log("trip end:-->> estimated distance ::==>>${session.estimatedDistance}");
    session.setEstimatedTime = (actualTime * 60).toString();
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
          icon: await getBytesFromAsset(pickupIcon, 70).then((value) {
            return pickUpMarker = BitmapDescriptor.fromBytes(value);
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
          icon: await getBytesFromAsset(destinationIcon, 100).then((value) {
            return destinationMarker = BitmapDescriptor.fromBytes(value);
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
    getBytesFromAsset(carIconAsset, 55).then((value) {
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

  void setNewPolylineDirection(
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
          // updatePolyline(val: polyline);

          // polylines.add(polyline);
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
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
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
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    try {
      var status = await getLocationPermissionStatus();
      if (status != null && status) {
        try {
          var permissionStatus = await permission.Permission.location.request();
          if (permissionStatus == permission.PermissionStatus.granted) {
            LocationSettings locationSettings = const LocationSettings();

            if (Platform.isAndroid) {
              locationSettings = AndroidSettings(
                  accuracy: LocationAccuracy.bestForNavigation,
                  distanceFilter: 30,
                  foregroundNotificationConfig:
                      const ForegroundNotificationConfig(
                          notificationText:
                              "Location is being used for navigation",
                          notificationTitle: "Gatsby Driver",
                          enableWakeLock: true,
                          setOngoing: true,
                          notificationIcon: AndroidResource(name: "@mipmap/launcher_icon")));
            } else {
              locationSettings = AppleSettings(
                accuracy: LocationAccuracy.bestForNavigation,
                distanceFilter: 30,
              );
            }
            DateTime? lastUpdate;
            DateTime? lastUpdatePolyLine;
            Duration throttleDuration = const Duration(seconds: 2);
            Duration throttleDurationPolyLine = const Duration(seconds: 5);
            locationbackSubscription = Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) async {
              if (position != null && (lastUpdate == null || DateTime.now().difference(lastUpdate!) > throttleDuration)) {
                currentPosition = position;
                lastUpdate = DateTime.now();
                log("****************NEW POSITION :-->> ${currentPosition!.latitude},${currentPosition!.longitude}",
                    name: "LOCATION UPDATED");
                if (lastUpdatePolyLine == null ||
                    DateTime.now().difference(lastUpdatePolyLine!) >
                        throttleDurationPolyLine) {
                  lastUpdatePolyLine = DateTime.now();
                  await createMarker(
                      driverLatLng:
                          LatLng(position.latitude, position.longitude));
                }
                if (session.runningOrderStatus == 5 ||
                    currentOrderStatus == 5) {
                  driverCoordinatesList
                      .add(LatLng(position.latitude, position.longitude));
                }
                await animateToLocation(position, googleMapController)
                    .whenComplete(
                  () {
                    updateLatLng(
                        latLng: LatLng(position.latitude, position.longitude),
                        bearing: position.heading);
                  },
                );
              }
            });
          }
        } catch (e) {
          log(e.toString());
        }
      } else {}
    } catch (e) {
      log(e.toString());
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
  }

  void calculateDistanceCovered2() {
    calculateTimeAndDistanceWhenRideCompleted();
    List<double> differences = [];
    log("Driver coordinates list: $driverCoordinatesList");
    try {
      for (int i = 1; i < driverCoordinatesList.length; i++) {
        double difference = Geolocator.distanceBetween(
          driverCoordinatesList[i].latitude,
          driverCoordinatesList[i].longitude,
          driverCoordinatesList[i - 1].latitude,
          driverCoordinatesList[i - 1].longitude,
        );
        differences.add(difference);
        log("Difference inSideForLoop between elements: $difference");
      }
      double totalDistance =
          differences.fold(0, (prev, element) => prev + element);
      log("Total distance traveled: $totalDistance meters");
      double totalDistanceKm = totalDistance / 1000.0;
      session.setEstimatedDistance = totalDistanceKm.toString();
      setEstimatedDistance = totalDistanceKm.toString();
      // setEstimatedDistance = session.estimatedDistance;
      log("setEstimatedDistance===>>> $setEstimatedDistance In Kilo Meter");
      notifyListeners();
    } catch (e, s) {
      log("Error calculating distance: $e $s");
    }
    log("/********** Calculation Exited *************/");
  }

  clearState() {
    polylineCoordinates.clear();
    newPolylines.clear();
  }
}
