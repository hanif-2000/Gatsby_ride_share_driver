import 'dart:io';
import 'dart:math';
import 'dart:developer' as dev;

import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/dimens.dart';
import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as hand;

import '../../features/history/data/models/history_response_model.dart'
    as history;
import '../../features/profile/data/models/profile_response_model.dart'
    as profile;
import '../static/enums.dart';
import '../static/order_status.dart';
import 'injection.dart';

logMe(Object? obj) {
  /*
    use this for print something, its run only on debug mode.
  */
  if (kDebugMode) {
    print(obj);
  }
}

Future<String> convertSecondsToMinutes({required int time}) async {
  int seconds = time; // Replace this with your desired number of seconds

  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;

  int hours = minutes ~/ 60;
  int remainingMinutes = minutes % 60;

  print('$seconds seconds is equivalent to:');
  print(
      '$hours hours, $remainingMinutes minutes, and $remainingSeconds seconds');

  // setState(() {
  // extraTimeTaken = "$hours"
  //     ' hr '
  //     '$remainingMinutes'
  //     ' min '
  //     '$remainingSeconds'
  //     ' sec ';
  // });

  return '$hours hr $remainingMinutes min $remainingSeconds sec';
}

// spacing
Widget smallVerticalSpacing() => const SizedBox(height: sizeSmall);

Widget smallHorizontalSpacing() => const SizedBox(width: sizeSmall);

Widget mediumVerticalSpacing() => const SizedBox(height: sizeMedium);

Widget mediumHorizontalSpacing() => const SizedBox(width: sizeMedium);

///# Size 32.0
Widget largeVerticalSpacing() => const SizedBox(height: sizeLarge);

Widget largeHorizontalSpacing() => const SizedBox(width: sizeLarge);

Widget superLargeVerticalSpacing() => const SizedBox(height: sizeExtraLarge);

//Locale Language
late AppLocalizations appLoc;

//Route
final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

Location location = Location();
final Location _location = Location();

checkPermissinLocationNotification() async {
  if (await hand.Permission.location.serviceStatus.isEnabled) {
    dev.log("location service is enabled");

    var status = await hand.Permission.location.status;

    if (status.isGranted) {
      dev.log("location permission is granted");
    } else if (status.isDenied) {
      dev.log("location permission denied");
    }
  } else {
    bool isturnedon = await location.requestService();
    if (isturnedon) {
      print("GPS device is turned ON");
    } else {
      print("GPS Device is still OFF");
    }

    dev.log("location service is disabled");
  }
}

Future<bool> showCancelConfirmationAlertDialog(
    {required BuildContext context, required VoidCallback onTap}) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cancel Confirmation'),
      content: const Text('Do you really want to cancel the Ride'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(backgroundColor: black15141FColor),
          child: const Text('Cancel Ride'),
        ),
        OutlinedButton(
          child: const Text(
            'Go back',
            style: TextStyle(color: black15141FColor),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
      actionsAlignment: MainAxisAlignment.spaceBetween,
    ),
  );
}

Future<bool> showAlertDialog({
  required BuildContext context,
}) async {
  if (!Platform.isIOS) {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Services Disabled'),
        content: const Text('You need to enable Location Services in Setting'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Setting'),
            onPressed: () {
              hand.openAppSettings();
              Navigator.of(context).pop(false);
            },
          ),
        ],
      ),
    );
  }

// todo : showDialog for ios
  return await showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Location Services Disabled'),
      content: const Text('You need to enable location services in setting'),
      actions: <Widget>[
        CupertinoDialogAction(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        CupertinoDialogAction(
          child: const Text('Setting'),
          onPressed: () {
            hand.openAppSettings();
            Navigator.of(context).pop(false);
          },
        ),
      ],
    ),
  );
}

Future<bool> checkPermission() async {
  print("check permission called");
  bool serviceEnabled;

  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  permission = await Geolocator.checkPermission();
  // var notificationPermission = await Permission.notification.request();

  // dev.log("notification permission is :-->> $notificationPermission");/
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return false;
  }
  return true;
}

/// CHECK LOCATION AND PERMISSION
Future<bool> checkLocationAndPermission() async {
  // Check location permission status
  PermissionStatus permission = await _location.hasPermission();

  if (permission == PermissionStatus.granted) {
    // Location permission is already granted, return true
    return true;
  }

  if (permission == PermissionStatus.denied) {
    // Request location permission
    await Geolocator.requestPermission();
    // Re-check permission status after requesting
    permission = await _location.hasPermission();
  }

  if (permission == PermissionStatus.granted) {
    // Location permission granted after request, return true
    return true;
  } else {
    // Location permission not granted or denied forever, return false
    return false;
  }
}

String mergeAddress(String placeName, String address) {
  String result;
  result = '$placeName, $address';
  return result;
}

String mergeTypeTaxi(history.VehicleCategory category) {
  String result;
  String categoryName = category.category;
  String seat = category.seat.toString();
  result = "$categoryName($seat${appLoc.people})";
  return result;
}

String mergeTypeTaxiProfile(profile.CategoryModel category) {
  String result;
  String categoryName = category.categoryName;
  String seat = category.seat.toString();
  result = "$categoryName($seat${appLoc.people})";
  return result;
}

String mergePhotoUrl(String photoUrl) {
  String result;
  if (photoUrl == '') {
    result = '';
  } else {
    result = '$BASE_URL$photoUrl';
  }

  return result;
}

String mergeDistanceTxt(String distance) {
  String result;
  result = '$distance km';
  return result;
}

String mergePriceTxt(String price) {
  final session = locator<Session>();
  String currency = session.currency;
  String result;
  result = '$currency$price ';

  return result;
}

/// RETURN TRUE IF TO SHOW ORIGIN OR DESTINATION WIDGET AT TOP
bool getStatus(OrderStatus orderStatus) {
  if (orderStatus == OrderStatus.driverAccept ||
          orderStatus == OrderStatus.departureToCustomerplace ||
          orderStatus == OrderStatus.arriveAtCustomerPlace
      // ||
      // orderStatus == OrderStatus.customerConfirmation
      ) {
    //Origin
    return true;
  } else {
    //Destination
    return false;
  }
}

Future<double> getDistance(
    LatLng originLatLng, LatLng destinationLatLng) async {
  return Geolocator.distanceBetween(
      originLatLng.latitude,
      originLatLng.longitude,
      destinationLatLng.latitude,
      destinationLatLng.longitude);
}

showLoading() {
  SmartDialog.showLoading(
    backDismiss: false,
    builder: (context) => const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
  );
}

dismissLoading() {
  SmartDialog.dismiss();
}

void showToast({required String message, Color? color}) {
  Fluttertoast.showToast(
      gravity: ToastGravity.TOP,
      backgroundColor: color ?? Colors.black,
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 1);
}

Future<void> sessionLogOut() async {
  final session = locator<Session>();
  await session.clearSession();
}

LatLngBounds getBounds(List<Marker> markers) {
  var lngs = markers.map<double>((m) => m.position.longitude).toList();
  var lats = markers.map<double>((m) => m.position.latitude).toList();

  double topMost = lngs.reduce(max);
  double leftMost = lats.reduce(min);
  double rightMost = lats.reduce(max);
  double bottomMost = lngs.reduce(min);

  LatLngBounds bounds = LatLngBounds(
    northeast: LatLng(rightMost, topMost),
    southwest: LatLng(leftMost, bottomMost),
  );

  return bounds;
}

Future<void> sessionClearOrder() async {
  final session = locator<Session>();
  await session.clearOrderSession();
}

String getDateString(DateTime date) {
  var strDate = DateFormat.yMd(myLocale.languageCode).format(date);
  var strTime = DateFormat("hh:mm aa", myLocale.languageCode).format(date);
  return "$strDate $strTime";
}

String getPaymentMethod(history.HistoryOrder data) {
  String result;
  if (data.paymentMethod.toString() == "1") {
    result = appLoc.cash;
  } else {
    result = appLoc.creditdebit;
  }
  return result;
}

String getHistoryStatus(String statusHistory) {
  var status = int.parse(statusHistory);
  String strStatus = "";
  switch (status) {
    case Order.lookingDriver:
      strStatus = appLoc.pending;
      break;
    case Order.driverAccept:
      strStatus = appLoc.gotadriver;
      break;
    case Order.departureToCustomerPlace:
      strStatus = appLoc.departToCustomerPlace;
      break;
    case Order.arriveAtCustomerPlace:
      strStatus = appLoc.arriveAtCustomerPlace;
      break;
    case Order.customerConfirmation:
      strStatus = appLoc.arriveAtCustomerPlace;
      break;
    case Order.departureToDestination:
      strStatus = appLoc.departToDestination;
      break;
    case Order.arriveAtDestination:
      strStatus = appLoc.arriveAtDestination;
      break;
    case Order.complete:
      strStatus = appLoc.complete;
      break;
    case Order.cancel:
      strStatus = appLoc.cancel;
      break;
  }
  return strStatus;
}

getPaymentType(int type) {
  if (type == 1) {
    return 'Cash';
  } else if (type == 2) {
    return 'Credit Card';
  } else if (type == 3) {
    return 'Google Pay';
  } else {
    return 'Apple Pay';
  }
}

getStatusColor(String status) {
  return status == '8'
      ? Colors.redAccent
      : status == '7'
          ? Colors.green
          : yellowE5A829;
}

String getOrderStatus(String statusHistory) {
  var status = int.parse(statusHistory);
  String strStatus = "";
  switch (status) {
    case Order.lookingDriver:
      strStatus = appLoc.pending;
      break;
    case Order.driverAccept:
      strStatus = appLoc.pending;
      break;
    case Order.departureToCustomerPlace:
      strStatus = appLoc.pending;
      break;
    case Order.arriveAtCustomerPlace:
      strStatus = appLoc.pending;
      break;
    case Order.customerConfirmation:
      strStatus = appLoc.pending;
      break;
    case Order.departureToDestination:
      strStatus = appLoc.pending;
      break;
    case Order.arriveAtDestination:
      strStatus = appLoc.pending;
      break;
    case Order.complete:
      strStatus = appLoc.complete;
      break;
    case Order.cancel:
      strStatus = appLoc.cancelled;
      break;
  }
  return strStatus;
}

String getTimeTaken(int minutes) {
  if (minutes < 60) {
    return '$minutes min';
  } else {
    double hours = minutes / 60;
    return '$hours hours';
  }

  return '';
}
