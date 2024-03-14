import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/data/models/price_category_model.dart';
import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/model/vehicle_type_respose_model.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/upload_state.dart';
import 'package:appkey_taxiapp_driver/features/profile/domain/usecases/update_profile.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/profile_state.dart';
import 'package:dio/dio.dart';
import '../../../../core/domain/entities/price_category.dart';
import '../../../../core/domain/usecases/get_price_category.dart';
import '../../../../core/presentation/providers/form_provider.dart';
import '../../../../core/utility/injection.dart';
import '../../data/models/profile_response_model.dart';

class ProfileEditProvider extends FormProvider {
  final UpdateProfile updateProfile;
  final GetPriceCategory getPriceCategory;
  final session = locator<Session>();

  // String? _imageUrl;
  String _profileImage = '';
  String _profileUploadImage = '';
  String _countryName = 'India';
  bool _isVehicleEdit = false;
  bool _isBankEdit = false;

  // String get imageUrl => _imageUrl ?? '';

  String get profileUploadImage => _profileUploadImage ?? '';

  String get countryName => _countryName ?? '';

  bool get isVehicleEdit => _isVehicleEdit ?? false;

  bool get isBankEdit => _isBankEdit ?? false;

  String get profileImage => _profileImage ?? '';
  static final List<PriceCategory> _priceCategory = [];
  List<VehicleTypeDataModel> _vehicleCategory = [];

  PriceCategory? _selectedCategory;
  VehicleTypeDataModel? _selectedVehicle;

  PriceCategory? _defaultSelectedCategory;

  List<PriceCategory> get priceCategory => _priceCategory;
  List<VehicleTypeDataModel> get vehicleCategory => _vehicleCategory;

  PriceCategory? get selectedCategory => _selectedCategory;
  VehicleTypeDataModel? get selectedVehicle => _selectedVehicle;

  PriceCategory? get defaultSelectedCategory => _defaultSelectedCategory;

  int newSelectedVehicle = 0;

  updateNewSelectedVehicle({val}) {
    newSelectedVehicle = val;
    notifyListeners();
  }

  // List<VehicleTypeDataModel> vehicleDataModel = [];

  var dio = Dio();

  setProfileImage(String image) {
    _profileImage = image;
    notifyListeners();
  }

  setIsVehicleEdit(bool value) {
    _isVehicleEdit = value;
    notifyListeners();
  }

  setIsBankEdit(bool value) {
    _isBankEdit = value;
    notifyListeners();
  }

  setCountryName(String name) {
    _countryName = name;
    notifyListeners();
  }

  setProfileUploadImage(String image) {
    _profileUploadImage = image;
    notifyListeners();
  }

  set setSelectedCategory(val) {
    _selectedCategory = val;
    notifyListeners();
  }

  set setSelectedVehicle(val) {
    _selectedVehicle = val;
    notifyListeners();
  }

  set setDefaultSelectedCategory(val) {
    _defaultSelectedCategory = val;
    notifyListeners();
  }

  ProfileEditProvider(
      {required this.updateProfile, required this.getPriceCategory});

  setupTextControllerValues(ProfileDataModel profile) {
    // fetchPriceCategory().listen((event) {});

    getVehicleTypes();

    nameController.text = profile.name!;
    emailController.text = profile.email!;
    phoneController.text = profile.phoneNumber!;
    carModelController.text = profile.carModel!;
    vehicleController.text = profile.plateNumber!;
    if (profile.name != '') {
      firstNameController.text = profile.name!.split(' ').first;
      lastNameController.text = profile.name!.split(' ').last;
    }

    vehicleInsuranceController.text = profile.insuranceNumber!;
    vehicleNameController.text = profile.vehicleName!;
    vehicleModelController.text = profile.carModel!;
    vehicleNumberController.text = profile.plateNumber!;
    vehicleTypeController.text = profile.vehicleCategory.categoryName;

    bankTransitController.text = profile.bankDetails.transitNumber;
    bankInstitutionController.text = profile.bankDetails.institutionNumber;

    bankHolderNameController.text = profile.bankDetails.accountHolderName;
    bankAccountController.text = profile.bankDetails.accountNumber;
    bankNameController.text = profile.bankDetails.bankName;

    // _imageUrl = profile.image;

    // bankTransitController.text = "bankDetails";
    // bankHolderNameController.text = "bankDetails";
    // bankAccountController.text = "bankDetails";
    // bankNameController.text = "bankDetails";
    _profileUploadImage = profile.image!;
    PriceCategoryModel setCategory;
    setCategory = PriceCategoryModel(
        categoryId: profile.vehicleCategory.categoryId,
        categoryCar: profile.vehicleCategory.categoryName,
        priceMin: profile.vehicleCategory.priceMin,
        seat: profile.vehicleCategory.seat,
        priceKm: profile.vehicleCategory.priceKm);
    setSelectedCategory = setCategory;
    setDefaultSelectedCategory = setCategory;
    notifyListeners();
  }

  Stream<ProfileState> updateProfileForm({
    required String url,
    required FormData data,
    // required String firstName,
    // required String lastName,
    // required String phone,
    // required String country,
    // String? image,
  }) async* {
    yield ProfileLoading();
    // final data = FormData.fromMap({
    //   'first_name': firstName,
    //   'last_name': lastName,
    //   'phone': phone,
    //   'country': country,
    //   'image': image,
    //   // 'api_token': session.sessionToken,
    //   // 'name': name,
    //   // 'phone': phone,
    //   // 'plate_number': platNumber,
    //   // 'vehicle_category_id': _selectedCategory!.categoryId,
    //   // 'car_model': carModel,
    //   // if (image != null)
    //   //   'image': await MultipartFile.fromFile(photo.path, filename: photo.name)
    // });
    final result = await updateProfile.execute(url, data);
    yield* result.fold((failure) async* {
      logMe("Failure");
      yield ProfileFailure(failure: failure.message);
    }, (data) async* {
      logMe("loaded");
      //checked category vehicle
      yield ProfileUpdateSuccess(success: data);
    });
  }

  // Stream<ProfileState> updateVehicleDetail({
  //   required String vehicleName,
  //   required String vehicleNumber,
  //   required String vehicleModel,
  //   required String insuranceNumber,
  // }) async* {
  //   yield ProfileLoading();
  //   final data = FormData.fromMap({
  //     'vehicle_type': _selectedCategory!.categoryId,
  //     'vechile_name': vehicleName,
  //     'vechile_number': vehicleNumber,
  //     'vechile_model': vehicleModel,
  //     'insurance_number': insuranceNumber
  //   });
  //   final result = await updateProfile.execute(data);
  //   yield* result.fold((failure) async* {
  //     logMe("Failure");
  //     yield ProfileFailure(failure: failure.message);
  //   }, (data) async* {
  //     logMe("loaded");
  //     //checked category vehicle
  //     yield ProfileUpdateSuccess(success: data);
  //   });
  // }

  // Stream<PriceCategoryState> fetchPriceCategory() async* {
  //   log("fetch price catagory called");
  //   yield PriceCategoryLoading();
  //   showLoading();

  //   final result = await getPriceCategory();
  //   yield* result.fold(
  //     (failure) async* {
  //       dismissLoading();
  //       yield PriceCategoryFailure(failure: failure);
  //     },
  //     (data) async* {
  //       _priceCategory = data.data;
  //       notifyListeners();
  //       dismissLoading();
  //       yield PriceCategoryLoaded(data: _priceCategory);
  //     },
  //   );
  // }

  // Stream<GetVehicleTypeState> getVehicleTypeData() async* {
  //   yield GetVehicleTypeLoading();

  //   final signupResult = await doCreateProfile.getVehicleTypes();
  //   yield* signupResult.fold((statusCode) async* {
  //     logMe('signup error $statusCode');
  //     yield GetVehicleTypeFailure(failure: statusCode.message);
  //   }, (result) async* {
  //     if (result != null) {
  //       _vehicleDataModel = result;
  //       notifyListeners();
  //       print('Type data -----> ${result.length}');
  //       yield GetVehicleTypeSuccess(data: result);
  //     } else {
  //       yield GetVehicleTypeFailure(failure: appLoc.signupFailure);
  //     }
  //   });
  // }

  /// GET VEHICLE TYPES

  getVehicleTypes() async {
    String url = '${BASE_URL}api/webservice/vehicle/categories';

    try {
      var res = await dio.get(url);

      if (res.statusCode == 200) {
        log(res.data.toString());

        VehicleTypeResponseModel data =
            VehicleTypeResponseModel.fromMap(res.data);

        _vehicleCategory = data.data;
        notifyListeners();
      }
    } catch (e) {
      log("fetch vehicle catogory types exception is:-->>  $e");
    }
  }

  Stream<UploadState> doUploadProfileApi(String image) async* {
    yield UploadLoading();

    final signupResult = await updateProfile.upload(image);
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
}
