import 'package:appkey_taxiapp_driver/core/presentation/providers/form_provider.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/domain/usecases/do_create_profile.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_state.dart';

class CreateProfileProvider extends FormProvider {
  final DoCreateProfile doCreateProfile;

  CreateProfileProvider({required this.doCreateProfile});

  int currentStep = 1;
  String profileImage = '';
  String? countryName;

  setCurrentStep(int step) {
    currentStep = step;
    notifyListeners();
  }

  setCountryName(String name) {
    countryName = name;
    notifyListeners();
  }

  setProfileImage(String image) {
    profileImage = image;
    notifyListeners();
  }

  Stream<CreateProfileState> doCreateProfileApi(String url) async* {
    yield CreateProfileLoading();

    final signupResult = await doCreateProfile.call(url, {});
    yield* signupResult.fold((statusCode) async* {
      logMe('signup error $statusCode');
      yield CreateProfileFailure(failure: statusCode.message);
    }, (result) async* {
      if (result != null) {
        yield CreateProfileSuccess(data: result);
      } else {
        yield CreateProfileFailure(failure: appLoc.signupFailure);
      }
    });
  }
}
