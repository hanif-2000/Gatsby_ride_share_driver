import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../features/login/presentation/pages/login_page.dart';
import '../utility/helper.dart';
import '../utility/injection.dart';
import '../utility/session_helper.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // set default headers (skip content-type for multipart requests)
    if (options.data is! FormData) {
      options.headers.addAll({"content-type": "application/json; charset=utf-8"});
    }
    options.headers.addAll({"Accept": "application/json"});

    // Always remove required_token — it must never reach the server
    options.headers.remove('required_token');

    final isAuthRequest = options.path.contains('logindriver') ||
        options.path.contains('signup') ||
        options.path.contains('forgotpassword');

    // Remove Authorization header for auth endpoints (login/signup)
    if (isAuthRequest) {
      options.headers.remove('Authorization');
      return super.onRequest(options, handler);
    }

    // For all protected endpoints, always inject the session token
    final token = locator<Session>().sessionToken;
    options.headers['Authorization'] = 'Bearer $token';
    return super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;

    final isLoginRequest = err.requestOptions.path.contains('logindriver') ||
        err.requestOptions.path.contains('signup');

    if (statusCode == HttpStatus.unprocessableEntity && !isLoginRequest) {
      dismissLoading();
      await sessionLogOut().then(
        (_) => Navigator.pushNamedAndRemoveUntil(
          locator<GlobalKey<NavigatorState>>().currentContext!,
          LoginPage.routeName,
          (route) => false,
        ),
      );
    }

    if (statusCode == 404 && !isLoginRequest) {
      dismissLoading();
      await sessionLogOut().then(
        (_) => Navigator.pushNamedAndRemoveUntil(
          locator<GlobalKey<NavigatorState>>().currentContext!,
          LoginPage.routeName,
          (route) => false,
        ),
      );
    }

    if (statusCode == HttpStatus.forbidden) {}

    // if(statusCode==HttpStatus.unprocessableEntity){

    //            (route) => false);

    // }

    return super.onError(err, handler);
  }
}
