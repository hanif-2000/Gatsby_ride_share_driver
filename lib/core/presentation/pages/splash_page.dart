import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:appkey_taxiapp_driver/core/data/models/booking_data_model.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/push_notification_helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/pages/create_profile.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:appkey_taxiapp_driver/l10n/app_localizations.dart';
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



  @override
  void initState(){
    super.initState();
    //getPushNotificationRoute();
    WidgetsBinding.instance.addObserver(this);
    Timer(const Duration(seconds: 3), () async {
      bool requestPermission = await checkLocationAndPermission();
      log("Request permission value: $requestPermission");
      if (!requestPermission) {
        requestPermission = await checkLocationAndPermission();
        logMe("Rechecked location and permission value: $requestPermission");
      }
      await _getDataFromNotification();
      await sessionClearOrder();
      bool isSessionValid = await checkUserSession();
      if (isSessionValid) {
        bool hasProfile = await checkProfileSession();
        if (hasProfile) {
          var session = locator<Session>();
          var homeProvider = locator<HomeProvider>();
          homeProvider.changeStatus = session.isOnline;
          Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
          logMe("Is driver online: ${session.isOnline}");
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
 FutureOr<String?> _getDataFromNotification()async{
    final data = await PushNotificationService().getPushNotificationRoute();
    return data?.$1;
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
