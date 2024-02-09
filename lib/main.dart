import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/splash_provider.dart';
import 'package:appkey_taxiapp_driver/features/about_us/presentation/providers/aboutus_provider.dart';
import 'package:appkey_taxiapp_driver/features/history/presentation/providers/history_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/change_email_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/change_password_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

import 'core/presentation/pages/splash_page.dart';
import 'core/presentation/providers/place_picker_provider.dart';
import 'core/routes/route.dart';
import 'core/static/colors.dart';
import 'core/utility/firebase_helper.dart';
import 'core/utility/helper.dart';
import 'core/utility/injection.dart';
import 'core/utility/session_helper.dart';
import 'features/profile/presentation/providers/profile_edit_provider.dart';

// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await init();
    locator.isReady<Session>().then((_) async {
      await FirebaseHelper.init();

      // await FirebaseHelper.init().then((_) async {
      //   // await NotificationHelper().init();
      // });--------
      // await NotificationHelper().init();
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SplashProvider>(
              create: (context) => locator<SplashProvider>(),
            ),
            ChangeNotifierProvider<LatestSocketProvider>(
              create: (_) => locator<LatestSocketProvider>(),
            ),

            ChangeNotifierProvider<HomeProvider>(
              create: (context) => locator<HomeProvider>(),
            ),
            // ChangeNotifierProvider<OrderProvider>(
            //   create: (context) => locator<OrderProvider>(),
            // ),
            ChangeNotifierProvider<PlacePickerProvider>(
              create: (context) => locator<PlacePickerProvider>(),
            ),
            ChangeNotifierProvider<AboutUsProvider>(
              create: (context) => locator<AboutUsProvider>(),
            ),
            ChangeNotifierProvider<ProfileProvider>(
              create: (context) => locator<ProfileProvider>(),
            ),
            ChangeNotifierProvider<HistoryProvider>(
              create: (context) => locator<HistoryProvider>(),
            ),
            ChangeNotifierProvider<ProfileEditProvider>(
              create: (context) => locator<ProfileEditProvider>(),
            ),
            ChangeNotifierProvider<ChangeEmailProvider>(
              create: (context) => locator<ChangeEmailProvider>(),
            ),
            ChangeNotifierProvider<ChangePasswordProvider>(
              create: (context) => locator<ChangePasswordProvider>(),
            ),
            // ChangeNotifierProvider<ChatProvider>(
            //   create: (context) => locator<ChatProvider>(),
            // ),
          ],
          builder: (context, _) => const MyApp(),
        ),
      );
    });
  } catch (e) {
    logMe(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: locator<GlobalKey<NavigatorState>>(),
        title: 'GatsByRideShare',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: primaryColor,
          ),
          useMaterial3: false,
          unselectedWidgetColor: grey7c7c7c,
          fontFamily: 'Poppins',
        ),
        // navigatorObservers: [routeObserver],
        navigatorObservers: [routeObserver],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
        ],
        // Initialize routes
        onGenerateRoute: generateRoute,
        home: const SplashPage(),
        debugShowCheckedModeBanner: false,
        builder: FlutterSmartDialog.init());
  }
}
