import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import 'injection.dart';
import 'session_helper.dart';

class NotificationHelper {
  //singleton pattern
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> _selectNotificationSubject = BehaviorSubject<String?>();
  final session = locator<Session>();
  Future<void> init() async {
    _configureSelectNotificationSubject();
    const String iconNotification = '@mipmap/launcher_icon';

    const initializationSettingsAndroid =
        AndroidInitializationSettings(iconNotification);

    const darwinInitializationSettings = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestAlertPermission: true,
        requestBadgePermission: true);
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: darwinInitializationSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        if (notificationResponse.notificationResponseType ==
            NotificationResponseType.selectedNotification) {
          _selectNotificationSubject.add(notificationResponse.payload);
        }
      },
    );
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    // description
    importance: Importance.max,
  );

  Future<void> showNotifications(RemoteMessage message) async {
    Random random = Random();
    int id = random.nextInt(900) + 10;
    await flutterLocalNotificationsPlugin.show(
      id,
      message.data["title"],
      message.data["message"],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: "@mipmap/ic_launcher",
          channelShowBadge: true,
          playSound: true,
          priority: Priority.max,
          importance: Importance.max,
          styleInformation: BigTextStyleInformation(message.data["message"] ?? ""),
        ),
      ),
      //  NotificationDetails(android: _androidNotificationDetails),
    );
  }

  void _configureSelectNotificationSubject() {
    _selectNotificationSubject.stream.listen((String? payload) async {
      if (session.userId.isEmpty) {
        return;
      }
    /*  NotificationEntity? entity = convertStringToNotificationEntity(payload);
      printLog(
          "notification _configureSelectNotificationSubject ${entity.toString()}");
      if (entity != null) {
        _pushNextScreenFromForeground(entity);
      }*/
    });
  }
}
