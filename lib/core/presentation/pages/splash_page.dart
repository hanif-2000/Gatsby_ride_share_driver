import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:appkey_taxiapp_driver/core/data/models/booking_data_model.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/pages/create_profile.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as hand;
import 'package:permission_handler/permission_handler.dart';
import '../../../features/login/presentation/pages/login_page.dart';
import '../../data/models/socket_response_model/notification_ride_model.dart';
import '../../utility/global_function.dart';
import '../../utility/helper.dart';
import '../../utility/injection.dart';
import '../../utility/session_helper.dart';
import '../providers/currency_state.dart';
import '../providers/splash_provider.dart';
import 'home_page/home_page.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with WidgetsBindingObserver {

  Future<void> getPushNotificationRoute() async {
    try {
      RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
      const NotificationAppLaunchDetails? notificationAppLaunchDetails = null;

      if (remoteMessage != null && remoteMessage.data.isNotEmpty) {
        logMe("RemoteMessage data: ${remoteMessage.data}");

        if (remoteMessage.data["notificationTypeId"] == "CustomerBookRequest") {
          // Decode data
          var myData = json.decode(remoteMessage.data["id"]);

          // Setup Dio
          var dio = Dio();
          var session = locator<Session>();
          var headers = {'Authorization': 'Bearer ${session.sessionToken}'};

          // Fetch ride status
          var response = await dio.get(
            'https://api.gatsbyrideshare.com/api/webservice/driver/order/status/${myData["id"]}',
            options: Options(headers: headers),
          );

          if (response.statusCode == 200) {
            logMe(json.encode(response.data));
            if (response.data["data"]["status"] == 0) {
              socketProvider.updateRideList(Booking(
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
              ));
            }
          } else {
            logMe(response.statusMessage);
          }

          log("Notification ride ID: $myData");
        }
      }
    } catch (e) {
      logMe("Error in getPushNotificationRoute: $e");
    }
  }

  final socketProvider = locator<LatestSocketProvider>();

  @override
  void initState(){
    super.initState();
    getPushNotificationRoute();
    WidgetsBinding.instance.addObserver(this);
    Timer(const Duration(seconds: 3), () async {
      bool requestPermission = await checkLocationAndPermission();
      log("Request permission value: $requestPermission");

      if (!requestPermission) {
        requestPermission = await checkLocationAndPermission();
        logMe("Rechecked location and permission value: $requestPermission");
      }

      await sessionClearOrder();
      bool isSessionValid = await checkUserSession();
      if (isSessionValid) {
        bool hasProfile = await checkProfileSession();
        if (hasProfile) {
          var session = locator<Session>();
          logMe("Is driver online: ${session.isOnline}");
          var homeProvider = locator<HomeProvider>();
          homeProvider.changeStatus = session.isOnline;

          Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(context, CreateProfilePage.routeName, (route) => false);
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, (route) => false);
      }
    });
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
        logMe("sdfInactive");
        break;
      case AppLifecycleState.paused:
        logMe("Paused");
        break;
      case AppLifecycleState.resumed:
        if (await Permission.notification.request().isGranted) {
          log("notification is granted");
          //notifications permission is granted do some stuff
        } else {
          log("notification is not granted");
        }
        logMe("Resumed");
        break;

      case AppLifecycleState.detached:
        logMe("detached");

        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    appLoc = AppLocalizations.of(context)!;
    myLocale = Localizations.localeOf(context);
    sessionHelper = locator<Session>();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          color: whiteColor,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/splash_logo.svg',
                      height: 110,
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0,
                child: SvgPicture.asset(
                  'assets/images/splash_car.svg',
                  // height: 170,
                  width: constraints.maxWidth,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
