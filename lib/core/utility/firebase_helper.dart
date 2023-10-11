import 'dart:developer';
import 'dart:io';
import 'package:appkey_taxiapp_driver/core/domain/entities/incoming_order.dart';
import 'package:appkey_taxiapp_driver/core/utility/notification_service.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../firebase_options.dart';
import '../presentation/pages/home_page/home_page.dart';
import '../presentation/providers/home_provider.dart';
import '../presentation/providers/request_list_state.dart';
import 'helper.dart';
import 'injection.dart';
import 'notification_handler.dart';
import 'package:provider/provider.dart';

class FirebaseHelper {
  static late FirebaseMessaging messaging;

  static Future<void> init() async {
    await Firebase.initializeApp();
    logMe("Firebasee helperrrr");
    await Firebase.initializeApp(
        name: 'driver', options: DefaultFirebaseOptions.currentPlatform);
    messaging = FirebaseMessaging.instance;

    await permissionHandler().then((authorized) async {
      log("IS AUTHORIZED:  $authorized");
      if (authorized) {
        await NotificationHelper().init();

        await setupMessaging();
      }
    });
  }

  static Future<void> setupMessaging() async {
    await messaging.getToken().then((token) async {
      final session = locator<Session>();
      logMe("firebase-token: $token");
      session.setFcmToken = token!;
    });
    await incomingNotificationHandling();
  }

  static Future<void> incomingNotificationHandling() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("on message listen called");
      fetchRemoteMessage(message);
      NotificationHelper _notificationService = NotificationHelper();
      _notificationService.showNotifications(message);
    });
  }

  static fetchRemoteMessage(RemoteMessage message) {
    log("remote message called");

    var homeProvider = Provider.of<HomeProvider>(
        locator<GlobalKey<NavigatorState>>().currentContext!,
        listen: false);
    // final GlobalKey<ScaffoldState> key = GlobalKey();
    homeProvider.getRequestListData().listen((event) {
      log("event is -->> $event");
      if (event is RequestListLoaded) {
        logMe(
            'Request list data loaded success----------> ${event.data.length}');
        Navigator.pushNamedAndRemoveUntil(
            locator<GlobalKey<NavigatorState>>().currentContext!,
            HomePage.routeName,
            (route) => false);
      }
    });

    logMe('data: ${message.data}');
    late String? title;
    late String? body;
    late String? orderId;
    late String? clickAction;
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
      final _incomingOrderDetail = IncomingOrderDetail(
          title: title!,
          body: body!,
          orderId: orderId!,
          clickAction: clickAction);
      NotificationHandler.handleNotificationAction(_incomingOrderDetail);
    }
  }

  static Future<void> setTopicDriver(String statusOrder) async {
    final session = locator<Session>();
    String categoryId = session.sessionCategoryId;
    if (statusOrder == '1') {
      logMe("subscribeToTopic :");
      logMe(categoryId + "-new-order");
      session.setSessionStatusOrder = '1';
      await messaging.subscribeToTopic(categoryId + "-new-order");
    } else {
      logMe("unsubscribeFromTopic :");
      logMe(categoryId + "-new-order");
      session.setSessionStatusOrder = '0';
      await messaging.unsubscribeFromTopic(categoryId + "-new-order");
    }
  }

  static Future<void> unsubTopic() async {
    final session = locator<Session>();
    String categoryId = session.sessionCategoryId;
    await messaging.unsubscribeFromTopic(categoryId + "-new-order");
  }

  static Future<bool> permissionHandler() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    logMe('User granted permission: ${settings.authorizationStatus}');
    return settings.authorizationStatus == AuthorizationStatus.authorized;
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  logMe("Handling a background message: ${message.messageId}");
}
