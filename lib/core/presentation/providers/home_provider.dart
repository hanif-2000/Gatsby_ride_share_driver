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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart' as lctn;
import 'package:location/location.dart';
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
  final GetProfile getProfile;
  final GetOrderDetail getOrderDetail;
  final GetRequestList getRequestList;
  final GetCustomerDetail getCustomerDetail;
  final ChangeStatus changeStatus;
  final UpdateStatusOrder updateStatusOrder;
  final DoUpdateLocation doUpdateLocation;
  final session = locator<Session>();
  late BitmapDescriptor pickUpMarker, destinationMarker;
  Location location = Location();

  final lctn.Location locationService = lctn.Location();
  CameraPosition kJapanCoordinate = const CameraPosition(
    target: DEFAULT_LATLNG,
    zoom: 14.4746,
  );
  CustomerDataModel? _customerDetailModel;
  OrderDetail? _orderDetail;
  bool _isOnline = false;
  late ProjectType _projectType = ProjectType.requests;

  late GoogleMapController googleMapController;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late BitmapDescriptor driverMarker;
  late BitmapDescriptor redMarker;
  String originAddress = '';
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};
  var dio = Dio();

  Timer? refreshRequestList;

  bool get isOnline => _isOnline;
  CustomerDataModel? get customerDetailModel => _customerDetailModel;
  OrderDetail? get orderDetail => _orderDetail;
  ProjectType get projectType => _projectType;

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  GlobalKey get globalKey => _key;

  set changeStatus(val) {
    _isOnline = val;
    notifyListeners();
    dev.log("_isOnline is :-->> $_isOnline");
  }

  set setOrderDetails(OrderDetail value) {
    _orderDetail = value;
    notifyListeners();
  }

  set setCustomerDetails(CustomerDataModel value) {
    _customerDetailModel = value;
    notifyListeners();
  }

  set projectType(value) {
    _projectType = value;
    notifyListeners();
  }

  clearState() async {
    await sessionClearOrder();
    polylines.clear();
    markers.clear();
    notifyListeners();
  }

  HomeProvider({
    required this.getProfile,
    required this.getCustomerDetail,
    required this.getRequestList,
    required this.updateStatusOrder,
    required this.getOrderDetail,
    required this.doUpdateLocation,
    required this.changeStatus,
  }) {
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
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  setCurrentLocation() async {
    try {
      bool serviceStatus = await locationService.serviceEnabled();
      if (serviceStatus) {
        lctn.LocationData locationData = await locationService.getLocation();
        logMe("locationData");
        logMe(locationData);
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

  Stream<ChangeStatusState> updateStatus(
      {bool isFromLogout = false, bool? targetOnline}) async* {
    showLoading();
    yield ChangeStatusLoading();

    final bool resolvedOnline =
        isFromLogout ? false : (targetOnline ?? _isOnline);
    final String driverStatus = resolvedOnline ? '1' : '0';

    dev.log("*****************************************************************************************");
    dev.log("Is driver online (resolved): $resolvedOnline | _isOnline: $_isOnline");
    dev.log("*****************************************************************************************");

    Map<String, dynamic> fields = {'status': driverStatus};

    if (driverStatus == '1') {
      // FCM token fresh lo
      try {
        final fcmToken =
            await FirebaseMessaging.instance.getToken() ?? "";
        if (fcmToken.isNotEmpty) {
          fields['fcm_token'] = fcmToken;
          session.setFcmToken = fcmToken;
          dev.log("✅ FCM token fetched for set-status: $fcmToken");
        } else {
          dev.log("⚠️ FCM token empty");
        }
      } catch (e) {
        dev.log("⚠️ FCM token error: $e");
      }

      // Location lo
      try {
        geo.LocationPermission permission =
            await geo.Geolocator.checkPermission();
        if (permission == geo.LocationPermission.denied) {
          permission = await geo.Geolocator.requestPermission();
        }

        if (permission == geo.LocationPermission.whileInUse ||
            permission == geo.LocationPermission.always) {
          final position = await geo.Geolocator.getCurrentPosition()
              .timeout(const Duration(seconds: 5));
          fields['latitude'] = position.latitude.toString();
          fields['longitude'] = position.longitude.toString();
          fields['bearing'] = position.heading.toString();
          dev.log(
              "✅ Location fetched: lat=${position.latitude}, lng=${position.longitude}");
        } else {
          dev.log("⚠️ Location permission denied");
        }
      } catch (e) {
        dev.log('⚠️ Location fetch error: $e');
      }
    }

    dev.log("set-status body: ${fields.toString()}");
    final result = await changeStatus.execute(fields);

    yield* result.fold((failure) async* {
      dev.log("failure is called-->>");
      logMe(failure);
      _isOnline = !resolvedOnline;
      notifyListeners();
      dismissLoading();
      yield ChangeStatusFailure(failure: failure);
    }, (data) async* {
      dev.log("success is called-->>");
      if (driverStatus == '1') {
        updateLocation(); // fire-and-forget — GPS block nahi karega
      }
      dismissLoading();
      yield ChangeStatusLoaded(data: data);
    });
  }
  Stream<RequestListState> getRequestListData() async* {
    print('========== Refresh List =============');
    yield RequestListLoading();
    final formData = FormData.fromMap({});
    final result = await getRequestList.call(formData);
    yield* result.fold((failure) async* {
      logMe("failure");
      logMe(failure);
      yield RequestListFailure(failure: failure);
    }, (data) async* {
      dismissLoading();
      yield RequestListLoaded(data: data.data);
    });
  }

  checkNotificationCurrentStateCalled() {
    dev.log("Check notification current state is called ");
  }

  Stream<RejectRequestState> rejectRequest(String orderId, String reason) async* {
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
        googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
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
        rotation: locationData.heading!,
        onTap: () {},
      );
      if (!isListen) {
        googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 18,
        )));
      }
      markers[markerId] = marker;
      notifyListeners();
    } catch (e) {
      logMe('Error in creating marker --> $e');
    }
  }

  createPickupAndDropMarker(LatLng pickup, LatLng drop) async {
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
        onTap: () {},
      );
      final Marker dropMarker = Marker(
        anchor: const Offset(0.5, 0.5),
        markerId: dropMarkerId,
        position: LatLng(drop.latitude, drop.longitude),
        icon: await getBytesFromAsset(destinationIcon, 100).then((value) {
          return destinationMarker = BitmapDescriptor.fromBytes(value);
        }),
        onTap: () {},
      );
      markers[pickupMarkerId] = marker;
      markers[dropMarkerId] = dropMarker;
      notifyListeners();
      List<Marker> listMarker = [];
      markers.forEach((k, v) => listMarker.add(v));
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(getBounds(listMarker), 75);
      googleMapController.animateCamera(cameraUpdate);
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
    return LatLngBounds(
      northeast: LatLng(rightMost, topMost),
      southwest: LatLng(leftMost, bottomMost),
    );
  }

  setPolylineDirection(LatLng origin, LatLng destination) async {
    polylines.clear();
    await DirectionHelper()
        .getRouteBetweenCoordinates(
          origin.latitude,
          origin.longitude,
          destination.latitude,
          destination.longitude,
        )
        .then((result) {
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
          endCap: Cap.roundCap,
        );
        polylines.add(polyline);
        logMe('Polyline in the list - ${polylines.toString()}');
        notifyListeners();
      }
    });
  }

  Stream<ProfileState> fetchProfile() async* {
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
        originLat: double.parse(_orderDetail!.startCoordinate.split(',').first),
        originLong: double.parse(_orderDetail!.startCoordinate.split(',').last),
        destinationLat: double.parse(_orderDetail!.endCoordinate.split(',').first),
        destinationLong: double.parse(_orderDetail!.endCoordinate.split(',').last),
      );
      notifyListeners();
      yield OrderDetailLoaded(data: data);
    });
  }

  setActualDistance({destinationLat, destinationLong, originLat, originLong}) async {
    try {
      var response = await Dio().get(
        'https://maps.googleapis.com/maps/api/distancematrix/json?destinations=$destinationLat,$destinationLong&origins=$originLat,$originLong&key=AIzaSyAEcqthk6N17_4Q3pyqDrKAQPpiYURZxJs',
      );
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


  updateLocation() async {
    dev.log("Update location function called");
    await locationService.getLocation().timeout(const Duration(seconds: 5), onTimeout: () {
      dev.log("⚠️ updateLocation GPS timeout");
      throw Exception("GPS timeout");
    }).then((value) {
      var bearing = value.heading;
      var lat = value.latitude;
      var lng = value.longitude;
      var coordinate = "$lat,$lng";
      submitLocation(coordinate, bearing.toString()).listen((event) {
        if (event is UpdateLocationLoaded) {
          logMe("Sukses Update Location");
          logMe("curent coordinates are:-->> $coordinate");
        }
      });
    }).catchError((e) {
      dev.log("updateLocation error: $e");
    });
  }

  Stream<UpdateLocationState> submitLocation(String latLng, String bearing) async* {
    dev.log("Submt location function called");
    yield UpdateLocationLoading();
    final parts = latLng.split(',');
    final formData = FormData.fromMap({
      'lat': parts[0],
      'lng': parts[1],
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
}