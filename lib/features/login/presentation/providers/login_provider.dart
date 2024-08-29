import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/presentation/providers/form_provider.dart';
import '../../../../core/utility/helper.dart';
import '../../domain/usecases/do_login.dart';
import 'login_state.dart';

class LoginProvider extends FormProvider {
  final DoLogin doLogin;

  LoginProvider({required this.doLogin});

  Stream<LoginState> doLoginApi({required BuildContext context}) async* {
    yield LoginLoading();

    LocationPermission locationPermission = await Geolocator.checkPermission();
    logMe("location permission: $locationPermission");

    if (locationPermission == LocationPermission.denied ||
        locationPermission == LocationPermission.deniedForever) {
      // Show dialog for permission
      if (context.mounted) {
        bool openSettings = await showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Location Permission Required"),
            content: const Text("Please grant location permission to proceed."),
            actions: <Widget>[
              TextButton(
                child: const Text("Open Settings"),
                onPressed: () {
                  Navigator.of(context)
                      .pop(true); // Return true to open settings
                },
              ),
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop(false); // Return false to cancel
                },
              ),
            ],
          ),
        );

        if (openSettings == true) {
          // User chose to open settings, navigate to location settings
          await Geolocator.openAppSettings();
        } else {
          showLoading();

          //  Position locationData = await Geolocator.getCurrentPosition();
          LatLng defaultLatLng = const LatLng(55.170834, -118.794724);

          log("location: ${defaultLatLng.latitude}, ${defaultLatLng.longitude}");
          final loginResult = await doLogin.call(
            emailController.text,
            passwordController.text,
            '${defaultLatLng.latitude},${defaultLatLng.longitude}',
          );

          yield* loginResult.fold(
            (statusCode) async* {
              logMe(statusCode);
              yield LoginFailure(failure: statusCode.message);
            },
            (result) async* {
              if (result != null) {
                yield LoginSuccess(data: result);
              } else {
                yield LoginFailure(failure: appLoc.loginfailure);
              }
            },
          );
        }
      } else {}
    } else {
      showLoading();

      // After handling permission, proceed with getting current location
      Position locationData = await Geolocator.getCurrentPosition();

      log("location: ${locationData.latitude}, ${locationData.longitude}");
      final loginResult = await doLogin.call(
        emailController.text,
        passwordController.text,
        '${locationData.latitude},${locationData.longitude}',
      );

      yield* loginResult.fold(
        (statusCode) async* {
          logMe(statusCode);
          yield LoginFailure(failure: statusCode.message);
        },
        (result) async* {
          if (result != null) {
            yield LoginSuccess(data: result);
          } else {
            yield LoginFailure(failure: appLoc.loginfailure);
          }
        },
      );
    }
  }

  // Stream<LoginState> doLoginApi() async* {
  //   yield LoginLoading();
  //   LocationPermission locationPermission = await Geolocator.checkPermission();
  //   logMe("lcoation permission:-->> $locationPermission");
  //   if (locationPermission == LocationPermission.denied) {
  //     await Geolocator.requestPermission();
  //   } else {
  //     Position locationData = await Geolocator.getCurrentPosition();

  //     log("location :-->> ${locationData.latitude}");
  //     final loginResult = await doLogin.call(
  //         emailController.text,
  //         passwordController.text,
  //         '${locationData.latitude},${locationData.longitude}');
  //     yield* loginResult.fold((statusCode) async* {
  //       logMe(statusCode);
  //       yield LoginFailure(failure: statusCode.message);
  //     }, (result) async* {
  //       if (result != null) {
  //         yield LoginSuccess(data: result);
  //       } else {
  //         yield LoginFailure(failure: appLoc.loginfailure);
  //       }
  //     });
  //   }
  // }
}
