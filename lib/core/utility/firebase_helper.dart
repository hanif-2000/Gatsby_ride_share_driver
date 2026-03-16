import 'dart:io';
import 'package:appkey_taxiapp_driver/core/domain/entities/incoming_order.dart';
import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../firebase_options.dart';
import 'helper.dart';
import 'injection.dart';
import 'notification_handler.dart';
import 'push_notification_helper.dart';

class FirebaseHelper {


  static Future<void> init() async {
    // Bug Fix 1: Removed name: 'driver' — named instance breaks FirebaseMessaging.instance (uses default app)
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseMessaging.instance.requestPermission();
    await PushNotificationService().init();

    // Bug Fix 5: Listen for FCM token refresh and update server
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      logMe('FCM token refreshed: $newToken');
      final session = locator<Session>();
      if (session.sessionToken.isNotEmpty) {
        updateFcmToken(token: newToken);
      }
    });
  }

  static void fetchRemoteMessage(RemoteMessage message) {
    logMe('fetchRemoteMessage data: ${message.data}');
    final Map<String, dynamic> data = message.data;

    // Fix: Android foreground mein message.notification null ho sakta hai
    // isliye data map se title/body dono platforms pe read karo
    final String? title = data["title"] ?? message.notification?.title;
    final String? body = data["body"] ?? message.notification?.body;
    final String? orderId = data["id_order"];
    final String? clickAction = data["click_action"];

    if (clickAction != null && title != null && body != null && orderId != null) {
      final incomingOrderDetail = IncomingOrderDetail(
          title: title,
          body: body,
          orderId: orderId,
          clickAction: clickAction);
      NotificationHandler.handleNotificationAction(incomingOrderDetail);
    }
  }

  static Future<void> setTopicDriver(String statusOrder) async {
    final session = locator<Session>();
    String categoryId = session.sessionCategoryId;
    if (statusOrder == '1') {
      logMe("subscribeToTopic :");
      logMe("$categoryId-new-order");
      session.setSessionStatusOrder = '1';
      // await messaging.subscribeToTopic(categoryId + "-new-order");
    } else {
      logMe("unsubscribeFromTopic :");
      logMe("$categoryId-new-order");
      session.setSessionStatusOrder = '0';
      // await messaging.unsubscribeFromTopic(categoryId + "-new-order");
    }

  }

  static Future<void> unsubTopic() async {
    final session = locator<Session>();
    String categoryId = session.sessionCategoryId;
    await FirebaseMessaging.instance.unsubscribeFromTopic("$categoryId-new-order");
  }
}



Future<void> updateFcmToken({required String token}) async {
  try {
    var session = locator<Session>();

    var dio = Dio();

    var params = {
      "fcm_token": token,
      "options": [1, 2, 3],
    };

    var res = await dio.post(
      "${BASE_URL}api/webservice/driver/update/fcm/token",
      data: params,
      options: Options(
        headers: {"Authorization": "Bearer ${session.sessionToken}"},
      ),
    );

    // Check response status code
    if (res.statusCode == 200) {
      // FCM token updated successfully
      print("FCM Token updated successfully");

    //  showToast(message: "new fcm token updated");
    } else {
      // Handle other status codes
      print("Failed to update FCM Token: ${res.statusCode}");
    }
  } catch (e) {
    // Handle Dio errors
    print("Error updating FCM Token: $e");
  }
}
