import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math' as Math;
import 'dart:ui' as ui;
import 'package:appkey_taxiapp_driver/core/domain/usecases/do_update_location.dart';
import 'package:appkey_taxiapp_driver/core/domain/usecases/get_customer_detail.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/reject_request_state.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/request_list_state.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/update_location_state.dart';
import 'package:appkey_taxiapp_driver/core/static/assets.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/usecases/change_status.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/usecases/get_order_detail.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/usecases/get_request_list.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/customer_detail_state.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/order_detail_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as lctn;
import '../../../features/order/domain/entities/order_detail.dart';
import '../../../features/order/domain/usecases/update_status_order.dart';
import '../../../features/order/presentation/providers/update_status_order_state.dart';
import '../../../features/profile/domain/usecases/get_profile.dart';
import '../../../features/profile/presentation/providers/profile_state.dart';
import '../../data/models/customer_detail_model.dart';
import '../../data/models/google_route_response_modal.dart';
import '../../utility/direction_helper.dart';
import '../../utility/firebase_helper.dart';
import '../../utility/injection.dart';
import '../../utility/session_helper.dart';
import 'change_status_state.dart';

class HomeProvider with ChangeNotifier {
  //Constructor
  final GetProfile getProfile;
  final GetOrderDetail getOrderDetail;
  final GetRequestList getRequestList;
  final GetCustomerDetail getCustomerDetail;
  final ChangeStatus changeStatus;
  final UpdateStatusOrder updateStatusOrder;
  final DoUpdateLocation doUpdateLocation;
  final session = locator<Session>();
  late BitmapDescriptor pickUpMarker, destinationMarker;
  lctn.Location location = lctn.Location();


  //Initial
  final lctn.Location locationService = lctn.Location();
  CameraPosition kJapanCoordinate = const CameraPosition(
    target: DEFAULT_LATLNG,
    zoom: 14.4746,
  );
  CustomerDataModel? _customerDetailModel;
  OrderDetail? _orderDetail;
  bool _isOnline = false;
  late ProjectType _projectType = ProjectType.requests;

  // late bool _isOrderExist = false;

  late GoogleMapController googleMapController;

  // Completer<GoogleMapController> mapController = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late BitmapDescriptor driverMarker;
  late BitmapDescriptor redMarker;
  String originAddress = '';
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  var dio = Dio();

  Timer? refreshRequestList;

  // getter
  bool get isOnline => _isOnline;

  CustomerDataModel? get customerDetailModel => _customerDetailModel;

  OrderDetail? get orderDetail => _orderDetail;

  ProjectType get projectType => _projectType;

  // bool get isOrderExist => _isOrderExist;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  GlobalKey get globalKey => _key;

  //setter
  // set changeStatusOld(val) {
  //   _isOnline = val;
  //   // notifyListeners();
  // }

  set changeStatus(val) {
    _isOnline = val;

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    notifyListeners();

    print("_isOnline is :-->> $_isOnline");
    print("_isOnline is :-->> l $isOnline");

    // });
  }

  /// UDPATE ORDER DETAILS
  set setOrderDetails(OrderDetail value) {
    _orderDetail = value;
    notifyListeners();
  }

  ///UPDATE CUSTOMER DETAILS
  set setCustomerDetails(CustomerDataModel value) {
    _customerDetailModel = value;
    notifyListeners();
  }

  set projectType(value) {
    _projectType = value;
    notifyListeners();
  }

  // set setOrder(val) {
  //   _isOrderExist = val;
  //   notifyListeners();
  // }

  //clear state
  clearState() async {
    await sessionClearOrder();
    polylines.clear();
    markers.clear();
    notifyListeners();
  }

  //constructor
  HomeProvider(
      {required this.getProfile,
      required this.getCustomerDetail,
      required this.getRequestList,
      required this.updateStatusOrder,
      required this.getOrderDetail,
      required this.doUpdateLocation,
      required this.changeStatus}) {
    getBytesFromAsset(carIconAsset, 100).then((value) {
      driverMarker = BitmapDescriptor.fromBytes(value);
    });
    getBytesFromAsset(redMarkerIcon, 48).then((value) async {
      redMarker = BitmapDescriptor.fromBytes(value);
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

  setCurrentLocation() async {
    try {
      // showLoading();
      bool serviceStatus = await locationService.serviceEnabled();
      if (serviceStatus) {
        lctn.LocationData locationData = await locationService.getLocation();
        logMe("locationData");
        logMe(locationData);

        // createDriverMarker(locationData, false);
        // fetchProfile().listen((event) {});

        //onlocation change
        // locationService.onLocationChanged.listen((event) {
        //   createDriverMarker(event, true);
        // });
      } else {
        try {
          bool serviceStatusResult = await locationService.requestService();
          logMe("Service status activated after request: $serviceStatusResult");
          if (serviceStatusResult) {
            setCurrentLocation();
          }
        } catch (e) {
          logMe(e.toString());
        }
      }
    } on PlatformException catch (e) {
      if (e.toString() == 'PERMISSION_DENIED') {
        logMe(e.toString());
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        logMe(e.message);
      }
    }
  }

  Stream<UpdateStatusOrderState> submitStatusOrder(int orderStatus) async* {
    showLoading();
    yield UpdateStatusOrderLoading();
    final formData = FormData.fromMap({
      'id': session.runningOrderId,
      'status': orderStatus,
    });
    final result = await updateStatusOrder.execute(formData);
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      dismissLoading();
      yield UpdateStatusOrderFailure(failure: failure);
    }, (data) async* {
      dismissLoading();
      yield UpdateStatusOrderLoaded(data: data);
    });
  }

  Stream<RequestListState> getRequestListData() async* {
    // showLoading();
    print('========== Refresh List =============');
    yield RequestListLoading();
    final formData = FormData.fromMap({
      // 'id': session.orderId,
      // 'status': orderStatus,
    });
    final result = await getRequestList.call(formData);
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      // dismissLoading();
      yield RequestListFailure(failure: failure);
    }, (data) async* {
      dismissLoading();
      yield RequestListLoaded(data: data.data);
    });
  }

  checkNotificationCurrentStateCalled() {
    dev.log("Check notification current state is called ");
  }

  Stream<RejectRequestState> rejectRequest(
      String orderId, String reason) async* {
    showLoading();
    yield RejectRequestLoading();
    final formData = FormData.fromMap({
      'order_id': orderId,
      'reason': reason,
    });
    final result = await getRequestList.reject(formData);
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      dismissLoading();
      yield RejectRequestFailure(failure: failure);
    }, (data) async* {
      dismissLoading();
      // rejectRequestSocket();
      yield RejectRequestLoaded(data: data);
    });
  }

  getCurrentLocation() async {
    try {
      showLoading();
      bool serviceStatus = await locationService.serviceEnabled();
      if (serviceStatus) {
        lctn.LocationData locationData = await locationService.getLocation();
        logMe("locationData");
        logMe(locationData);
        dismissLoading();
        googleMapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 18,
        )));
      } else {
        try {
          bool serviceStatusResult = await locationService.requestService();
          logMe("Service status activated after request: $serviceStatusResult");
          if (serviceStatusResult) {
            getCurrentLocation();
          }
        } catch (e) {
          dismissLoading();
          logMe(e.toString());
        }
      }
    } on PlatformException catch (e) {
      dismissLoading();
      if (e.toString() == 'PERMISSION_DENIED') {
        logMe(e.toString());
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        logMe(e.message);
      }
    }
  }

  createDriverMarker(lctn.LocationData locationData, bool isListen) async {
    try {
      logMe('Create in creating marker --> ');
      MarkerId markerId = const MarkerId("origin");
      final Marker marker = Marker(
        anchor: const Offset(0.5, 0.5),
        markerId: markerId,
        position: LatLng(locationData.latitude!, locationData.longitude!),
        // icon: driverMarker,
        rotation: locationData.heading!,
        onTap: () {},
      );

      if (!isListen) {
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(locationData.latitude!, locationData.longitude!),
              zoom: 18,
            ),
          ),
        );
      }

      markers[markerId] = marker;
      notifyListeners();
    } catch (e) {
      logMe('Error in creating marker --> $e');
    }
  }

  createPickupAndDropMarker(
    LatLng pickup,
    LatLng drop,
  ) async {
    try {
      logMe('Create in creating marker --> ');
      MarkerId pickupMarkerId = const MarkerId("pickup");
      MarkerId dropMarkerId = const MarkerId("drop");
      final Marker marker = Marker(
        anchor: const Offset(0.5, 0.5),
        markerId: pickupMarkerId,
        position: LatLng(pickup.latitude, pickup.longitude),
        icon: await getBytesFromAsset(pickupIcon, 70).then((value) {
          return pickUpMarker = BitmapDescriptor.fromBytes(value);
        }),
        // rotation: locationData.heading!,
        onTap: () {},
      );
      final Marker dropMarker = Marker(
        anchor: const Offset(0.5, 0.5),
        markerId: dropMarkerId,
        position: LatLng(drop.latitude, drop.longitude),
        icon: await getBytesFromAsset(destinationIcon, 100).then((value) {
          return destinationMarker = BitmapDescriptor.fromBytes(value);
        }),
        // rotation: locationData.heading!,
        onTap: () {},
      );

      markers[pickupMarkerId] = marker;
      markers[dropMarkerId] = dropMarker;
      notifyListeners();
      // googleMapController.animateCamera(
      //   CameraUpdate.newCameraPosition(
      //     CameraPosition(
      //       target: pickup,
      //       zoom: 17,
      //     ),
      //   ),
      // );

      List<Marker> listMarker = [];
      markers.forEach((k, v) => listMarker.add(v));
      CameraUpdate cameraUpdate =
          CameraUpdate.newLatLngBounds(getBounds(listMarker), 75);
      googleMapController.animateCamera(cameraUpdate);

      // googleMapController.animateCamera(CameraUpdate.newLatLngBounds(
      //   getBounds(markers), 75)
      //     LatLngBounds(
      //       southwest: LatLng(
      //           pickup.latitude <= drop.latitude
      //               ? pickup.latitude
      //               : drop.latitude,
      //           pickup.longitude <= drop.longitude
      //               ? pickup.longitude
      //               : drop.longitude),
      //       northeast: LatLng(
      //         pickup.latitude <= drop.latitude
      //             ? drop.latitude
      //             : pickup.latitude,
      //         pickup.longitude <= drop.longitude
      //             ? drop.longitude
      //             : pickup.longitude,
      //       ),
      //     )
      // )
      // );

      logMe('Marker created -- --> ${markers.length}');
    } catch (e) {
      logMe('Error in creating marker --> $e');
    }
  }

  LatLngBounds getBounds(List<Marker> markers) {
    var lngs = markers.map<double>((m) => m.position.longitude).toList();
    var lats = markers.map<double>((m) => m.position.latitude).toList();

    double topMost = lngs.reduce(Math.max);
    double leftMost = lats.reduce(Math.min);
    double rightMost = lats.reduce(Math.max);
    double bottomMost = lngs.reduce(Math.min);

    LatLngBounds bounds = LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );

    return bounds;
  }

  setPolylineDirection(LatLng origin, LatLng destination) async {
    polylines.clear();
    await DirectionHelper()
        .getRouteBetweenCoordinates(origin.latitude, origin.longitude,
            destination.latitude, destination.longitude)
        .then(
      (result) {
        logMe('Polyline ---> ${result.toString()}');
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
          polylines.add(polyline);
          logMe('Polyline in the list - ${polylines.toString()}');
          notifyListeners();
        }
      },
    );
  }

  Stream<ProfileState> fetchProfile() async* {
    // showLoading();
    yield ProfileLoading();
    final result = await getProfile();
    yield* result.fold((failure) async* {
      logMe(failure);
      dismissLoading();
      yield ProfileFailure(failure: failure.message);
    }, (data) async* {
      if (data.statusOrder == '1') {
        changeStatus = true;
        await updateLocation();
      } else {
        changeStatus = false;
      }
      await FirebaseHelper.setTopicDriver(data.statusOrder!).then((_) {});
      dismissLoading();

      yield ProfileLoaded(data: data);
    });
  }

  Stream<OrderDetailState> fetchOrderDetail(String orderId) async* {
    dev.log("fetch order details called");
    yield OrderDetailLoading();
    final result = await getOrderDetail.call(orderId);
    yield* result.fold((failure) async* {
      logMe(failure);
      logMe("Order failure");
      yield OrderDetailFailure(failure: failure.message);
    }, (data) async* {
      _orderDetail = data;

      setActualDistance(
          originLat:
              double.parse(_orderDetail!.startCoordinate.split(',').first),
          originLong:
              double.parse(_orderDetail!.startCoordinate.split(',').last),
          destinationLat:
              double.parse(_orderDetail!.endCoordinate.split(',').first),
          destinationLong:
              double.parse(_orderDetail!.endCoordinate.split(',').last));

      notifyListeners();
      yield OrderDetailLoaded(data: data);
    });
  }

  setActualDistance({destinationLat, destinationLong, originLat, originLong}) async {
    try {
      var response = await Dio().get('https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destinationLat,$destinationLong&origins=$originLat,$originLong&key=AIzaSyAEcqthk6N17_4Q3pyqDrKAQPpiYURZxJs');
      dev.log(" response of real distance:--->>> ${response.data}");
      var data = GoogleRouteDistanceResponseModal.fromJson(response.data);
      session.setEstimatedDistance = (data.rows[0].elements[0].distance.value / 1000).toString();
      session.setEstimatedTime = (data.rows[0].elements[0].duration.value / 60).toStringAsFixed(1);
      notifyListeners();
      dev.log("session distnace:--${session.estimatedDistance}");
      dev.log("session duration:--${session.estimatedTime}");
    } catch (e) {
      print(e);
    }
  }

  Stream<CustomerDetailState> fetchCustomerDetail(String userId) async* {
    yield CustomerDetailLoading();
    final result = await getCustomerDetail(userId);
    yield* result.fold((failure) async* {
      logMe(failure.message);
      logMe("failure customer");
      yield CustomerDetailFailure(failure: failure.message);
    }, (data) async* {
      _customerDetailModel = data.data;
      notifyListeners();
      yield CustomerDetailLoaded(data: data);
    });
  }

  Stream<ChangeStatusState> updateStatus({bool isFromLogout = false}) async* {
    showLoading();
    yield ChangeStatusLoading();
    String driverStatus;
    if (!isFromLogout) {
      if (_isOnline) {
        driverStatus = '1';
      } else {
        driverStatus = '0';
      }
    } else {
      driverStatus = '0';
    }

    final formData = FormData.fromMap({
      'api_token': session.sessionToken,
      'status': driverStatus,
    });

    final result = await changeStatus.execute(formData);
    yield* result.fold((failure) async* {
      print("failure is called-->>");
      logMe(failure);
      dismissLoading();
      yield ChangeStatusFailure(failure: failure);
    }, (data) async* {
      print("success is called-->>");

      if (driverStatus == '1') {
        await updateLocation();
      }
      // await FirebaseHelper.setTopicDriver(driverStatus).then((_) {});
      dismissLoading();
      yield ChangeStatusLoaded(data: data);
    });
  }

  updateLocation() async {
    dev.log("Update location function called");
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var bearing = position.heading;
    var lat = position.latitude;
    var lng = position.longitude;
    var coordinate = "$lat,$lng";
    submitLocation(coordinate, bearing.toString()).listen((event) {
      if (event is UpdateLocationLoaded) {
        logMe("Sukses Update Location");
        logMe("curent coordinates are:-->> $coordinate");
      }
    });
  }

  Stream<UpdateLocationState> submitLocation(
      String latLng, String bearing) async* {
    dev.log("Submt location function called");
    yield UpdateLocationLoading();

    final formData = FormData.fromMap({
      'coordinate': latLng,
      'bearing': bearing,
    });

    final result = await doUpdateLocation.execute(formData);
    yield* result.fold((failure) async* {
      logMe(failure);

      yield UpdateLocationFailure(failure: failure);
    }, (data) async* {
      yield UpdateLocationLoaded(data: data);
    });
  }

  // getDriverStatus() async {
  //   var response = await dio.get(
  //       'https://php.parastechnologies.in/taxi/public/api/webservice/driver/get-status',
  //       options: Options(
  //         headers: {"Authorization": "Bearer ${session.sessionToken}"},
  //       ));

  //   if (response.statusCode == 200) {
  //     if (response.data["status"] == "online") {
  //       session.setIsOnline = true;
  //       changeStatus = true;
  //       notifyListeners();
  //     } else if (response.data["status"] == "offline") {
  //       session.setIsOnline = false;
  //       changeStatus = false;
  //       notifyListeners();
  //     }
  //   }
  //   dev.log("driver status is :--->>  ${response.data}");
  // }
}
