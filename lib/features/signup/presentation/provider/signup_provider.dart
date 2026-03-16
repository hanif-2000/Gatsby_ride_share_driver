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

    try {
      bool serviceEnabled = await locationService.serviceEnabled();
      logMe('Service enabled: $serviceEnabled');
      if (!serviceEnabled) {
        serviceEnabled = await locationService.requestService();
        if (!serviceEnabled) {
          yield SignupFailure(failure: 'Location service is disabled');
          return;
        }
      }

      lctn.PermissionStatus permission = await locationService.hasPermission();
      logMe('Permission status: $permission');
      if (permission == lctn.PermissionStatus.denied) {
        permission = await locationService.requestPermission();
        if (permission != lctn.PermissionStatus.granted) {
          yield SignupFailure(failure: 'Location permission is required');
          return;
        }
      }

      if (permission == lctn.PermissionStatus.deniedForever) {
        yield SignupFailure(
            failure: 'Location permission is permanently denied.');
        return;
      }

      logMe('Getting location...');
      lctn.LocationData locationData;
      try {
        locationData = await locationService.getLocation().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            throw Exception('Location fetch timed out');
          },
        );
      } catch (e) {
        logMe('Location fetch failed: $e, using default location');
        // Default location use karo taaki signup block na ho
        locationData = lctn.LocationData.fromMap({
          'latitude': 37.3349,
          'longitude': -122.0090,
        });
      }
      logMe('Location: ${locationData.latitude}, ${locationData.longitude}');

      logMe('Calling signup API...');
      logMe('Email: ${emailController.text}');

      final signupResult = await doSignup.call(
        emailController.text,
        passwordConfirmController.text,
        '${locationData.latitude},${locationData.longitude}',
      );

      logMe('Signup result received');

      yield* signupResult.fold((statusCode) async* {
        logMe('signup error $statusCode');
        yield SignupFailure(failure: statusCode.message);
      }, (result) async* {
        logMe('Signup success: ${result!.success}');
        logMe('Signup message: ${result.message}');
        if (result.success == 1) {
          yield SignupSuccess(data: result);
        } else {
          yield SignupFailure(failure: result.message ?? appLoc.signupFailure);
        }
      });
    } catch (e) {
      logMe('signup exception: $e');
      yield SignupFailure(failure: 'Something went wrong: $e');
    }
  }
}