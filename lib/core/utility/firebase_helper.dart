import 'dart:developer';
import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'injection.dart';
import 'push_notification_helper.dart';

class FirebaseHelper {
  static Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    await PushNotificationService().init();

    // Save token on startup (after login session is ready)
    _sendTokenWhenReady();

    // Refresh token whenever it changes
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      log("FCM Token refreshed: $newToken");
      await updateFcmToken(token: newToken);
    });
  }

  // Waits up to 5s for APNS token, then sends FCM token to server
  static Future<void> _sendTokenWhenReady() async {
    String token = '';
    for (int i = 0; i < 5; i++) {
      try {
        token = await FirebaseMessaging.instance.getToken() ?? '';
      } catch (_) {}
      if (token.isNotEmpty) break;
      await Future.delayed(const Duration(seconds: 1));
    }
    if (token.isNotEmpty) {
      log("FCM Token on startup: $token");
      await updateFcmToken(token: token);
    }
  }

  static Future<void> setTopicDriver(String statusOrder) async {
    final session = locator<Session>();
    String categoryId = session.sessionCategoryId;
    if (statusOrder == '1') {
      session.setSessionStatusOrder = '1';
      log("subscribeToTopic: $categoryId-new-order");
    } else {
      session.setSessionStatusOrder = '0';
      log("unsubscribeFromTopic: $categoryId-new-order");
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
    final session = locator<Session>();
    if (session.sessionToken.isEmpty) return;

    final dio = Dio();
    final res = await dio.post(
      "${BASE_URL}api/webservice/driver/update/fcm/token",
      data: {
        "fcm_token": token,
        "options": [1, 2, 3],
      },
      options: Options(
        headers: {"Authorization": "Bearer ${session.sessionToken}"},
      ),
    );

    if (res.statusCode == 200) {
      log("FCM Token updated successfully");
    } else {
      log("Failed to update FCM Token: ${res.statusCode}");
    }
  } catch (e) {
    log("Error updating FCM Token: $e");
  }
}
