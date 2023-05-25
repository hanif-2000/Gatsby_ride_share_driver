import 'package:appkey_taxiapp_driver/core/presentation/providers/form_provider.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/model/vehicle_type_respose_model.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/domain/usecases/do_create_profile.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_state.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/get_vehicle_type_state.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/upload_state.dart';

class CreateProfileProvider extends FormProvider {
  final DoCreateProfile doCreateProfile;

  CreateProfileProvider({required this.doCreateProfile});

  int _currentStep = 1;
  String _profileImage = '';
  String _dlImage = '';
  String _idProofImage = '';
  String? _countryName;
  String _profileUploadName = '';
  String _dlImageUploadName = '';
  String _idProofImageUploadName = '';
  List<VehicleTypeDataModel> _vehicleDataModel = [];
  VehicleTypeDataModel? _selectedVehicleType;

  setCurrentStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  setCountryName(String name) {
    _countryName = name;
    notifyListeners();
  }

  setProfileImage(String image) {
    _profileImage = image;
    notifyListeners();
  }

  setProfileUploadName(String image) {
    _profileUploadName = image;
    notifyListeners();
  }

  setDlImage(String image) {
    _dlImage = image;
    notifyListeners();
  }

  setIdProofImage(String image) {
    _idProofImage = image;
    notifyListeners();
  }

  setDlImageUploadName(String image) {
    _dlImageUploadName = image;
    notifyListeners();
  }

  setIdProofImageUploadName(String image) {
    _idProofImageUploadName = image;
    notifyListeners();
  }

  setSelectedVehicleType(VehicleTypeDataModel type) {
    _selectedVehicleType = type;
    notifyListeners();
  }

  int get currentStep => _currentStep;

  String get profileImage => _profileImage;

  String? get countryName => _countryName;

  String get profileUploadName => _profileUploadName;

  String get dlImage => _dlImage;

  String get idProofImage => _idProofImage;

  String get dlImageUploadName => _dlImageUploadName;

  String get idProofImageUploadName => _idProofImageUploadName;

  List<VehicleTypeDataModel> get vehicleTypeList => _vehicleDataModel;

  VehicleTypeDataModel? get selectedVehicleType => _selectedVehicleType;

  Stream<CreateProfileState> doCreateProfileApi(
      String url, Map<String, dynamic> mapData) async* {
    yield CreateProfileLoading();

    final signupResult = await doCreateProfile.call(url, mapData);
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

  Stream<UploadState> doUploadProfileApi(String image) async* {
    yield UploadLoading();

    final signupResult = await doCreateProfile.upload(image);
    yield* signupResult.fold((statusCode) async* {
      logMe('signup error $statusCode');
      yield UploadFailure(failure: statusCode.message);
    }, (result) async* {
      if (result != null) {
        yield UploadSuccess(data: result);
      } else {
        yield UploadFailure(failure: appLoc.signupFailure);
      }
    });
  }

  Stream<GetVehicleTypeState> getVehicleTypeData() async* {
    yield GetVehicleTypeLoading();

    final signupResult = await doCreateProfile.getVehicleTypes();
    yield* signupResult.fold((statusCode) async* {
      logMe('signup error $statusCode');
      yield GetVehicleTypeFailure(failure: statusCode.message);
    }, (result) async* {
      if (result != null) {
        _vehicleDataModel = result;
        notifyListeners();
        print('Type data -----> ${result.length}');
        yield GetVehicleTypeSuccess(data: result);
      } else {
        yield GetVehicleTypeFailure(failure: appLoc.signupFailure);
      }
    });
  }
}
