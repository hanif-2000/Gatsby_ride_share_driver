import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/signup/domain/usecases/do_signup.dart';
import 'package:appkey_taxiapp_driver/features/signup/presentation/provider/signup_state.dart';
import 'package:location/location.dart' as lctn;
import '../../../../core/presentation/providers/form_provider.dart';

class SignupProvider extends FormProvider {
  final DoSignup doSignup;

  SignupProvider({required this.doSignup});

  final lctn.Location locationService = lctn.Location();

  Stream<SignupState> doSignupApi() async* {
    yield SignupLoading();
    // bool serviceStatus = await locationService.serviceEnabled();
    // bool serviceStatusResult = await locationService.requestService();

    String position = '0.0,0.0';
    try {
      lctn.LocationData locationData = await locationService
          .getLocation()
          .timeout(const Duration(seconds: 5));
      position = '${locationData.latitude},${locationData.longitude}';
    } catch (e) {
      logMe('Location error during signup: $e');
    }

    final signupResult = await doSignup.call(
        emailController.text,
        passwordConfirmController.text,
        position);
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
