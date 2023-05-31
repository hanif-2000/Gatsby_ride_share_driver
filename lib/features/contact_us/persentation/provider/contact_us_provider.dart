import 'package:appkey_taxiapp_driver/features/contact_us/persentation/pages/contact_us_state.dart';
import 'package:appkey_taxiapp_driver/features/login/domain/usecases/do_login.dart';

import '../../../../core/presentation/providers/form_provider.dart';
import '../../../../core/utility/helper.dart';

class ContactUsProvider extends FormProvider {
  final DoLogin doLogin;

  ContactUsProvider({required this.doLogin});

  Stream<ContactUsState> doLoginApi() async* {
    yield ContactUsLoading();

    final loginResult =
        /*await doLogin.call(emailController.text, passwordController.text)*/ null;
    yield* loginResult.fold((statusCode) async* {
      logMe(statusCode);
      yield ContactUsFailure(failure: statusCode.message);
    }, (result) async* {
      if (result != null) {
        yield ContactUsSuccess(data: result);
      } else {
        yield ContactUsFailure(failure: appLoc.loginfailure);
      }
    });
  }
}
