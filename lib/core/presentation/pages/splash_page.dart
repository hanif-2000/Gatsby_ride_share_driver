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
  Future<dartz.Tuple2<String, Object>?> getPushNotificationRoute() async {
    RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    // final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    const NotificationAppLaunchDetails? notificationAppLaunchDetails = null;
    NotificationRideModel? entity;
    if (remoteMessage != null && remoteMessage.data.isNotEmpty) {
      print("RemoteMessage data  ${remoteMessage.data}");
      // print("RemoteMessage data  ${(remoteMessage.data)}");
      // print("RemoteMessage data  ${(remoteMessage.data["id"]["id"])}");

      // NotificationRideModel notificationEntity =
      //     NotificationRideModel.fromJson(remoteMessage.data);

      if (remoteMessage.data["notificationTypeId"] == "CustomerBookRequest") {
        // showToast(message: "RIDE DATA IN NOTIFICATION CALLED");
        var myData = json.decode(remoteMessage.data["id"]);

        var dio = Dio();

        var session = locator<Session>();

        var headers = {'Authorization': 'Bearer ${session.sessionToken}'};

        var response = await dio.request(
          'https://api.gatsbyrideshare.com/api/webservice/driver/order/status/${myData["id"]}',
          options: Options(
            method: 'GET',
            headers: headers,
          ),
        );

        if (response.statusCode == 200) {
          print(json.encode(response.data));

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
                customerRating: myData["CustomerRating"].toString()));
          }
        } else {
          print(response.statusMessage);
        }

        log("notification ride id :-->> $myData");
      }
      // NotificationRideModel notificationEntity =
      //     NotificationRideModel.fromJson(remoteMessage.data);
      // // entity = NotificationRideModel();
      // entity.title = remoteMessage.data['title'];
      // entity.body = remoteMessage.data['body'];
      // entity.type = remoteMessage.data['type'];
      // return await callApi(notificationEntity);
    } else if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp == true) {
      // NotificationRideModel? entity = convertStringToNotificationEntity(
      //     notificationAppLaunchDetails.notificationResponse?.payload);
      return null;
    } else {
      return null;
    }
    return null;
  }

  final socketProvider = locator<LatestSocketProvider>();

  // Provider.of<LatestSocketProvider>(
  //     locator<GlobalKey<NavigatorState>>().currentContext!);

  // Future<Tuple2<String, Object>?> getPushNotificationRoute() async {
  //   RemoteMessage? remoteMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();
  //   //   final NotificationAppLaunchDetails? notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  //   const NotificationAppLaunchDetails? notificationAppLaunchDetails = null;
  //   NotificationEntity? entity;
  //   if (remoteMessage != null && remoteMessage.data.isNotEmpty) {
  //     print("RemoteMessage data  ${remoteMessage.data}");
  //     NotificationEntity notificationEntity =
  //         NotificationEntity.fromJson(remoteMessage.data);
  //     entity = NotificationEntity();
  //     entity.title = remoteMessage.data['title'];
  //     entity.body = remoteMessage.data['body'];
  //     entity.type = remoteMessage.data['type'];
  //     return await callApi(notificationEntity);
  //   } else if (notificationAppLaunchDetails != null &&
  //       notificationAppLaunchDetails.didNotificationLaunchApp == true) {
  //     NotificationEntity? entity = convertStringToNotificationEntity(
  //         notificationAppLaunchDetails.notificationResponse?.payload);
  //     if (entity != null) {
  //       print("RemoteMessage data ${entity.toJson()}");
  //       // return await callApi(entity);
  //     } else {
  //       return null;
  //     }
  //   } else {
  //     return null;
  //   }
  //   return null;
  // }

  @override
  void initState() {
    super.initState();
    getPushNotificationRoute();

    WidgetsBinding.instance.addObserver(this);
    Timer(const Duration(seconds: 3), () async {
      final requestPermission = await checkLocationAndPermission();
      log("request permission value is:-->> $requestPermission");
      if (requestPermission == false) {
        await checkLocationAndPermission().then((value) async {
          print("check location and permission value is:$value");
          if (value) {
            Position currentLatLng = await Geolocator.getCurrentPosition();

            // print(
            //     "**********------------ ${currentLatLng.latitude},${currentLatLng.longitude} ----------*********");

            await sessionClearOrder();
            context
                .read<SplashProvider>()
                .fetchCurrency()
                .listen((state) async {
              log("state runtime type:==${state.runtimeType}");
              switch (state.runtimeType) {
                case CurrencyLoaded:
                  checkUserSession().then((value) async {
                    //   sessionHelper.setCurrentLat = currentLatLng.latitude;
                    //   sessionHelper.setCurrentLang = currentLatLng.longitude;
                    if (value) {
                      checkProfileSession().then((value1) {
                        if (value1) {
                          var session = locator<Session>();
                          print("IS DRIVER ONLINE : ${session.isOnline}");
                          //   socketProvider.connectToSocket(context);
                          Navigator.pushNamedAndRemoveUntil(
                              context, HomePage.routeName, (route) => false);
                        } else {
                          Navigator.pushNamedAndRemoveUntil(context,
                              CreateProfilePage.routeName, (route) => false);
                        }
                      });
                    } else {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.routeName, (route) => false);
                    }
                  });
                  break;
              }
            });
          } else {
            return;
          }
        });
      } else {
        await sessionClearOrder();
        context.read<SplashProvider>().fetchCurrency().listen((state) async {
          log("state runtime type:==${state.runtimeType}");
          switch (state.runtimeType) {
            case CurrencyLoaded:
              checkUserSession().then((value) async {
                if (value) {
                  checkProfileSession().then((value1) {
                    if (value1) {
                      var session = locator<Session>();
                      print("IS DRIVER ONLINE -: ${session.isOnline}");

                      var homeProvider = locator<HomeProvider>();
                      homeProvider.changeStatus = session.isOnline;

                      //  socketProvider.connectToSocket(context);
                      Navigator.pushNamedAndRemoveUntil(
                          context, HomePage.routeName, (route) => false);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(context,
                          CreateProfilePage.routeName, (route) => false);
                    }
                  });
                } else {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginPage.routeName, (route) => false);
                }
              });
              break;
          }
        });
      }

      // if (await checkPermission()) {
      //   await sessionClearOrder();

      //   ///TODO: comment this when APIs will start working
      //   // Navigator.pushNamedAndRemoveUntil(
      //   //     context, HomePage.routeName, (route) => false);

      //   hand.PermissionStatus status =
      //       await hand.Permission.notification.request();
      //   if (status.isGranted) {
      //     log("notification permissin is granetd");

      //     context
      //         .read<SplashProvider>()
      //         .fetchCurrency()
      //         .listen((state) async {
      //       // hand.PermissionStatus status =
      //       //     await hand.Permission.notification.request();
      //       // if (status.isGranted) {
      //       //   log("notification permissin is granetd");
      //       //   // notification permission is granted
      //       // } else {
      //       //   // Permission.notification.request();
      //       //   log("ask for notification permission ");
      //       //   AppSettings.openAppSettings(type: AppSettingsType.notification);
      //       //   // Open settings to enable notification permission
      //       // }
      //       final session = locator<Session>();
      //       // log("session token" + session.sessionToken.toString());
      //       // log("order id" + session.orderId.toString());

      //       log("state runtime type:==" + state.runtimeType.toString());
      //       switch (state.runtimeType) {
      //         case CurrencyLoaded:
      //           checkUserSession().then((value) async {
      //             if (value) {
      //               checkProfileSession().then((value1) {
      //                 if (value1) {
      //                   socketProvider.connectToSocket();
      //                   Navigator.pushNamedAndRemoveUntil(
      //                       context, HomePage.routeName, (route) => false);
      //                 } else {
      //                   Navigator.pushNamedAndRemoveUntil(context,
      //                       CreateProfilePage.routeName, (route) => false);
      //                 }
      //               });
      //             } else {
      //               Navigator.pushNamedAndRemoveUntil(
      //                   context, LoginPage.routeName, (route) => false);
      //             }
      //           });
      //           break;
      //       }
      //     });

      //     // notification permission is granted
      //   } else {
      //     // Permission.notification.request();
      //     log("ask for notification permission ");
      //     await AppSettings.openAppSettings(
      //         type: AppSettingsType.notification);

      //     // Open settings to enable notification permission
      //   }
      // }
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
        print("sdfInactive");
        break;
      case AppLifecycleState.paused:
        print("Paused");
        break;
      case AppLifecycleState.resumed:
        if (await Permission.notification.request().isGranted) {
          log("notification is granted");
          //notifications permission is granted do some stuff
        } else {
          log("notification is not granted");
        }
        print("Resumed");
        break;

      case AppLifecycleState.detached:
        print("detached");

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
        // double imgHeight = constraints.maxWidth * 0.5;
        // double imgWidth = imgHeight;
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

          // Center(
          //   child: Hero(
          //     tag: "taxiIcon",
          //     child: Image.asset(
          //       logoSplash,
          //       height: imgHeight,
          //       width: imgWidth,
          //     ),
          //   ),
          // ),
        );
      },
    );
  }
  // return null;
// }

// import 'dart:async';
// import 'dart:developer';
// import 'package:app_settings/app_settings.dart';
// import 'package:appkey_taxiapp_driver/core/static/colors.dart';
// import 'package:appkey_taxiapp_driver/features/create_profile/presentation/pages/create_profile.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import '../../../features/login/presentation/pages/login_page.dart';
// import '../../utility/global_function.dart';
// import '../../utility/helper.dart';
// import '../../utility/injection.dart';
// import '../../utility/session_helper.dart';
// import '../providers/currency_state.dart';
// import '../providers/socket_provider.dart';
// import '../providers/splash_provider.dart';
// import 'home_page/home_page.dart';
// import 'package:provider/provider.dart';
// import 'package:permission_handler/permission_handler.dart' as hand;

// class SplashPage extends StatefulWidget {
//   const SplashPage({Key? key}) : super(key: key);
//   static const routeName = '/splash';

//   @override
//   State<SplashPage> createState() => _SplashPageState();
// }

// class _SplashPageState extends State<SplashPage> {
//   final socketProvider = locator<SocketProvider>();

//   @override
//   void initState() {
//     super.initState();
//     // socketProvider.connectToSocket();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       Timer(const Duration(seconds: 2), () async {
//         await sessionClearOrder();
//         if (await checkPermission()) {
//           await sessionClearOrder();

//           var notificationPermission;

//           hand.Permission.notification.status.then((value) {
//             log("permiiiiii-->> $value");

//             if (value.isGranted) {
//               context
//                   .read<SplashProvider>()
//                   .fetchCurrency()
//                   .listen((state) async {
//                 // hand.PermissionStatus status =
//                 //     await hand.Permission.notification.request();
//                 // if (status.isGranted) {
//                 //   log("notification permissin is granetd");
//                 //   // notification permission is granted
//                 // } else {
//                 //   // Permission.notification.request();
//                 //   log("ask for notification permission ");
//                 //   AppSettings.openAppSettings(type: AppSettingsType.notification);
//                 //   // Open settings to enable notification permission
//                 // }
//                 final session = locator<Session>();
//                 // log("session token" + session.sessionToken.toString());
//                 // log("order id" + session.orderId.toString());

//                 log("state runtime type:==" + state.runtimeType.toString());

//                 log("socket chat token is:-->> ${session.chatToken}");
//                 switch (state.runtimeType) {
//                   case CurrencyLoaded:
//                     checkUserSession().then((value) async {
//                       log("check user session is-->> $value");
//                       if (value) {
//                         checkProfileSession().then((value1) {
//                           log("create profile pending??-->> $value1");
//                           if (value1) {
//                             socketProvider.connectToSocket();
//                             Navigator.pushNamedAndRemoveUntil(
//                                 context, HomePage.routeName, (route) => false);
//                           } else {
//                             Navigator.pushNamedAndRemoveUntil(context,
//                                 CreateProfilePage.routeName, (route) => false);
//                           }
//                         });
//                       } else {
//                         Navigator.pushNamedAndRemoveUntil(
//                             context, LoginPage.routeName, (route) => false);
//                       }
//                     });
//                     break;
//                 }
//               });
//             } else if (value == hand.PermissionStatus.permanentlyDenied) {
//               AppSettings.openAppSettings(type: AppSettingsType.notification);
//             } else if (value == hand.PermissionStatus.denied) {
//               AppSettings.openAppSettings(type: AppSettingsType.notification);
//             }
//             // else if(
//             // value==hand.PermissionStatus.permanentlyDenied

//             // ){
//             // }
//             else {
//               var status = hand.Permission.notification.request();
//               if ((status == hand.PermissionStatus.denied) ||
//                   (status == hand.PermissionStatus.permanentlyDenied)) {
//                 AppSettings.openAppSettings(type: AppSettingsType.notification);
//               }
//             }
//           });

//           // var check = await hand.Permission.notification.status;
//           // log("notification check -->> $check");

//           // if (check == hand.PermissionStatus.denied) {
//           //   check = await hand.Permission.notification.request();

//           //   log("notification check -->>2 is : $check");
//           // }

//           ///TODO: comment this when APIs will start working
//           // Navigator.pushNamedAndRemoveUntil(
//           //     context, HomePage.routeName, (route) => false);

//           // hand.PermissionStatus status =
//           //     await hand.Permission.notification.request();

//           // log("notification status is:-->> $status");

//           // if (status.isGranted) {
//           //   log("notification permissin is granetd");

//           context.read<SplashProvider>().fetchCurrency().listen((state) async {
//             // hand.PermissionStatus status =
//             //     await hand.Permission.notification.request();
//             // if (status.isGranted) {
//             //   log("notification permissin is granetd");
//             //   // notification permission is granted
//             // } else {
//             //   // Permission.notification.request();
//             //   log("ask for notification permission ");
//             //   AppSettings.openAppSettings(type: AppSettingsType.notification);
//             //   // Open settings to enable notification permission
//             // }
//             final session = locator<Session>();
//             // log("session token" + session.sessionToken.toString());
//             // log("order id" + session.orderId.toString());

//             log("state runtime type:==" + state.runtimeType.toString());
//             switch (state.runtimeType) {
//               case CurrencyLoaded:
//                 checkUserSession().then((value) async {
//                   if (value) {
//                     checkProfileSession().then((value1) {
//                       if (value1) {
//                         socketProvider.connectToSocket();
//                         Navigator.pushNamedAndRemoveUntil(
//                             context, HomePage.routeName, (route) => false);
//                       } else {
//                         Navigator.pushNamedAndRemoveUntil(context,
//                             CreateProfilePage.routeName, (route) => false);
//                       }
//                     });
//                   } else {
//                     Navigator.pushNamedAndRemoveUntil(
//                         context, LoginPage.routeName, (route) => false);
//                   }
//                 });
//                 break;
//             }
//           });

//           // notification permission is granted
//           // } else if (status.isPermanentlyDenied) {
//           //   // Permission.notification.request();
//           //   // log("ask for notification permission ");
//           //   // AppSettings.openAppSettings(type: AppSettingsType.notification);
//           //   // Open settings to enable notification permission
//           // }
//         } else {
//           AppSettings.openAppSettings(type: AppSettingsType.location);
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     appLoc = AppLocalizations.of(context)!;
//     myLocale = Localizations.localeOf(context);
//     sessionHelper = locator<Session>();

//     return LayoutBuilder(
//       builder: (context, constraints) {
//         // double imgHeight = constraints.maxWidth * 0.5;
//         // double imgWidth = imgHeight;
//         return Container(
//           height: constraints.maxHeight,
//           width: constraints.maxWidth,
//           color: whiteColor,
//           child: Stack(
//             children: [
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Center(
//                     child: SvgPicture.asset(
//                       'assets/images/splash_logo.svg',
//                       height: 110,
//                     ),
//                   ),
//                 ],
//               ),
//               Positioned(
//                 bottom: 0,
//                 child: SvgPicture.asset(
//                   'assets/images/splash_car.svg',
//                   // height: 170,
//                   width: constraints.maxWidth,
//                 ),
//               ),
//             ],
//           ),

//           // Center(
//           //   child: Hero(
//           //     tag: "taxiIcon",
//           //     child: Image.asset(
//           //       logoSplash,
//           //       height: imgHeight,
//           //       width: imgWidth,
//           //     ),
//           //   ),
//           // ),
//         );
//       },
//     );
//   }
// }
}
