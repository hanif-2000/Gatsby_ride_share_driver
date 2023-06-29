import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/profile/domain/usecases/update_password.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/profile_state.dart';
import 'package:dio/dio.dart';
import '../../../../core/presentation/providers/form_provider.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';

class ChangePasswordProvider extends FormProvider {
  final UpdatePassword updatePassword;
  final session = locator<Session>();

  ChangePasswordProvider({required this.updatePassword});

  Stream<ProfileState> updatePasswordForm({
    required String currentPwd,
    required String newPwd,
    required String confirmPwd,
  }) async* {
    yield ProfileLoading();
    final data = FormData.fromMap({
      'api_token': session.sessionToken,
      'old_password': currentPwd,
      'password': newPwd,
      'password_confirmation': confirmPwd,
    });
    final result = await updatePassword.execute(data);
    yield* result.fold((failure) async* {
      logMe("Failureeeee");
      yield ProfileFailure(failure: failure.message);
    }, (data) async* {
      if (data.success == 1) {
        refreshPassword();
      }
      yield ChangePasswordSuccess(data: data);
    });
  }
}
