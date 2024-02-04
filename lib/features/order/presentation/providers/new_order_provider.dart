// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:ui' as ui;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../../../core/data/models/customer_detail_model.dart';
// import '../../../../core/static/assets.dart';
// import '../../../../core/utility/app_settings.dart';
// import '../../../../core/utility/direction_helper.dart';
// import '../../../../core/utility/helper.dart';
// import '../../../../core/utility/injection.dart';
// import '../../../../core/utility/session_helper.dart';
// import '../../../receipt/persentation/provider/receipt_provider.dart';
// import '../../data/models/driver_location_response_model.dart';
// import '../../domain/entities/order_detail.dart';

// class OrderProvider with ChangeNotifier {
//   //constructor
//   OrderProvider(
//       // {
//       // required this.updateStatusOrder,
//       // required this.getStatusOrder,
//       // required this.getDriverDetail,
//       // required this.doUpdateLocation,
//       // required this.getOrderDetail,
//       // required this.getDriverLocation,
//       // }
//       ) {
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

//   OrderProvider.internal();

//   //  socketProvider = Provider.of<LatestSocketProvider>(locator<GlobalKey<NavigatorState>>().currentContext!);

//   DriverLocationResponseModel? get driverLocation => _driverLocation;
//   final double _driverLat = 0.0;
//   final double _driverLng = 0.0;

//   CustomerDataModel? get customerDetail => _customerDetail;

//   // OrderDetail? get orderDetail => _orderDetail;

//   double get driverLat => _driverLat;

//   double? get driverLng => _driverLng;

//   Future<Uint8List> getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
//         .buffer
//         .asUint8List();
//   }

//   //Initial
//   CameraPosition kJapanCoordinate = const CameraPosition(
//     target: DEFAULT_LATLNG,
//     zoom: 14.4746,
//   );
//   CustomerDataModel? _customerDetail;

//   double zoom = 15;
//   String destinationAddress = "Destination";
//   DriverLocationResponseModel? _driverLocation;
//   OrderDetail? _orderDetail;

//   String originAddress = '';
//   bool isFirstTracking = true;
//   bool isWithDriver = false;
//   late Text originText;
//   late Text destinationText;
//   List<LatLng> polylineCoordinates = [];
//   Set<Polyline> polylines = {};
//   Set<Polyline> newPolylines = {};

//   final session = locator<Session>();
//   var receiptProvider = locator<ReceiptProvider>();
//   late GoogleMapController googleMapController;

//   late StreamSubscription<Position>? locationbackSubscription;
//   List<LatLng> driverCoordinatesList = [];
//   Position? _currentPosition;

//   late LatLng originLatLng, destinationLatLng;
//   Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
//   late BitmapDescriptor driverMarker;
//   late BitmapDescriptor pickUpMarker, destinationMarker;
//   set setOrderDetails(OrderDetail val) {
//     _orderDetail = val;
//     notifyListeners();
//   }

//   Future<void> _getCurrentLocation() async {
//     var position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     // setState(() {
//     _currentPosition = position;
//     notifyListeners();

//     print("------************* >>>>>>. CURRRENT LOCATION IS $_currentPosition");
//     // });
//   }

//   int checkText = 1;

//   updateText() {
//     checkText = checkText + 1;
//     notifyListeners();
//   }

// //update polyline

//   updatePolyline({required Polyline val}) {
//     newPolylines.add(val);
//     notifyListeners();
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

//   set setNewChangeOrderStatus(val) {
//     log("change order Status called  ========>>>>> $val");
//     // print("ORDER DETAILS ARE  ========>>>>> $orderDetail");
//     // print(
//     //     "ORDER DETAILS from SOCKET PROVIDER ========>>>>> ${socketProvider.orderDetail}");

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

//   setNewPolylineDirection(
//     bool isFromOrigin,
//   ) async {
//     // print(
//     //     "set polylines order details  are:-->> ${socketProvider.orderDetail!}");

//     updateText();
//     showLoading();
//     // var latLongOrigin = socketProvider.orderDetail!.startCoordinate;
//     // var latLongDestination = socketProvider.orderDetail!.endCoordinate;
//     var latLongOrigin = "30.703112393336106, 76.68201047927141";
//     var latLongDestination = "30.706780957567652, 76.68569013476372";

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
//       /*** GO TO DESTINATION FROM ORIGIN */
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

//           newPolylines.add(polyline);
//           updatePolyline(val: polyline);

//           polylines.add(polyline);
//           notifyListeners();
//           print("Polyline created not from origin $polylineCoordinates");
//           print("Polyline created not from newPolylines origin $newPolylines");

//           dismissLoading();
//         }
//       });
//       dismissLoading();
//     } else {
//       /*** GO TO ORIGIN  */
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
//           // polylines.add(polyline);
//           updatePolyline(val: polyline);
//           newPolylines.add(polyline);

//           notifyListeners();
//           print("Polyline created from origin $polylineCoordinates");
//           print("Polyline created from origin newPolylines $newPolylines");

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
//   //   print("is From origin $isFromOrigin");

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

//     if ((session.orderStatus == 1) || (session.orderStatus == 2)) {
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

//   callCustomer() async {
//     if (_customerDetail!.phoneNumber != '') {
//       final call = Uri.parse('tel:${_customerDetail!.phoneNumber}');
//       launchUrl(call);
//     } else {
//       showToast(message: "No Phone number");
//     }
//   }
// }
