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
  String _dlImageFront = '';
  String _dlImageBack = '';

  String _idProofImage = '';
  String? _countryName;
  String _shortCountryName = '';

  String _profileUploadName = '';
  String _dlImageUploadNameFront = '';
  String _dlImageUploadNameBack = '';

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

  setShortCountryName(String name) {
    _shortCountryName = name;
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

//Front Driving License
  setDlImageFront(String image) {
    _dlImageFront = image;
    notifyListeners();
  }

  //Front Driving License
  setDlImageBack(String image) {
    _dlImageBack = image;
    notifyListeners();
  }

  setIdProofImage(String image) {
    _idProofImage = image;
    notifyListeners();
  }

//Front driving license
  setDlImageUploadNameFront(String image) {
    _dlImageUploadNameFront = image;
    notifyListeners();
  }

  //Back Driving License

  setDlImageUploadNameBack(String image) {
    _dlImageUploadNameBack = image;
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
  String get shortCountryName => _shortCountryName;

  String get profileUploadName => _profileUploadName;

  String get dlImageFront => _dlImageFront;
  String get dlImageBack => _dlImageBack;

  String get idProofImage => _idProofImage;

  String get dlImageUploadNameFront => _dlImageUploadNameFront;
  String get dlImageUploadNameBack => _dlImageUploadNameBack;

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
