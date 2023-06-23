import '../../../../core/presentation/providers/form_provider.dart';
import '../../../../core/utility/helper.dart';
import '../../domain/usecases/do_login.dart';
import 'login_state.dart';
import 'package:location/location.dart' as lctn;

class LoginProvider extends FormProvider {
  final DoLogin doLogin;

  LoginProvider({required this.doLogin});

  final lctn.Location locationService = lctn.Location();

  Stream<LoginState> doLoginApi() async* {
    yield LoginLoading();
    lctn.LocationData locationData = await locationService.getLocation();

    final loginResult = await doLogin.call(
        emailController.text,
        passwordController.text,
        '${locationData.longitude},${locationData.longitude}');
    yield* loginResult.fold((statusCode) async* {
      logMe(statusCode);
      yield LoginFailure(failure: statusCode.message);
    }, (result) async* {
      if (result != null) {
        yield LoginSuccess(data: result);
      } else {
        yield LoginFailure(failure: appLoc.loginfailure);
      }
    });
  }
}
