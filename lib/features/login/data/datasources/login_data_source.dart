import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../models/login_response_model.dart';

abstract class LoginDataSource {
  Future<LoginResponseModel?> doLogin(
      String email, String password, String position);
}

class LoginDataSourceImplementation implements LoginDataSource {
  final Dio dio;

  LoginDataSourceImplementation({required this.dio});

  @override
  Future<LoginResponseModel?> doLogin(
      String email, String password, String position) async {
    String url = 'api/webservice/logindriver';
    // await FirebaseHelper.setupMessaging();

    /*  if (session.sessionFcmToken == '') {
      FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Change here
      _firebaseMessaging.getToken().then((token) {
        session.setFcmToken = token!;

        print("fcm token token is $token");
      });
    }*/

    try {
      final session = locator<Session>();
      String fcmToken = "";
      try {
        for (int i = 0; i < 3 && fcmToken.isEmpty; i++) {
          fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
          if (fcmToken.isEmpty && i < 2) {
            await Future.delayed(const Duration(seconds: 1));
          }
        }
      } catch (e) {
        print("FCM token error (may be simulator): $e");
      }
      session.setFcmToken = fcmToken;
      print("fcmToken==> $fcmToken");
      final data = {
        'email': email,
        'password': password,
        'fcm_token': fcmToken,
        'position': position,
        'device_type': Platform.isIOS ? 'ios' : 'android',
      };
      print('Sign in data ----> $data');
      final response = await dio.post(
        url,
        data: data,
      );
      print('Login response status ---> ${response.statusCode}');
      print('Login response body  ---> ${response.data}');

      final model = LoginResponseModel.fromJson(response.data);
      if (model.success == 1) {
        session.setUserId = model.data!.driverId.toString();
        session.setToken = model.token!;
        session.setSessionCategoryId = model.data!.categoryId.toString();
        session.setChatToken = model.data!.chatToken;
        return model;
      } else {
        return model;
      }
    } catch (e) {
      rethrow;
    }
  }
}
