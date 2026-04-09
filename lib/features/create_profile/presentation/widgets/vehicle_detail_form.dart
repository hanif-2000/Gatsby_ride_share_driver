import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_drop_down.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/utility/validation_helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_provider.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_state.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/get_vehicle_type_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

class FormVehicleDetail extends StatefulWidget {
  const FormVehicleDetail({
    super.key,
  });

  @override
  State<FormVehicleDetail> createState() => _FormVehicleDetailState();
}

class _FormVehicleDetailState extends State<FormVehicleDetail> {
  void submit() {
    final provider = context.read<CreateProfileProvider>();
    provider.doCreateProfileApi('api/webservice/driver/vehicle/details/add', {
      "vehicle_category_id": provider.selectedVehicleType!.id,
      "vehicle_name": provider.vehicleNameController.text.trim(),
      "vehicle_number": provider.vehicleNumberController.text.trim(),
      "vehicle_model": provider.vehicleModelController.text.trim(),
      "insurance_number": provider.vehicleInsuranceController.text.trim(),
    }).listen((state) async {
      switch (state.runtimeType) {
        case CreateProfileLoading:
          showLoading();
          break;
        case CreateProfileFailure:
          final msg = (state as CreateProfileFailure).failure;
          dismissLoading();
          showToast(message: msg);
          break;
        case CreateProfileSuccess:
          final data = (state as CreateProfileSuccess).data;
          dismissLoading();
          if (data.success == 1) {
            provider.setCurrentStep(3);
          } else {
            if (data.message == '1') {
              showToast(message: appLoc.emailnotmatch);
            } else {
              showToast(message: appLoc.failed);
            }
          }

          break;
      }
    });
  }

  void getVehicleTypes() {
    final provider = context.read<CreateProfileProvider>();
    if (provider.vehicleTypeList.isNotEmpty) {
      return;
    }
    provider.getVehicleTypeData().listen((state) async {
      switch (state.runtimeType) {
        case GetVehicleTypeLoading:
          showLoading();
          break;
        case GetVehicleTypeFailure:
          final msg = (state as GetVehicleTypeFailure).failure;
          dismissLoading();
          showToast(message: msg);
          break;
        case GetVehicleTypeSuccess:
          // final data = (state as GetVehicleTypeSuccess).data;
          dismissLoading();
          // if (data.success == 1) {
          //   provider.setCurrentStep(3);
          // } else {
          // if (data.message == '1') {
          //   showToast(message: appLoc.emailnotmatch);
          // } else {
          //   showToast(message: appLoc.failed);
          // }
          // }

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateProfileProvider>(builder: (context, provider, _) {
      getVehicleTypes();
      return Form(
        key: provider.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: sizeMedium,
          ),
          child: Column(
            children: [
              largeVerticalSpacing(),
              Text(appLoc.vehicleDetail,
                  textAlign: TextAlign.center,
                  style: formTextFieldStyle.copyWith(fontSize: 24)),
              largeVerticalSpacing(),
              SvgPicture.asset(
                'assets/icons/profile/ic_vehicle_detail.svg',
                height: 136,
                width: 136,
              ),
              largeVerticalSpacing(),

              //Vehicle  type List
              CustomTypeDropDown(
                values: provider.vehicleTypeList,
                selectedValue: provider.selectedVehicleType,
                hint: appLoc.vehicleType,
                onChange: (value) {
                  provider.setSelectedVehicleType(value);
                },
              ),
              smallVerticalSpacing(),

              // Vehicle name
              CustomTextField(
                placeholder: appLoc.vehicleName,
                title: appLoc.vehicleName,
                controller: provider.vehicleNameController,
                inputType: TextInputType.name,
                isError: provider.vehicleNameError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setVehicleNameError = value,
                  typeField: TypeField.name,
                ).validate(),
              ),
              smallVerticalSpacing(),

              //Vehicle number
              CustomTextField(
                placeholder: appLoc.vehicleNumber,
                title: appLoc.vehicleNumber,
                controller: provider.vehicleNumberController,
                inputType: TextInputType.text,
                isError: provider.vehicleNumberError,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) =>
                      provider.setVehicleNumberError = value,
                  typeField: TypeField.name,
                ).validate(),
              ),
              smallVerticalSpacing(),
              CustomTextField(
                placeholder: appLoc.vehicleModel,
                title: appLoc.vehicleModel,
                controller: provider.vehicleModelController,
                inputType: TextInputType.text,
                isError: provider.vehicleModelError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) =>
                      provider.setVehicleModelError = value,
                  typeField: TypeField.name,
                ).validate(),
              ),
              CustomTextField(
                placeholder: appLoc.insuranceNumber,
                title: appLoc.insuranceNumber,
                controller: provider.vehicleInsuranceController,
                inputType: TextInputType.number,
                isError: provider.vehicleInsuranceError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) =>
                      provider.setVehicleInsuranceError = value,
                  typeField: TypeField.name,
                ).validate(),
              ),
              largeVerticalSpacing(),
              CustomButton(
                text: Text(
                  appLoc.next,
                  style: txtButtonStyle,
                ),
                event: () {
                  if (provider.selectedVehicleType == null) {
                    showToast(message: 'Please select vehicle type!');
                    return;
                  } else if (provider.formKey.currentState!.validate()) {
                    // provider.setCurrentStep(3);
                    submit();
                  }
                },
                buttonHeight: 48,
                isRounded: true,
                bgColor: blackColor,
              ),
              // largeVerticalSpacing(),

              smallVerticalSpacing(),

// // Login Button

//               CustomButton(
//                 text: Text(
//                   appLoc.login,
//                   style: txtButtonStyle,
//                 ),
//                 event: () {
//                   final session = locator<Session>();

//                   session.setIsProfileCompleted = true;

//                   Navigator.pushNamedAndRemoveUntil(
//                       context, LoginPage.routeName, (route) => false);
//                   log("click on login button");
//                 },
//                 buttonHeight: 48,
//                 isRounded: true,
//                 bgColor: blackColor,
//               ),
            ],
          ),
        ),
      );
    });
  }
}
