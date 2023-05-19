import 'package:appkey_taxiapp_driver/core/data/models/price_category_model.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/profile/domain/usecases/update_profile.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/profile_state.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/domain/entities/price_category.dart';
import '../../../../core/domain/usecases/get_price_category.dart';
import '../../../../core/presentation/providers/form_provider.dart';
import '../../../../core/presentation/providers/price_category_state.dart';
import '../../../../core/utility/injection.dart';
import '../../data/models/profile_response_model.dart';

class ProfileEditProvider extends FormProvider {
  final UpdateProfile updateProfile;
  final GetPriceCategory getPriceCategory;
  final session = locator<Session>();

  String? _imageUrl;
  String get imageUrl => _imageUrl ?? '';
  static List<PriceCategory> _priceCategory = [];
  PriceCategory? _selectedCategory;
  PriceCategory? _defaultSelectedCategory;

  List<PriceCategory> get priceCategory => _priceCategory;
  PriceCategory? get selectedCategory => _selectedCategory;
  PriceCategory? get defaultSelectedCategory => _defaultSelectedCategory;

  set setSelectedCategory(val) {
    _selectedCategory = val;
    notifyListeners();
  }

  set setDefaultSelectedCategory(val) {
    _defaultSelectedCategory = val;
    notifyListeners();
  }

  ProfileEditProvider(
      {required this.updateProfile, required this.getPriceCategory});

  setupTextControllerValues(ProfileDataModel profile) {
    fetchPriceCategory().listen((event) {});

    nameController.text = profile.name;
    emailController.text = profile.email;
    phoneController.text = profile.phoneNumber;
    carModelController.text = profile.carModel;
    vehicleController.text = profile.plateNumber;
    _imageUrl = profile.image;
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

  Stream<ProfileState> updateProfileForm(
      {required String name,
      required String platNumber,
      required String carModel,
      required String phone,
      XFile? photo}) async* {
    yield ProfileLoading();
    final data = FormData.fromMap({
      'api_token': session.sessionToken,
      'name': name,
      'phone': phone,
      'plate_number': platNumber,
      'vehicle_category_id': _selectedCategory!.categoryId,
      'car_model': carModel,
      if (photo != null)
        'image': await MultipartFile.fromFile(photo.path, filename: photo.name)
    });
    final result = await updateProfile.execute(data);
    yield* result.fold((failure) async* {
      logMe("Failureeeee");
      yield ProfileFailure(failure: failure.message);
    }, (data) async* {
      logMe("loadeddd");
      //checked category vehicle

      yield ProfileUpdateSuccess(success: data);
    });
  }

  Stream<PriceCategoryState> fetchPriceCategory() async* {
    yield PriceCategoryLoading();
    showLoading();

    final result = await getPriceCategory();
    yield* result.fold(
      (failure) async* {
        dismissLoading();
        yield PriceCategoryFailure(failure: failure);
      },
      (data) async* {
        _priceCategory = data.data;
        notifyListeners();
        dismissLoading();
        yield PriceCategoryLoaded(data: _priceCategory);
      },
    );
  }
}
