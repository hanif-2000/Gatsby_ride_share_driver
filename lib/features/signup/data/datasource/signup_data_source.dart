import 'dart:io';

import 'package:appkey_taxiapp_driver/features/signup/data/model/signup_response_model.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';

abstract class SignupDataSource {
  Future<SignupResponseModel?> doSignup(
      String email, String password, String position);
}

class SignupDataSourceImplementation implements SignupDataSource {
  final Dio dio;

  SignupDataSourceImplementation({required this.dio});

  @override
  Future<SignupResponseModel?> doSignup(
      String email, String password, String position) async {
    String url = 'api/webservice/driver/signup';
    // await FirebaseHelper.setupMessaging();
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken()??"";
      final session = locator<Session>();
      session.setFcmToken=fcmToken;
      FormData data = FormData.fromMap({
        'email': email,
        'password': password,
        'fcm_token': fcmToken,
        'position': position,
        'device_type': Platform.isIOS ? 'ios' : 'android',
      });
      print('Signup data -----> ${data.fields.toString()}');
      final response = await dio.post(
        url,
        data: data,
      );
      print('Signup response ---> ${response.data}');
      final model = SignupResponseModel.fromJson(response.data);
      if (model.success == 1) {
        // session.setUserId = model.data!.driverId.toString();
        session.setToken = model.token!;
        // session.setSessionCategoryId = model.data!.categoryId.toString();
        return model;
      } else {
        return model;
      }
    } catch (e) {
      rethrow;
    }
  }
}
