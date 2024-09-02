import 'dart:developer';
import 'dart:io';
import 'package:appkey_taxiapp_driver/core/domain/entities/incoming_order.dart';
import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_driver/core/utility/notification_service.dart';
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
    await Firebase.initializeApp(name: 'driver', options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseMessaging.instance.requestPermission();
    await PushNotificationService().init();
   // await NotificationHelper().init();
   // incomingNotificationHandling();
  }

  static void incomingNotificationHandling() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("on message opned called===============>>>>>>>>>>");
      print("on message listen called");
      print("on message listen called");
      print("remote message is------->>>>>.opned ${message.toMap().toString()}");
      fetchRemoteMessage(message);
      NotificationHelper notificationService = NotificationHelper();
      notificationService.showNotifications(message);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final session = locator<Session>();
      if (session.sessionToken.isEmpty) {
        return;
      }
      log("on message listen called");
      print("on message listen called");
      log("remote message is------->>>>>.listen ${message.toMap().toString()}");
      fetchRemoteMessage(message);
      NotificationHelper notificationService = NotificationHelper();
      notificationService.showNotifications(message);
    });

  }

  static fetchRemoteMessage(RemoteMessage message) {
    // Booking Cancelled//
    //New Order

    print("notification titilew is---->> $message");
    log("notification category :${message.category}");
    log("notification collapseKey :${message.collapseKey}");
    log("notification contentAvailable :${message.contentAvailable}");
    log("notification data :${message.data}");
    log("notification contains key startiung point  :${message.data.containsKey('Starting point')}");
    log("notification Destination :${message.data['Destination']}");
    log("notification from :${message.from}");
    log("notification messageId :${message.messageId}");
    log("notification messageType :${message.messageType}");
    log("notification mutableContent :${message.mutableContent}");
    log("notification notification :${message.notification}");
    log("notification senderId :${message.senderId}");
    log("notification sentTime :${message.sentTime}");
    log("notification threadId :${message.threadId}");
    log("notification ttl :${message.ttl}");
    log("remote message called");
    logMe('data: ${message.data}');
    String? title;
    String? body;
    String? orderId;
    String? clickAction;
    final Map<String, dynamic> data = message.data;
    if (Platform.isIOS) {
      title = data["title"];
      body = data["body"];
      orderId = data["id_order"];
      clickAction = data["click_action"];
    } else if (Platform.isAndroid) {
      final RemoteNotification? notification = message.notification;
      title = notification?.title;
      body = notification?.body;
      orderId = data["id_order"];
      clickAction = data["click_action"];
    }

    if (clickAction != null) {
      final incomingOrderDetail = IncomingOrderDetail(
          title: title!,
          body: body!,
          orderId: orderId!,
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
