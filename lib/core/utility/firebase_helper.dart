import 'dart:developer';
import 'dart:io';
import 'package:appkey_taxiapp_driver/core/domain/entities/incoming_order.dart';
import 'package:appkey_taxiapp_driver/core/utility/notification_service.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../firebase_options.dart';
import 'helper.dart';
import 'injection.dart';
import 'notification_handler.dart';

class FirebaseHelper {
  static late FirebaseMessaging messaging;

  static Future<void> init() async {
    await Firebase.initializeApp(
        name: 'driver', options: DefaultFirebaseOptions.currentPlatform);
    messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();
    await NotificationHelper().init();

    // messaging.onTokenRefresh.listen((String token) {
    //   print("Refreshed FCM Token: $token");

    //   updateFcmToken(token: token);
    // });
    incomingNotificationHandling();
    /* await permissionHandler().then((authorized) async {
      log("IS AUTHORIZED:  $authorized");

    //  await setupMessaging();
    });*/
  }

/*  static Future<void> setupMessaging() async {
 */ /*   await messaging.getToken().then((token){
      final session = locator<Session>();
      logMe("firebase-token: $token");
      session.setFcmToken = token!;
    });*/ /*
     incomingNotificationHandling();
  }*/

  static void incomingNotificationHandling() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("on message opned called===============>>>>>>>>>>");
      print("on message listen called");
      print("on message listen called");
      print(
          "remote message is------->>>>>.opned ${message.toMap().toString()}");
      fetchRemoteMessage(message);

      NotificationHelper notificationService = NotificationHelper();
      notificationService.showNotifications(message);
      /*  if(notificationEntity.message == SharedPreferenceHelper().getActiveChatId().toString()){
        Utils.printLog("active chat id => ${SharedPreferenceHelper().getActiveChatId()} is same");
        return;
      }*/
      //pushNextScreenFromForeground(notificationEntity);
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

    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      print("token is:  $event");
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

    // if (message.notification!.title == 'New Booking' ||
    //     message.notification!.title == 'Booking Cancelled') {
    // var homeProvider = Provider.of<HomeProvider>(
    //     locator<GlobalKey<NavigatorState>>().currentContext!,
    //     listen: false);
    // final GlobalKey<ScaffoldState> key = GlobalKey();

    // Session session = locator<Session>();
    // if (!session.isOrderRunning) {
    // homeProvider.getRequestListData().listen((event) {
    //   log("event is -->> $event");
    // if (event is RequestListLoaded) {
    //   logMe(
    //       'Request list data loaded success----------> ${event.data.length}');
    // Navigator.pushNamedAndRemoveUntil(
    //     locator<GlobalKey<NavigatorState>>().currentContext!,
    //     HomePage.routeName,
    //     (route) => false);
    // }
    // });
    // }
    // }

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

    //   FirebaseMessaging.instance.onTokenRefresh.listen((token) {
    //   print('FCM Token refreshed: $token');
    //   // Perform actions in response to token refresh
    //   // For example, update the token on your server
    // });
  }

  static Future<void> unsubTopic() async {
    final session = locator<Session>();
    String categoryId = session.sessionCategoryId;
    await messaging.unsubscribeFromTopic("$categoryId-new-order");
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
  log("background message called");

  NotificationHelper notificationService = NotificationHelper();

  notificationService.showNotifications(message);

  //No need for showing Notification manually.
  //For BackgroundMessages: Firebase automatically sends a Notification.
  //If you call the flutterLocalNotificationsPlugin.show()-Methode for
  //example the Notification will be displayed twice.
  return;
  // await Firebase.initializeApp();

  // NotificationHelper notificationService = NotificationHelper();

  // logMe("Handling a background message: ${message.messageId}");
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
      "https://php.parastechnologies.in/taxi/public/api/webservice/driver/update/fcm/token",
      data: params,
      options: Options(
        headers: {"Authorization": "Bearer ${session.sessionToken}"},
      ),
    );

    // Check response status code
    if (res.statusCode == 200) {
      // FCM token updated successfully
      print("FCM Token updated successfully");

      showToast(message: "new fcm token updated");
    } else {
      // Handle other status codes
      print("Failed to update FCM Token: ${res.statusCode}");
    }
  } catch (e) {
    // Handle Dio errors
    print("Error updating FCM Token: $e");
  }
}
