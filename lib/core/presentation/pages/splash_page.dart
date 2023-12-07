import 'dart:async';
import 'dart:developer';
import 'package:app_settings/app_settings.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/pages/create_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart' as hand;
import '../../../features/login/presentation/pages/login_page.dart';
import '../../utility/global_function.dart';
import '../../utility/helper.dart';
import '../../utility/injection.dart';
import '../../utility/session_helper.dart';
import '../providers/currency_state.dart';
import '../providers/socket_provider.dart';
import '../providers/splash_provider.dart';
import 'home_page/home_page.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final socketProvider = locator<SocketProvider>();

  @override
  void initState() {
    super.initState();
    // socketProvider.connectToSocket();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Timer(const Duration(seconds: 2), () async {
        if (await checkPermission()) {
          await sessionClearOrder();

          ///TODO: comment this when APIs will start working
          // Navigator.pushNamedAndRemoveUntil(
          //     context, HomePage.routeName, (route) => false);

          hand.PermissionStatus status =
              await hand.Permission.notification.request();
          if (status.isGranted) {
            log("notification permissin is granetd");

            context
                .read<SplashProvider>()
                .fetchCurrency()
                .listen((state) async {
              // hand.PermissionStatus status =
              //     await hand.Permission.notification.request();
              // if (status.isGranted) {
              //   log("notification permissin is granetd");
              //   // notification permission is granted
              // } else {
              //   // Permission.notification.request();
              //   log("ask for notification permission ");
              //   AppSettings.openAppSettings(type: AppSettingsType.notification);
              //   // Open settings to enable notification permission
              // }
              final session = locator<Session>();
              // log("session token" + session.sessionToken.toString());
              // log("order id" + session.orderId.toString());

              log("state runtime type:==" + state.runtimeType.toString());
              switch (state.runtimeType) {
                case CurrencyLoaded:
                  checkUserSession().then((value) async {
                    if (value) {
                      checkProfileSession().then((value1) {
                        if (value1) {
                          socketProvider.connectToSocket();
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

            // notification permission is granted
          } else {
            // Permission.notification.request();
            log("ask for notification permission ");
            AppSettings.openAppSettings(type: AppSettingsType.notification);
            // Open settings to enable notification permission
          }
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
}






























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
