import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../utility/helper.dart';
import '../../utility/image_picker_helper.dart';

class FormProvider with ChangeNotifier {
  // initial
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _carModelController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailConfirmController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  ///Personal Detail
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileNumberController = TextEditingController();

  ///Vehicle Detail
  final _vehicleNameController = TextEditingController();
  final _vehicleNumberController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleInsuranceController = TextEditingController();

  ///Bank Detail
  final _bankNameController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _bankHolderNameController = TextEditingController();
  final _bankIFSCCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _emailError = false;
  bool _emailConfirmError = false;
  bool _passwordError = false;
  bool _passwordConfirmError = false;
  bool _phoneError = false;
  bool _carModelError = false;
  bool _vehicleError = false;
  bool _nameError = false;

  ///Personal Detail
  bool _firstNameError = false;
  bool _lastNameError = false;
  bool _mobileNumberError = false;

  ///Vehicle Detail
  bool _vehicleNameError = false;
  bool _vehicleNumberError = false;
  bool _vehicleModelError = false;
  bool _vehicleInsuranceError = false;

  ///Bank Detail
  bool _bankNameError = false;
  bool _bankAccountError = false;
  bool _bankHolderNameError = false;
  bool _bankIFSCCodeError = false;

  final _imagePicker = ImagePicker();
  dynamic _imagePickerError;
  XFile? _imageFile;

  // setter

  set setEmailError(val) {
    _emailError = val;
    notifyListeners();
  }

  set setCarModelError(val) {
    _carModelError = val;
    notifyListeners();
  }

  set setEmailConfirmError(val) {
    _emailConfirmError = val;
    notifyListeners();
  }

  set setPhoneError(val) {
    _phoneError = val;
    notifyListeners();
  }

  set setPasswordError(val) {
    _passwordError = val;
    notifyListeners();
  }

  set setPasswordConfirmError(val) {
    _passwordConfirmError = val;
    notifyListeners();
  }

  set setNameError(val) {
    _nameError = val;
    notifyListeners();
  }

  set setImageFile(XFile? file) {
    _imageFile = file;
    notifyListeners();
  }

  set setVehicleError(val) {
    _vehicleError = val;
    notifyListeners();
  }

  set setImageError(err) {
    _imagePickerError = err;
    notifyListeners();
  }

  ///Personal detail
  set setFirstNameError(err) {
    _firstNameError = err;
    notifyListeners();
  }

  set setLastNameError(err) {
    _lastNameError = err;
    notifyListeners();
  }

  set setMobileNumberError(err) {
    _mobileNumberError = err;
    notifyListeners();
  }

  ///Vehicle Detail
  set setVehicleNameError(bool err) {
    _vehicleNameError = err;
    notifyListeners();
  }

  set setVehicleNumberError(err) {
    _vehicleNumberError = err;
    notifyListeners();
  }

  set setVehicleModelError(err) {
    _vehicleModelError = err;
    notifyListeners();
  }

  set setVehicleInsuranceError(err) {
    _vehicleInsuranceError = err;
    notifyListeners();
  }

  ///Bank Detail
  set setBankNameError(err) {
    _bankNameError = err;
    notifyListeners();
  }

  set setBankHolderNameError(err) {
    _bankHolderNameError = err;
    notifyListeners();
  }

  set setBankAccountError(err) {
    _bankAccountError = err;
    notifyListeners();
  }

  set setBankISCCodeError(err) {
    _bankIFSCCodeError = err;
    notifyListeners();
  }

  // getter

  TextEditingController get phoneController => _phoneController;

  TextEditingController get emailController => _emailController;

  TextEditingController get carModelController => _carModelController;

  TextEditingController get vehicleController => _vehicleController;

  TextEditingController get emailConfirmController => _emailConfirmController;

  TextEditingController get nameController => _nameController;

  TextEditingController get passwordController => _passwordController;

  TextEditingController get currentPasswordController =>
      _currentPasswordController;

  TextEditingController get passwordConfirmController =>
      _passwordConfirmController;

  TextEditingController get firstNameController => _firstNameController;

  TextEditingController get lastNameController => _lastNameController;

  TextEditingController get mobileNumberController => _mobileNumberController;

  TextEditingController get vehicleNameController => _vehicleNameController;

  TextEditingController get vehicleNumberController => _vehicleNumberController;

  TextEditingController get vehicleModelController => _vehicleModelController;

  TextEditingController get vehicleInsuranceController =>
      _vehicleInsuranceController;

  TextEditingController get bankNameController => _bankNameController;

  TextEditingController get bankAccountController => _bankAccountController;

  TextEditingController get bankHolderNameController =>
      _bankHolderNameController;

  TextEditingController get bankIFSCCodeController => _bankIFSCCodeController;

  GlobalKey<FormState> get formKey => _formKey;

  bool get emailError => _emailError;

  bool get passwordError => _passwordError;

  bool get passwordConfirmError => _passwordConfirmError;

  bool get emailConfirmError => _emailConfirmError;

  bool get nameError => _nameError;

  bool get carModelError => _carModelError;

  bool get vehicleError => _vehicleError;

  bool get phoneError => _phoneError;

  XFile? get imageFile => _imageFile;

  String get imageFilePath => _imageFile?.path ?? '';

  dynamic get imagePickerError => _imagePickerError;

  ///Personal Detail
  bool get firstNameError => _firstNameError;

  bool get lastNameError => _lastNameError;

  bool get mobileNumberError => _mobileNumberError;

  ///Vehicle Detail
  bool get vehicleNameError => _vehicleNameError;

  bool get vehicleNumberError => _vehicleNumberError;

  bool get vehicleModelError => _vehicleModelError;

  bool get vehicleInsuranceError => _vehicleInsuranceError;

  ///Bank Detail
  bool get bankNameError => _bankNameError;

  bool get bankAccountError => _bankAccountError;

  bool get bankHolderNameError => _bankHolderNameError;

  bool get bankIFSCCodeError => _bankIFSCCodeError;

  ImagePicker get imagePicker => _imagePicker;

  // method
  refresh() => notifyListeners();

  refreshEmail() {
    _emailConfirmController.clear();
    _emailController.clear();
    notifyListeners();
  }

  refreshPassword() {
    _passwordConfirmController.clear();
    _currentPasswordController.clear();
    _passwordController.clear();
    notifyListeners();
  }

  refreshPersonalDetail() {
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileNumberController.clear();
    notifyListeners();
  }

  refreshVehicleDetail() {
    _vehicleModelController.clear();
    _vehicleInsuranceController.clear();
    _vehicleNameController.clear();
    _vehicleNumberController.clear();
    notifyListeners();
  }

  refreshBankDetail() {
    _bankIFSCCodeController.clear();
    _bankHolderNameController.clear();
    _bankAccountController.clear();
    _bankNameController.clear();
    notifyListeners();
  }

  refreshRegister() {
    _passwordController.clear();
    _emailController.clear();
    _nameController.clear();
    _phoneController.clear();
    notifyListeners();
  }

  Future<String> showImagePicker({required BuildContext context}) async {
    ImagePickerHelper.showPicker(
      context: context,
      imagePicker: _imagePicker,
      successCallBack: (file) {
        setImageFile = file;
        logMe('${file?.name}:${file?.path}');
        return file!.path;
      },
      failedCallBack: (error) {
        logMe(error);
        showToast(message: error);
        setImageError = error;
        setImageFile = null;
        return '';
      },
    );
    return '';
  }
}
