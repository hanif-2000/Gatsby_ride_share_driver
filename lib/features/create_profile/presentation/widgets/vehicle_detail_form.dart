import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_drop_down.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/validation_helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

class FormVehicleDetail extends StatefulWidget {
  const FormVehicleDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<FormVehicleDetail> createState() => _FormVehicleDetailState();
}

class _FormVehicleDetailState extends State<FormVehicleDetail> {
  void submit() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const CreatePasswordPage(),
    //   ),
    // );
    // final provider = context.read<ForgotPasswordProvider>();
    // provider.doForgotPasswordApi(email: email).listen((state) async {
    //   switch (state.runtimeType) {
    //     case ForgotPasswordLoading:
    //       showLoading();
    //       break;
    //     case ForgotPasswordFailure:
    //       final msg = (state as ForgotPasswordFailure).failure;
    //       dismissLoading();
    //       showToast(message: msg);
    //       break;
    //     case ForgotPasswordSuccess:
    //       final data = (state as ForgotPasswordSuccess).data;
    //       dismissLoading();
    //       if (data.success == 1) {
    //         showToast(message: appLoc.pwdreset);
    //         Navigator.pushReplacementNamed(context, ChangePasswordPage.routeName);
    //       } else {
    //         if (data.message == '1') {
    //           showToast(message: appLoc.emailnotmatch);
    //         } else {
    //           showToast(message: appLoc.failed);
    //         }
    //       }
    //
    //       break;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateProfileProvider>(builder: (context, provider, _) {
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
              Image.asset(
                'assets/icons/profile/ic_vehicle_detail.png',
                height: 136,
                width: 136,
              ),
              largeVerticalSpacing(),
              CustomDropDown(
                values: const [
                  'Bike',
                  'Car',
                  'Truck',
                ],
                selectedValue: null,
                hint: appLoc.vehicleType,
                onChange: (value) {},
              ),
              smallVerticalSpacing(),
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
              CustomTextField(
                placeholder: appLoc.vehicleNumber,
                title: appLoc.vehicleNumber,
                controller: provider.vehicleNumberController,
                inputType: TextInputType.number,
                isError: provider.vehicleNumberError,
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
                inputType: TextInputType.number,
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
                inputType: TextInputType.text,
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
                  // if (provider.formKey.currentState!.validate()) {
                  provider.setCurrentStep(3);
                  // submit();
                  // }
                },
                buttonHeight: 48,
                isRounded: true,
                bgColor: blackColor,
              ),
              largeVerticalSpacing(),
            ],
          ),
        ),
      );
    });
  }
}
