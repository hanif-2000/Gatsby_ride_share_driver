import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../data/models/notification_entity.dart';
import '../presentation/providers/latest_socket_provider.dart';
import 'injection.dart';
import 'session_helper.dart';

class PushNotificationService {
  static final PushNotificationService _notificationService = PushNotificationService._internal();
  static const JsonDecoder _decoder = JsonDecoder();
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  factory PushNotificationService() {
    return _notificationService;
  }

  PushNotificationService._internal();

  /// Create a [AndroidNotificationChannel] for heads up notifications
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,

  );

  final BehaviorSubject<String?> _selectNotificationSubject = BehaviorSubject<String?>();

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final session = locator<Session>();
  Future<void> init() async {
    _configureSelectNotificationSubject();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: null,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        if (notificationResponse.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          _selectNotificationSubject.add(notificationResponse.payload);
        }
      },
    );

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _initFirebaseListeners();
  }

  void _configureSelectNotificationSubject() {
    _selectNotificationSubject.stream.listen((String? payload) async {
      if (session.userId.isEmpty) {
        return;
      }
      NotificationEntity? entity = convertStringToNotificationEntity(payload);
      print("notification _configureSelectNotificationSubject ${entity.toString()}");
      if (entity != null) {
        _pushNextScreenFromForeground(entity);
      }
    });
  }

  Future? _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    if (session.userId.isEmpty) {
      return null;
    }
    NotificationEntity? entity = convertStringToNotificationEntity(payload);
    print("notification onDidReceiveLocalNotification ${entity.toString()}");
    if (entity != null) {
      _pushNextScreenFromForeground(entity);
    }
    return null;
  }

  void _initFirebaseListeners() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (session.userId.isEmpty) {
        print("userToken is Null");
        return;
      }
      print("IOS Foreground notification opened: ${message.data}");
      NotificationEntity notificationEntity = NotificationEntity.fromJson(message.data);
      _pushNextScreenFromForeground(notificationEntity);
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (session.userId.isEmpty) return;
      // Agar FCM message mein notification field hai to iOS already system notification dikha raha hai
      // Dobara local notification mat banao — duplicate hogi
      if (message.notification != null) return;
      // Ride request FCM data-only messages bhi ignore karo
      final type = (message.data['type'] ?? message.data['serviceType'] ?? '').toString();
      if (type == 'CustomerBookRequest') return;
      print("Foreground data-only notification: ${message.data}");
      NotificationEntity notificationEntity = NotificationEntity.fromJson(message.data);
      notificationEntity.title = notificationEntity.title ?? "Gatsby Driver";
      _showNotifications(notificationEntity);
    });
  }

  final Set<String> _shownRideOrderIds = {};

  Future<void> showNewRideNotification({required String title, required String body, String? orderId}) async {
    // Same order ke liye ek baar se zyada notification nahi
    if (orderId != null && orderId.isNotEmpty) {
      if (_shownRideOrderIds.contains(orderId)) return;
      _shownRideOrderIds.add(orderId);
      Future.delayed(const Duration(minutes: 10), () => _shownRideOrderIds.remove(orderId));
    }
    await _showNotifications(NotificationEntity(title: title, body: body, type: 'CustomerBookRequest', id: orderId));
  }

  Future<void> showChatNotification({required String title, required String body}) async {
    try {
      await _flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch % 100000,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'chat_channel',
            'Chat Notifications',
            channelDescription: 'Notifications for new chat messages',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
            presentBadge: true,
          ),
        ),
      );
    } catch (e) {
      dev.log('showChatNotification error: $e');
    }
  }

  Future<void> clearAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.cancelAll();
    }

  }

  Future<void> _showNotifications(NotificationEntity notificationEntity) async {
    Random random = Random();
    int id = random.nextInt(900) + 10;
    await _flutterLocalNotificationsPlugin.show(
        id,
        notificationEntity.title,
        notificationEntity.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: "@mipmap/launcher_icon",
            channelShowBadge: true,
            playSound: true,
            priority: Priority.high,
            importance: Importance.high,
            styleInformation: BigTextStyleInformation(notificationEntity.body ?? ''),
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: convertNotificationEntityToString(notificationEntity));
  }

  void _pushNextScreenFromForeground(NotificationEntity notificationEntity) async {
    await callApi(notificationEntity);
    if (notificationEntity.type == "CustomerBookRequest" && !session.isOrderRunning) {
      locator<GlobalKey<NavigatorState>>()
          .currentState
          ?.pushNamedAndRemoveUntil('/home', (route) => false);
    }
  }

  Future<(String, Object?)?> callApi(NotificationEntity entity) async {
    if (entity.type == "CustomerBookRequest") {
      final ctx = locator<GlobalKey<NavigatorState>>().currentContext;
      if (ctx != null && ctx.mounted) {
        final socketProvider = Provider.of<LatestSocketProvider>(ctx, listen: false);
        await socketProvider.getOrderStatus(entity.id ?? "");
      }
    }
    return null;




    /*  if (entity.courseId != null) {
      return (Routes.courseDetail, {"id": int.tryParse(entity.courseId ?? "")});
    } else {
      return (Routes.notification, null);
    }*/
  }

  Future<(String, Object?)?> getPushNotificationRoute() async {
    RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (remoteMessage != null && remoteMessage.data.isNotEmpty) {
      print("RemoteMessage data ${remoteMessage.data}");
      NotificationEntity notificationEntity = NotificationEntity.fromJson(remoteMessage.data);
      notificationEntity.title = remoteMessage.data['title'];
      notificationEntity.body = remoteMessage.data['body'];
      notificationEntity.type = remoteMessage.data['type'];
      notificationEntity.id = remoteMessage.data['id'];
      return callApi(notificationEntity);
    }
    if (notificationAppLaunchDetails?.didNotificationLaunchApp == true) {
      NotificationEntity? entity = convertStringToNotificationEntity(notificationAppLaunchDetails?.notificationResponse?.payload);
      if (entity != null) {
        print("RemoteMessage data ${entity.toJson()}");
        return callApi(entity);
      }
    }

    return null;
  }

  String convertNotificationEntityToString(
      NotificationEntity? notificationEntity) {
    String value = _encoder.convert(notificationEntity);
    return value;
  }

  NotificationEntity? convertStringToNotificationEntity(String? value) {
    if (value == null) {
      return null;
    }

    Map<String, dynamic> map = _decoder.convert(value);
    return NotificationEntity.fromJson(map);
  }
}
