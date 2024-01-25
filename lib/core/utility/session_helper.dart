import 'dart:convert';

import 'package:appkey_taxiapp_driver/core/data/models/customer_detail_model.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/entities/order_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../static/strings.dart';

abstract class Session {
  set setLoggedIn(bool login);

  set setIsOnline(bool isOnline);

  set setIsProfileCompleted(bool isCompleted);

  set setOrderId(String orderId);

  set setToken(String token);
  set setOrderDetails(orderDetails);
  set setCustomerDetails(customerDetails);

  set setFcmToken(String fcmToken);
  set setOldFcmToken(String fcmOldToken);

  set setCurrency(String currency);

  set setOrderStatus(int orderStatus);

  set setDriverId(String driverId);

  set setUserId(String userId);

  set setEstimatedDistance(String distance);
  set setEstimatedTime(String time);

  set setSessionStatusOrder(String sessionStatusOrder);

  set setSessionCategoryId(String sessionCategoryId);

  set setIsOrderRunning(bool isOrderRunning);

  set setRunningOrderId(int orderId);

  set setRunningOrderStatus(int orderStatus);

  set setOrderUserId(int userId);

  set setCurrentOrderState(int state);

  set setCurrentLat(double currentLat);
  set setCurrentLang(double currentLang);

  set setChatToken(String chatToken);
  set setStartTime(String rideStartTime);
  set setEndTime(String rideEndTime);

  String get chatToken;
  String get rideStartTime;
  String get rideEndTime;

  bool get isLoggedIn;

  bool get isOnline;

  bool get isOrderRunning;

  String get estimatedDistance;
  String get estimatedTime;

  int get runningOrderId;

  int get currentOrderState;

  int get runningOrderStatus;

  int get orderUserId;

  bool get isProfileCompleted;

  String get orderId;

  String get sessionToken;

  String get sessionFcmToken;
  String get sessionOldFcmToken;

  String get currency;

  String get driverId;

  /// * GET ORDER DETAILS
  String get orderDetails;

  /// * GET CUSTOMER DETAILS
  String get customerDetails;

  String get userId;
  double get currentLat;
  double get currentLang;

  String get sessionStatusOrder;

  String get sessionCategoryId;

  int get orderStatus;

  Future<void> clearSession();

  Future<void> clearOrderSession();
}

class SessionHelper implements Session {
  final SharedPreferences pref;

  SessionHelper({required this.pref});

  @override
  set setLoggedIn(bool login) {
    pref.setBool(IS_LOGGED_IN, login);
  }

  @override
  set setIsOnline(bool online) {
    pref.setBool(IS_ONLINE, online);
  }

  @override
  set setIsProfileCompleted(bool isCompleted) {
    pref.setBool(IS_PROFILE_COMPLETED, isCompleted);
  }

  @override
  set setToken(String token) {
    pref.setString(SESSION_TOKEN, token);
  }

  @override
  set setCurrentLat(double currentLat) {
    pref.setDouble(CURRENT_LAT, currentLat);
  }

  @override
  set setCurrentLang(double currentLang) {
    pref.setDouble(CURRENT_LANG, currentLang);
  }

  @override
  set setSessionStatusOrder(String sessionStatusOrder) {
    pref.setString(SESSION_STATUS_ORDER, sessionStatusOrder);
  }

  @override
  set setRideStartTime(String rideStartTime) {
    pref.setString(RIDE_START_TIME, rideStartTime);
  }

  @override
  set setRideEndTime(String rideEndTime) {
    pref.setString(RIDE_END_TIME, rideEndTime);
  }

  @override
  set setSessionCategoryId(String sessionCategoryId) {
    pref.setString(SESSION_CATEGORY_ID, sessionCategoryId);
  }

  /// * save order details--------*/

  @override
  set setOrderDetails(sessionOrder) {
    pref.setString(SESSION_ORDER_DETAILS, sessionOrder);
  }

  ///******** Save CUSTOMER DETAILS-------  */
  ///

  @override
  set setCustomerDetails(sessionCustomerDetails) {
    pref.setString(SESSION_CUSTOMER_DETAILS, sessionCustomerDetails);
  }

  @override
  set setUserId(String userId) {
    pref.setString(USER_ID, userId);
  }

  @override
  set setDriverId(String driverId) {
    pref.setString(DRIVER_ID, driverId);
  }

  @override
  set setEstimatedDistance(String distance) {
    pref.setString(ESTIMATED_DISTANCE, distance);
  }

  @override
  set setEstimatedTime(String time) {
    pref.setString(ESTIMATED_TIME, time);
  }

  @override
  set setOrderStatus(int orderStatus) {
    pref.setInt(ORDER_STATUS, orderStatus);
  }

  @override
  set setFcmToken(String fcmToken) {
    pref.setString(FCM_TOKEN, fcmToken);
  }

  @override
  set setOldFcmToken(String fcmOldToken) {
    pref.setString(FCM_OLD_TOKEN, fcmOldToken);
  }

  @override
  set setCurrency(String currency) {
    pref.setString(CURRENCY, currency);
  }

  @override
  set setOrderId(String orderId) {
    pref.setString(ORDER_ID, orderId);
  }

  @override
  set setRunningOrderId(int orderId) {
    pref.setInt(RUNNING_ORDER_ID, orderId);
  }

  @override
  set setRunningOrderStatus(int orderStatus) {
    pref.setInt(RUNNING_ORDER_STATUS, orderStatus);
  }

  @override
  set setIsOrderRunning(bool value) {
    pref.setBool(IS_ORDER_RUNNING, value);
  }

  @override
  set setOrderUserId(int value) {
    pref.setInt(ORDER_USER_ID, value);
  }

  @override
  set setCurrentOrderState(int value) {
    pref.setInt(CURRENT_ORDER_STATE, value);
  }

  @override
  set setChatToken(String chatToken) {
    pref.setString(CHAT_TOKEN, chatToken);
  }

  @override
  set setStartTime(String rideStartTime) {
    pref.setString(RIDE_START_TIME, rideStartTime);
  }

  @override
  set setEndTime(String rideEndTime) {
    pref.setString(RIDE_END_TIME, rideEndTime);
  }

  @override
  String get chatToken => pref.getString(CHAT_TOKEN) ?? '';

  /// **** order dewtails

  @override
  String get orderDetails =>
      pref.getString(SESSION_ORDER_DETAILS) ??
      'session order details are null ';

  /// * customer details

  @override
  String get customerDetails =>
      pref.getString(SESSION_CUSTOMER_DETAILS) ??
      'session customer details are null';

  @override
  double get currentLat => pref.getDouble(CURRENT_LAT) ?? 0.0;

  @override
  double get currentLang => pref.getDouble(CURRENT_LANG) ?? 0.0;

  @override
  bool get isLoggedIn => pref.getBool(IS_LOGGED_IN) ?? false;

  @override
  bool get isOnline => pref.getBool(IS_ONLINE) ?? false;

  @override
  bool get isOrderRunning => pref.getBool(IS_ORDER_RUNNING) ?? false;

  @override
  int get runningOrderId => pref.getInt(RUNNING_ORDER_ID) ?? 0;

  @override
  int get currentOrderState => pref.getInt(CURRENT_ORDER_STATE) ?? 0;

  @override
  int get runningOrderStatus => pref.getInt(RUNNING_ORDER_STATUS) ?? 0;

  @override
  int get orderUserId => pref.getInt(ORDER_USER_ID) ?? 0;

  @override
  bool get isProfileCompleted => pref.getBool(IS_PROFILE_COMPLETED) ?? false;

  @override
  String get sessionToken => pref.getString(SESSION_TOKEN) ?? '';

  @override
  String get userId => pref.getString(USER_ID) ?? '';

  @override
  String get sessionFcmToken => pref.getString(FCM_TOKEN) ?? '';

  @override
  String get sessionOldFcmToken => pref.getString(FCM_OLD_TOKEN) ?? '';

  @override
  String get driverId => pref.getString(DRIVER_ID) ?? '';

  @override
  int get orderStatus => pref.getInt(ORDER_STATUS) ?? 100;

  @override
  String get currency => pref.getString(CURRENCY) ?? '';

  @override
  String get orderId => pref.getString(ORDER_ID) ?? '';

  @override
  String get sessionStatusOrder => pref.getString(SESSION_STATUS_ORDER) ?? '';

  @override
  String get sessionCategoryId => pref.getString(SESSION_CATEGORY_ID) ?? '';

  @override
  String get estimatedDistance => pref.getString(ESTIMATED_DISTANCE) ?? '';

  @override
  String get estimatedTime => pref.getString(ESTIMATED_TIME) ?? '';

  @override
  String get rideStartTime => pref.getString(RIDE_START_TIME) ?? '';
  @override
  String get rideEndTime => pref.getString(RIDE_END_TIME) ?? '';

  @override
  Future<void> clearSession() async {
    setOldFcmToken = pref.getString(FCM_TOKEN)!;

    await pref.clear();
    setFcmToken = sessionFcmToken;
    // await pref.clear();
  }

  @override
  Future<void> clearOrderSession() async {
    await pref.remove(ORDER_ID);
    await pref.remove(ORDER_STATUS);
    await pref.remove(DRIVER_ID);
  }
}
