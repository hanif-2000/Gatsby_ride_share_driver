import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/profile/domain/usecases/update_email.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/profile_state.dart';
import 'package:dio/dio.dart';
import '../../../../core/presentation/providers/form_provider.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';

class ChangeEmailProvider extends FormProvider {
  final UpdateEmail updateEmail;
  final session = locator<Session>();

  ChangeEmailProvider({required this.updateEmail});

  Stream<ProfileState> updateEmaileForm({required String email}) async* {
    yield ProfileLoading();
    final data = FormData.fromMap({
      'api_token': session.sessionToken,
      'email': email,
    });
    final result = await updateEmail.execute(data);
    yield* result.fold((failure) async* {
      logMe("Failureeeee");
      yield ProfileFailure(failure: failure.message);
    }, (data) async* {
      refreshEmail();
      yield ProfileUpdateSuccess(success: data);
    });
  }
}
