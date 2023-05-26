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

  ForgetScreens get forgetScreens => _forgetScreens;

  String? get pin => _pin;

  setForgetScreens(ForgetScreens screens) {
    _forgetScreens = screens;
    notifyListeners();
  }

  setPin(String pin) {
    _pin = pin;
    notifyListeners();
  }

  Stream<ForgotPasswordState> doForgotPasswordApi(
      {required String url, required String email}) async* {
    yield ForgotPasswordLoading();
    final formData = FormData.fromMap({
      'email': email,
    });
    final result = await doForgotPassword.call(url, formData);
    yield* result.fold((statusCode) async* {
      yield ForgotPasswordFailure(failure: statusCode.message);
    }, (result) async* {
      yield ForgotPasswordSuccess(data: result);
    });
  }
}
