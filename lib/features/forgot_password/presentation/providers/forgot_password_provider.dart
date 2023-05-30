import 'dart:async';

import 'package:dio/dio.dart';

import '../../../../core/presentation/providers/form_provider.dart';
import '../../domain/usecases/do_forgot_password.dart';
import 'forgot_password_state.dart';

enum ForgetScreens { forget, otp, password }

class ForgotPasswordProvider extends FormProvider {
  final DoForgotPassword doForgotPassword;

  ForgotPasswordProvider({required this.doForgotPassword});

  ForgetScreens _forgetScreens = ForgetScreens.forget;
  String? _pin;
  int _second = 30;
  Timer? timer;

  ForgetScreens get forgetScreens => _forgetScreens;

  String? get pin => _pin;

  int get second => _second;

  setForgetScreens(ForgetScreens screens) {
    _forgetScreens = screens;
    notifyListeners();
  }

  setPin(String pin) {
    _pin = pin;
    notifyListeners();
  }

  setSecond(int value) {
    _second = value;
    notifyListeners();
  }

  otpCountDown() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_second >= 1) {
        _second = _second - 1;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  Stream<ForgotPasswordState> doForgotPasswordApi(
      {required String url, required FormData formData}) async* {
    yield ForgotPasswordLoading();
    // final formData = FormData.fromMap({
    //   'email': email,
    //   'type': 'Driver',
    // });
    final result = await doForgotPassword.call(url, formData);
    yield* result.fold((statusCode) async* {
      yield ForgotPasswordFailure(failure: statusCode.message);
    }, (result) async* {
      yield ForgotPasswordSuccess(data: result);
    });
  }
}
