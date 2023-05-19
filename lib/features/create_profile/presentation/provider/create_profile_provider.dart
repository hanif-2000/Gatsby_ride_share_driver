import 'package:appkey_taxiapp_driver/core/presentation/providers/form_provider.dart';
import 'package:flutter/cupertino.dart';

class CreateProfileProvider extends FormProvider {
  int currentStep = 1;

  bool _isFirstNameError = false;

  bool get isFirstNameError => _isFirstNameError;

  setFirstNameError(bool value) {
    _isFirstNameError = value;
    notifyListeners();
  }

  setCurrentStep(int step) {
    currentStep = step;
    notifyListeners();
  }
}
