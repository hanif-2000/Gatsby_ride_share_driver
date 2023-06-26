import 'package:appkey_taxiapp_driver/core/utility/firebase_helper.dart';
import 'package:dio/dio.dart';

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
    await FirebaseHelper.setupMessaging();
    final session = locator<Session>();
    String fcmToken = session.sessionFcmToken;
    FormData data = FormData.fromMap({
      'email': email,
      'password': password,
      'fcm_token': fcmToken,
      'position': position
    });
    print('Sign in data ----> ${data.fields.toString()}');
    try {
      final response = await dio.post(
        url,
        data: data,
      );
      print('Login response ---> ${response.data}');
      final model = LoginResponseModel.fromJson(response.data);
      final session = locator<Session>();
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
