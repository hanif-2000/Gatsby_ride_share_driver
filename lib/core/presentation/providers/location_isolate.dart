import 'dart:async';
import 'dart:isolate';
import 'package:geolocator/geolocator.dart';

void locationIsolate(SendPort sendPort) async {
  LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.bestForNavigation,
    distanceFilter: 30,
  );

  Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
    if (position != null) {
      sendPort.send(position);
    }
  });
}
