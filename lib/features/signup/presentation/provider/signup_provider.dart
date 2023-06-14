import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/signup/domain/usecases/do_signup.dart';
import 'package:appkey_taxiapp_driver/features/signup/presentation/provider/signup_state.dart';

import '../../../../core/presentation/providers/form_provider.dart';

class SignupProvider extends FormProvider {
  final DoSignup doSignup;


  SignupProvider({required this.doSignup});


  Stream<SignupState> doSignupApi() async* {
    yield SignupLoading();

    final signupResult = await doSignup.call(
        emailController.text, passwordConfirmController.text);
    yield* signupResult.fold((statusCode) async* {
      logMe('signup error $statusCode');
      yield SignupFailure(failure: statusCode.message);
    }, (result) async* {
      if (result!.success == 1) {
        yield SignupSuccess(data: result);
      } else {
        yield SignupFailure(failure: result.message ?? appLoc.signupFailure);
      }
    });
  }
}
