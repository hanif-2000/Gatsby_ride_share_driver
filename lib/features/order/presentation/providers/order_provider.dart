// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:ui' as ui;
// import 'package:appkey_taxiapp_driver/core/data/models/customer_detail_model.dart';
// import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
// import 'package:appkey_taxiapp_driver/core/static/assets.dart';
// import 'package:appkey_taxiapp_driver/core/static/enums.dart';
// import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
// import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
// import 'package:appkey_taxiapp_driver/features/order/domain/entities/order_detail.dart';
// import 'package:appkey_taxiapp_driver/features/order/domain/usecases/get_driver_detail.dart';
// import 'package:appkey_taxiapp_driver/features/order/domain/usecases/get_driver_location.dart';
// import 'package:appkey_taxiapp_driver/features/order/domain/usecases/get_order_detail.dart';
// import 'package:appkey_taxiapp_driver/features/order/domain/usecases/get_status_order.dart';
// import 'package:appkey_taxiapp_driver/features/order/domain/usecases/update_status_order.dart';
// import 'package:appkey_taxiapp_driver/features/order/presentation/providers/get_order_detail_state.dart';
// import 'package:appkey_taxiapp_driver/features/receipt/persentation/provider/receipt_provider.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../../../core/data/models/google_route_response_modal.dart';
// import '../../../../core/domain/usecases/do_update_location.dart';
// import '../../../../core/utility/direction_helper.dart';
// import '../../../../core/utility/injection.dart';
// import '../../../../core/utility/session_helper.dart';
// import '../../data/models/driver_location_response_model.dart';
// import 'package:permission_handler/permission_handler.dart' as permission;

// class OrderProvider with ChangeNotifier {
//   //Constructor
//   final UpdateStatusOrder updateStatusOrder;
//   final GetStatusOrder getStatusOrder;
//   final GetOrderDetail getOrderDetail;
//   final GetDriverDetail getDriverDetail;
//   final GetDriverLocation getDriverLocation;
//   final DoUpdateLocation doUpdateLocation;

//   //Initial
//   CameraPosition kJapanCoordinate = const CameraPosition(
//     target: DEFAULT_LATLNG,
//     zoom: 14.4746,
//   );

//   double zoom = 15;
//   DriverLocationResponseModel? _driverLocation;
//   OrderDetail? _orderDetail;
//   CustomerDataModel? _customerDetail;

//   var socketProvider = locator<LatestSocketProvider>();
//   final double _driverLat = 0.0;
//   final double _driverLng = 0.0;

//   late GoogleMapController googleMapController;
//   late StreamSubscription<Position>? locationbackSubscription;

//   OrderStatus _orderStatus = OrderStatus.driverAccept;
//   late LatLng originLatLng, destinationLatLng;
//   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
//   late BitmapDescriptor driverMarker;
//   late BitmapDescriptor pickUpMarker, destinationMarker;
//   String originAddress = '';
//   bool isFirstTracking = true;
//   bool isWithDriver = false;
//   String destinationAddress = appLoc.destination;
//   late Text originText;
//   late Text destinationText;
//   List<LatLng> polylineCoordinates = [];
//   Set<Polyline> polylines = {};
//   final session = locator<Session>();
//   var receiptProvider = locator<ReceiptProvider>();

//   List<LatLng> driverCoordinatesList = [];
//   Position? _currentPosition;

//   set setOrderDetails(OrderDetail val) {
//     _orderDetail = val;
//     notifyListeners();
//   }

//   double totalDistanceCovered = 0.0;

//   bool isOrderStatusComplete = false;

//   String driverUpdatedLatLong = '';
//   updateDriverLatLong({val}) {
//     driverUpdatedLatLong = val;
//     notifyListeners();
//   }

//   updateIsOrderStatus({val}) {
//     isOrderStatusComplete = val;
//     notifyListeners();
//   }

//   //get
//   OrderStatus get orderStatus => _orderStatus;

//   DriverLocationResponseModel? get driverLocation => _driverLocation;

//   CustomerDataModel? get customerDetail => _customerDetail;

//   OrderDetail? get orderDetail => _orderDetail;

//   double get driverLat => _driverLat;

//   double? get driverLng => _driverLng;

//   // late StreamSubscription<LocationData> locationSubscription;
//   double _distanceCovered = 0.0;

//   Future<void> _getCurrentLocation() async {
//     var position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     // setState(() {
//     _currentPosition = position;
//     notifyListeners();

//     print("------************* >>>>>>. CURRRENT LOCATION IS $_currentPosition");
//     // });
//   }

//   _updateDistance(Position newPosition) {
//     double distance = Geolocator.distanceBetween(
//       _currentPosition!.latitude,
//       _currentPosition!.longitude,
//       newPosition.latitude,
//       newPosition.longitude,
//     );

//     // setState(() {
//     _distanceCovered += distance;
//     _currentPosition = newPosition;
//     notifyListeners();
//   }

//   set setNewChangeOrderStatus(val) {
//     log("change order Status called  ========>>>>> $val");
//     print("ORDER DETAILS ARE  ========>>>>> $orderDetail");
//     print(
//         "ORDER DETAILS from SOCKET PROVIDER ========>>>>> ${socketProvider.orderDetail}");

//     if (val == "1") {
//       showLoading();
//       // _orderStatus = OrderStatus.departureToCustomerplace;
//       setNewPolylineDirection(true);
//     } else if (val == "2") {
//       // _orderStatus = OrderStatus.arriveAtCustomerPlace;
//     } else if (val == "3") {
//       setNewPolylineDirection(false);
//       // _orderStatus = OrderStatus.departureToDestination;
//     } else if (val == "5") {
//       // _orderStatus = OrderStatus.arriveAtDestination;

//       setNewPolylineDirection(false);
//     } else if (val == "7") {
//       showLoading();
//       // _orderStatus = OrderStatus.complete;
//     }
//     notifyListeners();
//   }

//   // //setter
//   // set changeOrderStatus(val) {
//   //   log("change order Status called  ========>>>>> $val");
//   //   if (val == OrderStatus.driverAccept) {
//   //     showLoading();
//   //     _orderStatus = OrderStatus.departureToCustomerplace;
//   //     setPolylineDirection(true);
//   //   } else if (val == OrderStatus.departureToCustomerplace) {
//   //     _orderStatus = OrderStatus.arriveAtCustomerPlace;
//   //   } else if (val == OrderStatus.arriveAtCustomerPlace) {
//   //     // _orderStatus = OrderStatus.customerConfirmation;
//   //     // } else if (val == OrderStatus.customerConfirmation) {
//   //     // _orderStatus = OrderStatus.customerConfirmation;
//   //     setPolylineDirection(false);
//   //     _orderStatus = OrderStatus.departureToDestination;
//   //   } else if (val == OrderStatus.departureToDestination) {
//   //     _orderStatus = OrderStatus.arriveAtDestination;

//   //     setPolylineDirection(false);
//   //   } else if (val == OrderStatus.arriveAtDestination) {
//   //     showLoading();
//   //     _orderStatus = OrderStatus.complete;
//   //   }
//   //   notifyListeners();
//   // }

//   // updateOrderStatusAfterAppRestart({required int orderStatus}) {
//   //   log("restart order status is:  ---- $orderStatus");
//   //   if (orderStatus == 1) {
//   //     changeOrderStatus = OrderStatus.driverAccept;
//   //     // showLoading();
//   //     // _orderStatus = OrderStatus.departureToCustomerplace;
//   //     // setPolylineDirection(true);

//   //     log("current status is DEPARTURE TO CUSTOMER");
//   //     notifyListeners();
//   //   }
//   //   if (orderStatus == 2) {
//   //     // _orderStatus = OrderStatus.arriveAtCustomerPlace;

//   //     changeOrderStatus = OrderStatus.departureToCustomerplace;
//   //     notifyListeners();

//   //     log("current status is ARRIVE AT CUSTOMER PLACE");
//   //     notifyListeners();
//   //   }
//   //   if (orderStatus == 3) {
//   //     // setPolylineDirection(false);
//   //     // _orderStatus = OrderStatus.departureToDestination;
//   //     changeOrderStatus = OrderStatus.arriveAtCustomerPlace;
//   //     //

//   //     log("current status is DEPARTURE TO DESTINATION");
//   //     notifyListeners();
//   //   }
//   //   if (orderStatus == 5) {
//   //     // _orderStatus = OrderStatus.arriveAtDestination;

//   //     // setPolylineDirection(false);
//   //     changeOrderStatus = OrderStatus.departureToDestination;
//   //     notifyListeners();

//   //     log("current status is ARRIVE AT DESTINATION");
//   //   }
//   //   notifyListeners();
//   // }

//   set changeFirstTracking(val) {
//     isFirstTracking = val;
//   }

//   Future<bool?> getlocationPermissionStatus() async {
//     try {
//       var permissionStatus = await permission.Permission.location.request();
//       if (permissionStatus == permission.PermissionStatus.granted) {
//         return true;
//       } else if (permissionStatus == permission.PermissionStatus.denied) {
//         return false;
//       } else if (permissionStatus ==
//           permission.PermissionStatus.permanentlyDenied) {
//         //  errorredSnackBar("App location permission is denied forever, Please enable it first");
//         return false;
//       } else {
//         //  errorredSnackBar("Location permission is need to run this app");
//         return false;
//       }
//     } catch (e) {
//       return false;
//     }
//   }

//   Future<void> getCurrentLocation() async {
//     try {
//       var status = await getlocationPermissionStatus();
//       if (status != null && status) {
//         try {
//           var permissionStatus = await permission.Permission.location.request();
//           if (permissionStatus == permission.PermissionStatus.granted) {
//             LocationSettings locationSettings = const LocationSettings();

//             if (Platform.isAndroid) {
//               locationSettings = AndroidSettings(
//                   accuracy: LocationAccuracy.bestForNavigation,
//                   distanceFilter: 1,
//                   forceLocationManager: false,
//                   intervalDuration: const Duration(milliseconds: 500),
//                   foregroundNotificationConfig:
//                       const ForegroundNotificationConfig(
//                           notificationText: "Location is being used",
//                           notificationTitle: "MedeviOn Driver",
//                           enableWakeLock: true,
//                           notificationIcon:
//                               AndroidResource(name: "@mipmap/noti")));
//             } else if (Platform.isIOS) {
//               locationSettings = AppleSettings(
//                 accuracy: LocationAccuracy.high,
//                 activityType: ActivityType.fitness,
//                 distanceFilter: 1,
//                 pauseLocationUpdatesAutomatically: true,
//                 showBackgroundLocationIndicator: false,
//               );
//             } else {
//               locationSettings = const LocationSettings(
//                 accuracy: LocationAccuracy.high,
//                 distanceFilter: 1,
//               );
//             }
//             locationbackSubscription =
//                 Geolocator.getPositionStream(locationSettings: locationSettings)
//                     .listen((Position? position) {
//               if (position != null) {
//                 _currentPosition = position;
//                 notifyListeners();
//                 updateLocation(_currentPosition!);
//               }

//               // print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
//               // SOURCE_LOCATION = LatLng(position?.latitude??0.0, position?.longitude??0.0);
//               // if (markers.isNotEmpty) {
//               //   updateMapData();
//               // }
//             });
//           }
//         } catch (e) {}
//       } else {}
//     } catch (e) {
//       debugPrint(e.toString());
//     }
//   }

//   //constructor
//   OrderProvider({
//     required this.updateStatusOrder,
//     required this.getStatusOrder,
//     required this.getDriverDetail,
//     required this.doUpdateLocation,
//     required this.getOrderDetail,
//     required this.getDriverLocation,
//   }) {
//     getBytesFromAsset(carIconAsset, 100).then((value) {
//       driverMarker = BitmapDescriptor.fromBytes(value);
//     });
//     getBytesFromAsset(pickupIcon, 100).then((value) async {
//       pickUpMarker = BitmapDescriptor.fromBytes(value);
//     });
//     getBytesFromAsset(destinationIcon, 100).then((value) async {
//       destinationMarker = BitmapDescriptor.fromBytes(value);
//     });
//   }

//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }

//   setCurrentLocation(
//       OrderDetail orderDetail, CustomerDataModel customerDataModel) async {
//     print("order details are: $orderDetail");
//     print("customerDataModel details are: $customerDataModel");


//     showLoading();
//     try {
//       _customerDetail = customerDataModel;
//       _orderDetail = orderDetail;

//       setOrderDetails = orderDetail;
//       var serviceStatus = await Geolocator.requestPermission();

//       print("permission status :==>> $serviceStatus");
//       if (serviceStatus == LocationPermission.always ||
//           serviceStatus == LocationPermission.whileInUse) {
//         await _getCurrentLocation();

//         var latLongOrigin = orderDetail.startCoordinate;
//         var latLongDestination = orderDetail.endCoordinate;
//         var splitOrigin = latLongOrigin.split(",");
//         var splitDestination = latLongDestination.split(",");
//         var latOrigin = double.parse(splitOrigin[0]);
//         var lngOrigin = double.parse(splitOrigin[1]);
//         var latDestination = double.parse(splitDestination[0]);
//         var lngDestination = double.parse(splitDestination[1]);
//         originAddress = orderDetail.startAddress;
//         destinationAddress = orderDetail.endAddress;
//         originLatLng = LatLng(latOrigin, lngOrigin);
//         destinationLatLng = LatLng(latDestination, lngDestination);
//         originText = Text(
//           originAddress,
//           softWrap: false,
//           overflow: TextOverflow.ellipsis,
//         );
//         destinationText = Text(
//           destinationAddress,
//           softWrap: false,
//           overflow: TextOverflow.ellipsis,
//         );
//         MarkerId markerIdOrigin = const MarkerId("origin");
//         MarkerId markerIdDestination = const MarkerId("destination");
//         MarkerId markerIdDriver = const MarkerId("driver");
//         var coordinate =
//             LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

//         final Marker markerOrigin = Marker(
//           anchor: const Offset(0.5, 0.5),
//           markerId: markerIdOrigin,
//           position: originLatLng,
//           infoWindow: InfoWindow(title: appLoc.customerplace),
//           icon: await getBytesFromAsset(pickupIcon, 70).then((value) {
//             return pickUpMarker = BitmapDescriptor.fromBytes(value);
//           }),
//           onTap: () {},
//         );
//         final Marker markerDestination = Marker(
//           anchor: const Offset(0.5, 0.5),
//           markerId: markerIdDestination,
//           position: destinationLatLng,
//           infoWindow: InfoWindow(title: appLoc.destinationplace),
//           icon: await getBytesFromAsset(destinationIcon, 100).then((value) {
//             return destinationMarker = BitmapDescriptor.fromBytes(value);
//           }),
//           onTap: () {},
//         );

//         print(
//             "COORDNATES ARE************** ${_currentPosition!.latitude}, ${_currentPosition!.longitude}");

//         // var coordinate =
//         //     LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

//         final Marker markerDriver = Marker(
//           anchor: const Offset(0.5, 0.5),
//           markerId: markerIdDriver,
//           position: coordinate,
//           icon: driverMarker,
//           rotation: _currentPosition!.heading,
//           infoWindow: const InfoWindow(title: "driver"),
//         );
//         markers[markerIdOrigin] = markerOrigin;
//         markers[markerIdDestination] = markerDestination;
//         markers[markerIdDriver] = markerDriver;
//         googleMapController.animateCamera(
//           CameraUpdate.newCameraPosition(
//             CameraPosition(
//               target: coordinate,
//               zoom: 17,
//             ),
//           ),
//         );

//         notifyListeners();
//         dismissLoading();
//       } else {
//         try {
//           var serviceStatusResult = await Geolocator.requestPermission();
//           logMe("Service status activated after request: $serviceStatusResult");
//           if (serviceStatusResult != LocationPermission.always ||
//               serviceStatusResult != LocationPermission.whileInUse) {
//             setCurrentLocation(orderDetail, customerDetail!);
//             dismissLoading();
//           }
//         } catch (e) {
//           dismissLoading();
//           logMe(e.toString());
//           print("exception is--------------------------->>>>>>>>>>>$e");
//         }
//       }
//       dismissLoading();
//     } on PlatformException catch (e) {
//       dismissLoading();
//       if (e.toString() == 'PERMISSION_DENIED') {
//         logMe(e.toString());
//       } else if (e.code == 'SERVICE_STATUS_ERROR') {
//         logMe(e.message);
//       }
//     }
//   }

//   removeMarker() async {
//     MarkerId markerDriver = const MarkerId("driver");
//     MarkerId markerOrigin = const MarkerId("origin");
//     markers.remove(markerOrigin);
//     markers.remove(markerDriver);
//     isWithDriver = true;
//     polylines.clear();
//     notifyListeners();
//   }

//   //clear state
//   clearState() async {
//     await sessionClearOrder();
//     polylines.clear();
//     markers.clear();
//     _orderStatus = OrderStatus.driverAccept;
//     notifyListeners();
//   }

// // Trcking driver
//   Future<void> trackingDriver() async {
//     log(_orderStatus.name);
//     log("tracking driver function called in order provider");
//     if (_orderStatus == OrderStatus.driverAccept ||
//         _orderStatus == OrderStatus.complete) {
//       logMe("Not Listen");
//     } else {
//       logMe("Listen Not Listen");
//       await createMarker();
//       await getCurrentLocation();
//       notifyListeners();
//     }
//   }

//   // trackDriverRouteDistance() {
//   //   log("track driver route distance called ");

//   //   // Timer.periodic(const Duration(seconds: 10), (timer) {
//   //   // setState(() {

//   //   locationService.changeSettings( accuracy: LocationAccuracy.high, distanceFilter: 10);

//   //   locationService.onLocationChanged
//   //       .distinct()
//   //       .listen((LocationData currentLocation) {
//   //     log("my current location is : ${currentLocation.latitude},${currentLocation.longitude}");

//   //     driverCoordinatesList
//   //         .add(LatLng(currentLocation.latitude!, currentLocation.longitude!));
//   //     // });
//   //   });
//   //   // });
//   // }

//   //calculate distance covered

//   calculateDistanceCovered() async {
//     List<int> differences = [];

//     log("_lat long list are:-->> $driverCoordinatesList");

//     for (int i = 1; i < driverCoordinatesList.length; i++) {
//       // int diff = myList[i] - myList[i - 1];

//       await setActualDistance(
//               originLat: driverCoordinatesList[i].latitude,
//               originLong: driverCoordinatesList[i].longitude,
//               destinationLat: driverCoordinatesList[i - 1].latitude,
//               destinationLong: driverCoordinatesList[i - 1].longitude)
//           .then((value) {
//         differences.add(value);
//         print("Differences between elements: $differences");
//       });
//     }

//     print("Differences between elements----: $differences");

//     int sum = differences.fold(
//         0, (previousValue, element) => previousValue + element);

//     print("Total sum of elements: $sum");

//     if (double.parse(session.estimatedDistance) < (sum / 1000)) {
//       session.setEstimatedDistance = (sum / 1000).toString();
//     } else {
//       log("estimated time is greater than actual time");
//     }
//   }

//   /// Get difference distance between coordinates

//   // Future<List>getDistanceDifference{
//   //  List<int> differences = [];

//   //   for (int i = 1; i < driverCoordinatesList.length; i++) {
//   //     // int diff = myList[i] - myList[i - 1];

//   //     setActualDistance(
//   //             originLat: driverCoordinatesList[i].latitude,
//   //             originLong: driverCoordinatesList[i].longitude,
//   //             destinationLat: driverCoordinatesList[i - 1].latitude,
//   //             destinationLong: driverCoordinatesList[i - 1].longitude)
//   //         .then((value) {
//   //       differences.add(value);
//   //       print("Differences between elements: $differences");
//   //     });
//   //   }

//   //   return Future(;

//   // }

// // ------------- Get distance between 2 lat long points
//   Future<int> setActualDistance(
//       {destinationLat, destinationLong, originLat, originLong}) async {
//     var response = await Dio().get(
//         'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destinationLat,$destinationLong&origins=$originLat,$originLong&key=AIzaSyAEcqthk6N17_4Q3pyqDrKAQPpiYURZxJs');
//     log(" response of real distance:--->>> ${response.data}");

//     var data = GoogleRouteDistanceResponseModal.fromJson(response.data);

//     int calculatedDistance = (data.rows[0].elements[0].distance.value);

//     notifyListeners();
//     log("session distnace:--$calculatedDistance");

//     return calculatedDistance;
//   }

//   setNewPolylineDirection(
//     bool isFromOrigin,
//   ) async {
//     print(
//         "set polylines order details  are:-->> ${socketProvider.orderDetail!}");
//     // showLoading();
//     var latLongOrigin = socketProvider.orderDetail!.startCoordinate;
//     var latLongDestination = socketProvider.orderDetail!.endCoordinate;
//     var splitOrigin = latLongOrigin.split(",");
//     var splitDestination = latLongDestination.split(",");
//     var latOrigin = double.parse(splitOrigin[0]);
//     var lngOrigin = double.parse(splitOrigin[1]);
//     var latDestination = double.parse(splitDestination[0]);
//     var lngDestination = double.parse(splitDestination[1]);
//     await _getCurrentLocation();
//     var coordinate =
//         LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
//     if (!isFromOrigin) {
//       await DirectionHelper()
//           .getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude,
//               latDestination, lngDestination)
//           .then((result) {
//         if (result.isNotEmpty) {
//           polylineCoordinates = [];
//           for (var point in result) {
//             polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//           }

//           Polyline polyline = Polyline(
//               polylineId: const PolylineId("jalur"),
//               color: Colors.black,
//               points: polylineCoordinates,
//               width: 5,
//               startCap: Cap.roundCap,
//               endCap: Cap.roundCap);
//           polylines.add(polyline);
//           notifyListeners();
//           print("Polyline created $polylineCoordinates");
//           dismissLoading();
//         }
//       });
//       dismissLoading();
//     } else {
//       logMe("Polylinessss destinationnnn created");
//       await DirectionHelper()
//           .getRouteBetweenCoordinates(
//               coordinate.latitude, coordinate.longitude, latOrigin, lngOrigin)
//           .then((result) {
//         if (result.isNotEmpty) {
//           polylineCoordinates = [];
//           for (var point in result) {
//             polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//           }

//           Polyline polyline = Polyline(
//               polylineId: const PolylineId("jalur"),
//               color: Colors.black,
//               points: polylineCoordinates,
//               width: 5,
//               startCap: Cap.roundCap,
//               endCap: Cap.roundCap);
//           polylines.add(polyline);

//           notifyListeners();
//           print("Polyline created $polylineCoordinates");
//           dismissLoading();
//         }
//       });
//       dismissLoading();
//     }
//   }

//   // setPolylineDirection(
//   //   bool isFromOrigin,
//   // ) async {
//   //   print("set polylines order details  are:-->> $_orderDetail");
//   //   // showLoading();
//   //   var latLongOrigin = _orderDetail!.startCoordinate;
//   //   var latLongDestination = _orderDetail!.endCoordinate;
//   //   var splitOrigin = latLongOrigin.split(",");
//   //   var splitDestination = latLongDestination.split(",");
//   //   var latOrigin = double.parse(splitOrigin[0]);
//   //   var lngOrigin = double.parse(splitOrigin[1]);
//   //   var latDestination = double.parse(splitDestination[0]);
//   //   var lngDestination = double.parse(splitDestination[1]);

//   //   var coordinate =
//   //       LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
//   //   if (!isFromOrigin) {
//   //     await DirectionHelper()
//   //         .getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude,
//   //             latDestination, lngDestination)
//   //         .then((result) {
//   //       if (result.isNotEmpty) {
//   //         polylineCoordinates = [];
//   //         for (var point in result) {
//   //           polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//   //         }

//   //         Polyline polyline = Polyline(
//   //             polylineId: const PolylineId("jalur"),
//   //             color: Colors.black,
//   //             points: polylineCoordinates,
//   //             width: 5,
//   //             startCap: Cap.roundCap,
//   //             endCap: Cap.roundCap);
//   //         polylines.add(polyline);
//   //         notifyListeners();
//   //         dismissLoading();
//   //       }
//   //     });
//   //     dismissLoading();
//   //   } else {
//   //     logMe("Polylinessss destinationnnn created");
//   //     await DirectionHelper()
//   //         .getRouteBetweenCoordinates(
//   //             coordinate.latitude, coordinate.longitude, latOrigin, lngOrigin)
//   //         .then((result) {
//   //       if (result.isNotEmpty) {
//   //         polylineCoordinates = [];
//   //         for (var point in result) {
//   //           polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//   //         }

//   //         Polyline polyline = Polyline(
//   //             polylineId: const PolylineId("jalur"),
//   //             color: Colors.black,
//   //             points: polylineCoordinates,
//   //             width: 5,
//   //             startCap: Cap.roundCap,
//   //             endCap: Cap.roundCap);
//   //         polylines.add(polyline);
//   //         notifyListeners();
//   //         dismissLoading();
//   //       }
//   //     });
//   //     dismissLoading();
//   //   }
//   // }

//   Future<void> createMarker() async {
//     var latLongOrigin = _orderDetail!.startCoordinate;
//     var latLongDestination = _orderDetail!.endCoordinate;
//     var splitOrigin = latLongOrigin.split(",");
//     var splitDestination = latLongDestination.split(",");
//     var latOrigin = double.parse(splitOrigin[0]);
//     var lngOrigin = double.parse(splitOrigin[1]);
//     var latDestination = double.parse(splitDestination[0]);
//     var lngDestination = double.parse(splitDestination[1]);
//     var coordinate =
//         LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
//     if (_orderStatus == OrderStatus.departureToCustomerplace
//         // ||
//         //         _orderStatus == OrderStatus.arriveAtCustomerPlace
//         // ||
//         // _orderStatus == OrderStatus.customerConfirmation

//         ) {
//       logMe("Polylinessss origin");
//       await DirectionHelper()
//           .getRouteBetweenCoordinates(
//               coordinate.latitude, coordinate.longitude, latOrigin, lngOrigin)
//           .then(
//         (result) {
//           if (result.isNotEmpty) {
//             polylineCoordinates = [];
//             for (var point in result) {
//               polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//             }
//             MarkerId markerIdDriver = const MarkerId("driver");

//             final Marker markerDriver = Marker(
//               anchor: const Offset(0.5, 0.5),
//               markerId: markerIdDriver,
//               position: coordinate,
//               icon: driverMarker,
//               rotation: _currentPosition!.heading,
//               infoWindow: InfoWindow(
//                   title:
//                       "Driver location: ${coordinate.latitude},${coordinate.longitude}"),
//             );

//             markers[markerIdDriver] = markerDriver;

//             Polyline polyline = Polyline(
//                 polylineId: const PolylineId("jalur"),
//                 color: Colors.black,
//                 points: polylineCoordinates,
//                 width: 5,
//                 startCap: Cap.roundCap,
//                 endCap: Cap.roundCap);
//             polylines.add(polyline);
//             googleMapController.animateCamera(
//               CameraUpdate.newCameraPosition(
//                 CameraPosition(
//                   target: coordinate,
//                   zoom: zoom,
//                 ),
//               ),
//             );
//             notifyListeners();
//           }
//         },
//       );
//     } else {
//       logMe("Polylinessss destinationnnn");
//       await DirectionHelper()
//           .getRouteBetweenCoordinates(coordinate.latitude, coordinate.longitude,
//               latDestination, lngDestination)
//           .then(
//         (result) {
//           if (result.isNotEmpty) {
//             polylineCoordinates = [];
//             for (var point in result) {
//               polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//             }
//             MarkerId markerIdDriver = const MarkerId("driver");

//             final Marker markerDriver = Marker(
//               anchor: const Offset(0.5, 0.5),
//               markerId: markerIdDriver,
//               position: coordinate,
//               icon: driverMarker,
//               rotation: _currentPosition!.heading,
//             );

//             markers[markerIdDriver] = markerDriver;

//             Polyline polyline = Polyline(
//               polylineId: const PolylineId("jalur"),
//               color: Colors.lightBlue,
//               points: polylineCoordinates,
//               width: 5,
//               startCap: Cap.roundCap,
//               endCap: Cap.roundCap,
//             );
//             polylines.add(polyline);
//             googleMapController.animateCamera(
//               CameraUpdate.newCameraPosition(
//                 CameraPosition(
//                   target: coordinate,
//                   zoom: zoom,
//                 ),
//               ),
//             );
//             notifyListeners();
//           }
//         },
//       );
//     }
//   }

//   /// ------------------SUBMIT ORDER STATUS---------------- *
// //   Stream<UpdateStatusOrderState> submitStatusOrder(bool? isCanceled) async* {
// //     log('Current order status -----> $_orderStatus');

// //     // if (orderStatus == OrderStatus.arriveAtCustomerPlace) {
// //     //   _orderStatus = OrderStatus.departureToDestination;
// //     //   // showToast(message: appLoc.waitcustconfirmation);
// //     // }
// //     // else {
// //     showLoading();
// //     yield UpdateStatusOrderLoading();
// //     String orderStatusBody = "";
// //     if (_orderStatus == OrderStatus.driverAccept) {
// //       log("status 1");
// //       //1
// //       orderStatusBody = Order.departureToCustomerPlace.toString();

// //       log("orderStatusBody  is OrderStatus.driverAccept------>>>>>>>  $orderStatusBody");
// //       log("departure to customer place called");
// //     } else if (_orderStatus == OrderStatus.departureToCustomerplace) {
// //       log("status 2");

// //       //2
// //       orderStatusBody = Order.arriveAtCustomerPlace.toString();
// //       log("orderStatusBody  is OrderStatus.departureToCustomerplace------>>>>>>>  $orderStatusBody");

// //       log("arrive at customer place called");
// //     } else if (_orderStatus == OrderStatus.arriveAtCustomerPlace) {
// //       log("status 3");

// //       //3
// //       orderStatusBody = Order.departureToDestination.toString();
// //       log("orderStatusBody  is OrderStatus.arriveAtCustomerPlace------>>>>>>>  $orderStatusBody");

// //       log("departure to destination called");

// //       log("Ride start time is :---- ${DateTime.now()}");

// //       session.setStartTime = DateTime.now().toString();
// //       //   trackDriverRouteDistance();
// //     }
// // //     else if (_orderStatus == OrderStatus.customerConfirmation) {
// // //       log("status 4");
// // // //4
// // //       orderStatusBody = Order.departureToDestination.toString();
// //     // }
// //     else if (_orderStatus == OrderStatus.departureToDestination) {
// //       log("status 5");
// //       //5
// //       orderStatusBody = Order.arriveAtDestination.toString();
// //       log("orderStatusBody  is OrderStatus.departureToDestination------>>>>>>>  $orderStatusBody");

// //       log("arriver at destination called");
// //     } else if (_orderStatus == OrderStatus.arriveAtDestination) {
// //       //6
// //       orderStatusBody = Order.complete.toString();
// //       log("orderStatusBody  is OrderStatus.arriveAtDestination------>>>>>>>  $orderStatusBody");

// //       log("order complete called");
// //       calculateDistanceCovered();

// //       log("ride complete end time is:--->>>>${DateTime.now()}");
// //       session.setEndTime = DateTime.now().toString();
// //       DateTime startTime = DateTime.parse(session.rideStartTime);

// //       log("ride start time from local storage is :-->$startTime");

// //       Duration difference = (DateTime.now()).difference(startTime);
// //       log(difference.toString());

// //       int days = difference.inDays;
// //       int hours = difference.inHours % 24;
// //       int minutes = difference.inMinutes % 60;
// //       int seconds = difference.inSeconds % 60;

// //       log(" trip end:-->> total actual distnce in seconds after trip end :-->> ${difference.inMinutes}");

// //       double actualTime = double.parse(difference.inMinutes.toString());

// //       log("$days day(s) $hours hour(s) $minutes minute(s) $seconds second(s).");

// //       log("trip end:-->>  estimated time ::==>>${session.estimatedTime}");
// //       log("trip end:-->> estimated distance ::==>>${session.estimatedDistance}");

// //       if ((double.parse(session.estimatedTime)) < actualTime) {
// //         session.setEstimatedTime = (actualTime * 60).toString();
// //       }

// //       // receiptProvider.getReceiptAPI();

// //       // log("actual time taken by ride is::-->> $");

// //       dismissLoading();
// //     }
// //     logMe("orderStatusBody  :$orderStatus");
// //     logMe(orderStatusBody);
// //     final formData = FormData.fromMap({
// //       'id': session.runningOrderId,
// //       'status': int.parse(orderStatusBody),
// //     });
// //     logMe("Update Status Body :${formData.fields}");
// //     logMe(session.orderId);
// //     logMe(int.parse(orderStatusBody));
// //     final result = await updateStatusOrder.execute(formData);
// //     yield* result.fold((failure) async* {
// //       logMe("failure");
// //       logMe(failure);
// //       dismissLoading();
// //       yield UpdateStatusOrderFailure(failure: failure);
// //     }, (data) async* {
// //       log("=======>>>>  data  <<<<+++++++ $data ");
// //       log('updated order status -----> $_orderStatus');
// //       // if (_orderStatus == OrderStatus.customerConfirmation) {
// //       if (_orderStatus == OrderStatus.arriveAtCustomerPlace) {
// //         dismissLoading();

// //         changeOrderStatus = OrderStatus.departureToDestination;
// //       } else if (_orderStatus == OrderStatus.departureToDestination) {
// //         changeOrderStatus = OrderStatus.arriveAtDestination;
// //       } else if (_orderStatus == OrderStatus.complete) {
// //         changeOrderStatus = OrderStatus.complete;
// //       } else {
// //         log("else called");
// //         dismissLoading();
// //         changeOrderStatus = _orderStatus;
// //       }

// //       yield UpdateStatusOrderLoaded(data: data);
// //     });
// //     // }
// //   }

//   // Stream<GetStatusOrderState> fetchOrderStatus() async* {
//   //   log("fetch status order called ---------->>>>>>>>>>");
//   //   yield GetStatusOrderLoading();

//   //   final result = await getStatusOrder.call();
//   //   yield* result.fold((failure) async* {
//   //     logMe("failure");
//   //     logMe(failure);
//   //     yield GetStatusOrderFailure(failure: failure);
//   //   }, (data) async* {
//   //     logMe("Order Statussss : $data");
//   //     logMe(orderStatus);
//   //     // _orderStatus = data.status;
//   //     yield GetStatusOrderLoaded(data: data);
//   //   });
//   // }

//   Stream<GetOrderDetailState> fetchOrderDetail() async* {
//     yield GetOrderDetailLoading();

//     final result = await getOrderDetail.call(session.orderId);
//     yield* result.fold((failure) async* {
//       logMe("failure");
//       logMe(failure);
//       yield GetOrderDetailFailure(failure: failure);
//     }, (data) async* {
//       session.setDriverId = data.driverId.toString();
//       yield GetOrderDetailLoaded(data: data);
//     });
//   }

//   moveCameraToDriver() async {
//     showLoading();

//     var coordinate =
//         LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
//     dismissLoading();
//     googleMapController.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(
//           target: coordinate,
//           zoom: zoom,
//         ),
//       ),
//     );
//     notifyListeners();
//   }

//   startNavigationInMap() async {
//     var latLongOrigin = _orderDetail!.startCoordinate;
//     var latLongDestination = _orderDetail!.endCoordinate;
//     var splitOrigin = latLongOrigin.split(",");
//     var splitDestination = latLongDestination.split(",");
//     var latOrigin = double.parse(splitOrigin[0]);
//     var lngOrigin = double.parse(splitOrigin[1]);
//     var latDestination = double.parse(splitDestination[0]);
//     var lngDestination = double.parse(splitDestination[1]);
//     String url;
//     String appleUrl;
//     String googleUrl;

//     if (_orderStatus == OrderStatus.driverAccept ||
//         _orderStatus == OrderStatus.departureToCustomerplace) {
//       url = 'google.navigation:q=$latOrigin,$lngOrigin&mode=d';
//       googleUrl =
//           'https://www.google.com/maps/search/?api=1&query=$latOrigin,$lngOrigin';
//       appleUrl =
//           'https://maps.apple.com/?saddr=&daddr=$latOrigin,$lngOrigin&directionsmode=driving';
//     } else {
//       url = 'google.navigation:q=$latDestination,$lngDestination&mode=d';
//       googleUrl =
//           'https://www.google.com/maps/search/?api=1&query=$latDestination,$lngDestination';
//       appleUrl =
//           'https://maps.apple.com/?saddr=&daddr=$latDestination,$lngDestination&directionsmode=driving';
//     }
//     Uri appleUri = Uri.parse(appleUrl);
//     Uri googleUri = Uri.parse(googleUrl);
//     Uri urlUri = Uri.parse(url);

//     if (Platform.isIOS) {
//       if (await canLaunchUrl(appleUri)) {
//         await launchUrl(appleUri, mode: LaunchMode.externalApplication);
//       } else {
//         if (await canLaunchUrl(googleUri)) {
//           await launchUrl(googleUri, mode: LaunchMode.externalApplication);
//         }
//       }
//     } else {
//       if (await canLaunchUrl(urlUri)) {
//         await launchUrl(urlUri, mode: LaunchMode.externalApplication);
//       }
//     }

//     // if (await canLaunchUrl(Uri.parse(url))) {
//     //   await launchUrl(Uri.parse(url));
//     // } else {
//     //   throw 'Could not launch $url';
//     // }
//     notifyListeners();
//   }

// // String appleUrl = 'https://maps.apple.com/?saddr=&daddr=$lat,$lon&directionsmode=driving';
// // String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
// //

//   callCustomer() async {
//     if (_customerDetail!.phoneNumber != '') {
//       final call = Uri.parse('tel:${_customerDetail!.phoneNumber}');
//       launchUrl(call);
//     } else {
//       showToast(message: "No Phone number");
//     }
//   }

//   Future<void> updateLocation(Position position) async {
//     log("Driver LatLong ${position.latitude}== ${position.longitude}");
//     // locationService.getLocation().then((value) {
//     //   log("tracking " +
//     //       value.latitude.toString() +
//     //       ' , ' +
//     //       value.longitude.toString() +
//     //       "and towards " +
//     //       value.heading.toString());

//     //   var bearing = value.heading;
//     //   var lat = value.latitude;
//     //   var lng = value.longitude;
//     //   var coordinate = "$lat,$lng";
//     //   submitLocation(coordinate, bearing.toString()).listen((event) {
//     //     if (event is UpdateLocationLoaded) {
//     //       logMe("Sukses Update Location");
//     //     }
//     //   });
//     // });
//   }

//   // Stream<UpdateLocationState> submitLocation(
//   //     String latLng, String bearing) async* {
//   //   log("submit location called------>>>>");
//   //   yield UpdateLocationLoading();

//   //   final formData = FormData.fromMap({
//   //     'api_token': session.sessionToken,
//   //     'coordinate': latLng,
//   //     'bearing': bearing,
//   //   });

//   //   log("update location data is-->> ${formData.fields}");
//   //   final result = await doUpdateLocation.execute(formData);
//   //   yield* result.fold((failure) async* {
//   //     logMe(failure);

//   //     yield UpdateLocationFailure(failure: failure);
//   //   }, (data) async* {
//   //     updateDriverLatLong(val: latLng);
//   //     yield UpdateLocationLoaded(data: data);
//   //   });
//   // }

//   /// Track Live Tracking Distance

//   // trackLiveTrackingDistance() {}
// }
