import 'dart:convert';
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

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  final BehaviorSubject<String?> _selectNotificationSubject = BehaviorSubject<String?>();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

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
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
        if (notificationResponse.notificationResponseType == NotificationResponseType.selectedNotification) {
          _selectNotificationSubject.add(notificationResponse.payload);
        }
      },
    );

    await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    _initFirebaseListeners();
  }

  void _configureSelectNotificationSubject() {
    _selectNotificationSubject.stream.listen((String? payload) async {
      if (session.userId.isEmpty) return;
      NotificationEntity? entity = convertStringToNotificationEntity(payload);
      print("notification _configureSelectNotificationSubject ${entity.toString()}");
      if (entity != null) {
        _pushNextScreenFromForeground(entity);
      }
    });
  }

  Future? _onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) {
    if (session.userId.isEmpty) return null;
    NotificationEntity? entity = convertStringToNotificationEntity(payload);
    print("notification onDidReceiveLocalNotification ${entity.toString()}");
    if (entity != null) {
      _pushNextScreenFromForeground(entity);
    }
    return null;
  }

  void _initFirebaseListeners() {
    // App background mein thi aur user ne notification tap ki
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (session.userId.isEmpty) {
        print("userToken is Null");
        return;
      }
      print("Notification tapped (background): ${message.data}");
      NotificationEntity notificationEntity = NotificationEntity.fromJson(message.data);
      _pushNextScreenFromForeground(notificationEntity);
    });

    // App foreground mein hai aur notification aayi
    // *** iOS wala early return HATA DIYA — ye hi main bug tha! ***
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (session.userId.isEmpty) return;

      print("Foreground notification received: ${message.data}");

      NotificationEntity notificationEntity = NotificationEntity.fromJson(message.data);

      notificationEntity.title = message.data['title'] ?? message.notification?.title ?? "Gatsby Driver";
      notificationEntity.body = message.data['body'] ?? message.notification?.body ?? "";

      print("clickAction: ${notificationEntity.clickAction}, type: ${notificationEntity.type}");

      await callApi(notificationEntity);

      // Bug Fix 3: iOS restriction removed — show local notifications on all platforms
      await _showNotifications(notificationEntity);
    });
  }

  Future<void> clearAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.cancelAll();
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
          styleInformation: BigTextStyleInformation(notificationEntity.body ?? ""),
        ),
      ),
      payload: convertNotificationEntityToString(notificationEntity),
    );
  }

  Future<void> _pushNextScreenFromForeground(NotificationEntity notificationEntity) async {
    await callApi(notificationEntity);
  }

  Future<(String, Object?)?> callApi(NotificationEntity entity) async {
    final isBookingRequest = entity.clickAction == "new_order" ||
        entity.clickAction == "order" ||
        entity.type == "CustomerBookRequest";

    print("FCM callApi → clickAction: ${entity.clickAction}, type: ${entity.type}, isBooking: $isBookingRequest, orderId: ${entity.id}");

    if (isBookingRequest) {
      final orderId = entity.id;
      if (orderId == null || orderId.isEmpty) {
        print("FCM callApi: orderId null/empty, skipping getOrderStatus");
        return null;
      }
      final ctx = locator<GlobalKey<NavigatorState>>().currentContext;
      if (ctx != null && ctx.mounted) {
        final socketProvider = Provider.of<LatestSocketProvider>(ctx, listen: false);
        await socketProvider.getOrderStatus(orderId);
      }
    }
    return null;
  }

  Future<(String, Object?)?> getPushNotificationRoute() async {
    RemoteMessage? remoteMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (remoteMessage != null && remoteMessage.data.isNotEmpty) {
      print("RemoteMessage data ${remoteMessage.data}");
      NotificationEntity notificationEntity = NotificationEntity.fromJson(remoteMessage.data);
      notificationEntity.title = remoteMessage.data['title'];
      notificationEntity.body = remoteMessage.data['body'];
      notificationEntity.type = remoteMessage.data['type'];
      notificationEntity.id = remoteMessage.data['id'];
      notificationEntity.clickAction = remoteMessage.data['click_action'];
      return callApi(notificationEntity);
    }

    // Bug Fix 4: Actually fetch launch details from plugin instead of hardcoded null
    final notificationAppLaunchDetails =
        await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp == true) {
      NotificationEntity? entity = convertStringToNotificationEntity(
          notificationAppLaunchDetails?.notificationResponse?.payload);
      if (entity != null) {
        print("LocalNotification launch data ${entity.toJson()}");
        return callApi(entity);
      }
    }

    return null;
  }

  String convertNotificationEntityToString(NotificationEntity? notificationEntity) {
    String value = _encoder.convert(notificationEntity);
    return value;
  }

  NotificationEntity? convertStringToNotificationEntity(String? value) {
    if (value == null) return null;
    Map<String, dynamic> map = _decoder.convert(value);
    return NotificationEntity.fromJson(map);
  }
}