import 'dart:async';

import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/splash_provider.dart';
import 'package:appkey_taxiapp_driver/features/about_us/presentation/providers/aboutus_provider.dart';
import 'package:appkey_taxiapp_driver/features/history/presentation/providers/history_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/change_email_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/change_password_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/profile_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appkey_taxiapp_driver/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

import 'core/network/socket_helper.dart';
import 'core/presentation/pages/splash_page.dart';
import 'core/presentation/providers/place_picker_provider.dart';
import 'core/routes/route.dart';
import 'core/static/colors.dart';
import 'core/utility/firebase_helper.dart';
import 'core/utility/helper.dart';
import 'core/utility/injection.dart';
import 'core/utility/session_helper.dart';
import 'features/profile/presentation/providers/profile_edit_provider.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

// Bug Fix 2: Background message handler — must be top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  logMe('Background FCM message received: ${message.data}');
}

void main() {
  // Run everything in the same guarded zone
  runZonedGuarded(() async {
    // Ensure Flutter is initialized - INSIDE the zone
    WidgetsFlutterBinding.ensureInitialized();
    
    // Set preferred orientations
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, 
      DeviceOrientation.portraitDown
    ]);

    // Global error handling for Flutter errors
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      logMe('FlutterError: ${details.exception}');
      logMe('Stack: ${details.stack}');
    };

    // Handle errors outside Flutter framework
    PlatformDispatcher.instance.onError = (error, stack) {
      logMe('PlatformError: $error');
      logMe('Stack: $stack');
      return true;
    };

    try {
      // Initialize dependency injection
      await init();
      logMe('Injection initialized');

      // Wait for Session to be ready
      await locator.isReady<Session>();
      logMe('Session ready');

      // Bug Fix 2: Register background handler before Firebase.init
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Initialize Firebase
      await FirebaseHelper.init();
      logMe('Firebase initialized');

      // Connect WebSocket
      WebSocketHelper().connect();
      logMe('WebSocket connecting');

      // Run the app
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SplashProvider>(
              create: (context) => locator<SplashProvider>(),
            ),
            ChangeNotifierProvider<LatestSocketProvider>(
              create: (_) => LatestSocketProvider(),
            ),
            ChangeNotifierProvider<HomeProvider>(
              create: (context) => locator<HomeProvider>(),
            ),
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
          ],
          builder: (context, _) => const MyApp(),
        ),
      );
    } catch (e, stackTrace) {
      logMe('FATAL INITIALIZATION ERROR: $e');
      logMe('Stack: $stackTrace');
      
      // Show error app instead of black screen
      runApp(ErrorApp(error: e.toString()));
    }
  }, (error, stackTrace) {
    logMe('Uncaught Error: $error');
    logMe('Stack: $stackTrace');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
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
      onGenerateRoute: generateRoute,
      home: const SplashPage(),
      debugShowCheckedModeBanner: false,
      builder: FlutterSmartDialog.init(),
    );
  }
}

// Error App to show when initialization fails
class ErrorApp extends StatelessWidget {
  final String error;
  
  const ErrorApp({super.key, required this.error});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 24),
                const Text(
                  'App Initialization Failed',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                const Text(
                  'Please restart the app or contact support.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}