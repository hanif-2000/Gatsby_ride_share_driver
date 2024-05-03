import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../static/strings.dart';

abstract class Session {
  set setLoggedIn(bool login);

  set setIsOnline(bool isOnline);

  set setIsProfileCompleted(bool isCompleted);
  set setIsPaymentDone(bool paymentDone);
  set setIsRatingGiven(bool ratingGiven);

  // set setOrderId(String orderId);

  set setToken(String token);
  set setOrderDetails(orderDetails);
  set setCustomerDetails(customerDetails);
  set setOrderReceipt(String receipt);

  set setCustomerName(String val);
  set setCustomerImg(String val);
  set setCustomerRating(String val);
  set setCustomerPhn(String val);
  set setStartAdd(String val);
  set setStartCo(String val);
  set setEndAdd(String val);
  set setEndCo(String val);

  set setFcmToken(String fcmToken);
  set setOldFcmToken(String fcmOldToken);

  set setCurrency(String currency);

  // set setOrderStatus(int orderStatus);

  set setDriverId(String driverId);

  set setUserId(String userId);

  set setEstimatedDistance(String distance);
  set setEstimatedTime(String time);

  set setSessionStatusOrder(String sessionStatusOrder);

  set setSessionCategoryId(String sessionCategoryId);

  set setIsOrderRunning(bool isOrderRunning);

  set setRunningOrderId(int orderId);
  set setCustomerId(int customerId);

  set setRunningOrderStatus(int orderStatus);

  set setOrderUserId(int userId);

  set setCurrentOrderState(int state);

  set setCurrentLat(double currentLat);
  set setCurrentLang(double currentLang);
  set setChatToken(String chatToken);
  set setStartTime(String rideStartTime);
  set setEndTime(String rideEndTime);
  set setOriginLat(double lat);
  set setOriginLong(double long);
  String get chatToken;
  String get rideStartTime;
  String get rideEndTime;
  String get orderReceipt;

  bool get isLoggedIn;

  bool get isOnline;
  bool get isRatingGiven;
  bool get isPaymentDone;

  bool get isOrderRunning;

  String get estimatedDistance;
  String get estimatedTime;

  int get runningOrderId;

  int get customerId;

  int get currentOrderState;

  int get runningOrderStatus;

  int get orderUserId;

  bool get isProfileCompleted;

  // String get orderId;

  String get sessionToken;

  String get sessionFcmToken;
  String get sessionOldFcmToken;

  String get currency;

  String get driverId;

  /// * GET ORDER DETAILS
  String get orderDetails;
  double get originLat;
  double get originLong;

  /// * GET CUSTOMER DETAILS
  String get customerDetails;

  String get customerImg;
  String get customerName;
  String get startCo;
  String get endCo;
  String get startAdd;
  String get endAdd;
  String get customerRating;
  String get customerPhoneNumber;

  String get userId;
  double get currentLat;
  double get currentLang;

  String get sessionStatusOrder;

  String get sessionCategoryId;

  // int get orderStatus;

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
  set setIsPaymentDone(bool paymentDone) {
    pref.setBool(PAYMENT_DONE, paymentDone);
  }

  @override
  set setIsRatingGiven(bool ratingGiven) {
    pref.setBool(RATING_GIVEN, ratingGiven);
  }

  @override
  set setOrderReceipt(String receipt) {
    pref.setString(ORDER_RECEIPT, receipt);
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
  set setCustomerName(String val) {
    pref.setString(CUSTOMER_NAME, val);
  }

  @override
  set setCustomerId(int val) {
    pref.setInt(CUSTOMER_ID, val);
  }

  @override
  set setCustomerImg(String customerImg) {
    pref.setString(CUSTOMER_IMG, customerImg);
  }

  @override
  set setCustomerRating(String customerRating) {
    pref.setString(CUSTOMER_RATING, customerRating);
  }

  @override
  set setCustomerPhn(String customerphn) {
    pref.setString(CUSTOMER_PHN, customerphn);
  }

  @override
  set setStartAdd(String startAdd) {
    pref.setString(START_ADD, startAdd);
  }

  @override
  set setEndAdd(String endAdd) {
    pref.setString(END_ADD, endAdd);
  }

  @override
  set setStartCo(String startCo) {
    pref.setString(START_CO, startCo);
  }

  @override
  set setEndCo(String endCo) {
    pref.setString(END_CO, endCo);
  }

  @override
  set setDriverPhn(String customerPhn) {
    pref.setString(CUSTOMER_PHN, customerPhn);
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

  // @override
  // set setOrderStatus(int orderStatus) {
  //   pref.setInt(ORDER_STATUS, orderStatus);
  // }

  @override
  set setFcmToken(String fcmToken) {
    pref.setString(FCM_TOKEN, fcmToken);
  }

  @override
  set setOldFcmToken(String fcmOldToken) {
    pref.setString(FCM_OLD_TOKEN, fcmOldToken);
  }

  // @override
  // set setCustomerImg(String val) {
  //   pref.setString(CUSTOMER_IMG, val);
  // }

  @override
  set setCurrency(String currency) {
    pref.setString(CURRENCY, currency);
  }

  // @override
  // set setOrderId(String orderId) {
  //   pref.setString(ORDER_ID, orderId);
  // }

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
  set setOriginLat(double lat) {
    pref.setDouble(origin_lat, lat);
  }

  @override
  set setOriginLong(double lat) {
    pref.setDouble(origin_long, lat);
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
  double get originLat  => pref.getDouble(origin_lat)??0.0;
  @override
  double get originLong  => pref.getDouble(origin_long)??0.0;

  @override
  set setOriginLatLong(LatLng rideEndTime) {

  }
  @override
  double get currentLat => pref.getDouble(CURRENT_LAT) ?? 0.0;

  @override
  double get currentLang => pref.getDouble(CURRENT_LANG) ?? 0.0;

  @override
  bool get isLoggedIn => pref.getBool(IS_LOGGED_IN) ?? false;

  @override
  bool get isRatingGiven => pref.getBool(RATING_GIVEN) ?? true;
  @override
  bool get isPaymentDone => pref.getBool(PAYMENT_DONE) ?? true;

  @override
  bool get isOnline => pref.getBool(IS_ONLINE) ?? false;

  @override
  bool get isOrderRunning => pref.getBool(IS_ORDER_RUNNING) ?? false;

  @override
  int get runningOrderId => pref.getInt(RUNNING_ORDER_ID) ?? 0;

  @override
  String get orderReceipt =>
      pref.getString(ORDER_RECEIPT) ?? "No order receipt";

  //  @override
  // int get orderId => pref.getInt(ORDER_ID) ?? 0;

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
  int get customerId => pref.getInt(CUSTOMER_ID) ?? 0;

  @override
  String get sessionFcmToken => pref.getString(FCM_TOKEN) ?? '';

  @override
  String get customerName => pref.getString(CUSTOMER_NAME) ?? '';
  @override
  String get customerImg => pref.getString(CUSTOMER_IMG) ?? '';
  @override
  String get customerRating => pref.getString(CUSTOMER_RATING) ?? '';
  @override
  String get customerPhn => pref.getString(CUSTOMER_PHN) ?? '';
  @override
  String get startAddress => pref.getString(START_ADD) ?? '';
  @override
  String get endAddress => pref.getString(END_ADD) ?? '';
  @override
  String get startCo => pref.getString(START_CO) ?? '';
  @override
  String get endCo => pref.getString(END_CO) ?? '';

  @override
  String get sessionOldFcmToken => pref.getString(FCM_OLD_TOKEN) ?? '';

  @override
  String get driverId => pref.getString(DRIVER_ID) ?? '';

  // @override
  // int get orderStatus => pref.getInt(ORDER_STATUS) ?? 100;

  @override
  String get currency => pref.getString(CURRENCY) ?? '';

  // @override
  // String get orderId => pref.getString(ORDER_ID) ?? '';

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
  String get endAdd => pref.getString(END_ADD) ?? '';

  @override
  String get customerPhoneNumber => pref.getString(CUSTOMER_PHN) ?? '';

  @override
  String get startAdd => pref.getString(START_ADD) ?? '';

  @override
  Future<void> clearSession() async {
    setOldFcmToken = pref.getString(FCM_TOKEN)!;

    await pref.clear();
    setFcmToken = sessionFcmToken;
    // await pref.clear();
  }

  @override
  Future<void> clearOrderSession() async {
    // await pref.remove(ORDER_ID);
    // await pref.remove(ORDER_STATUS);
    // await pref.remove(DRIVER_ID);
    // await pref.remove(SESSION_ORDER_DETAILS);
    // await pref.remove(SESSION_CUSTOMER_DETAILS);
    // await pref.remove(SESSION_STATUS_ORDER);
    await pref.remove(CUSTOMER_IMG);
    await pref.remove(CUSTOMER_NAME);
    await pref.remove(CUSTOMER_PHN);
    await pref.remove(CUSTOMER_RATING);
    await pref.remove(START_ADD);
    await pref.remove(END_CO);
    await pref.remove(END_ADD);
    await pref.remove(START_CO);
    // await pref.remove(RATING_GIVEN);
    // await pref.remove(PAYMENT_DONE);
    // await pref.remove(CUSTOMER_ID);
  }




}
