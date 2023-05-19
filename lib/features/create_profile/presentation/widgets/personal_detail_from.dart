import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_drop_down.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/validation_helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_provider.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/widgets/image_picker_tile.dart';
import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

class FormPersonalDetail extends StatefulWidget {
  const FormPersonalDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<FormPersonalDetail> createState() => _FormPersonalDetailState();
}

class _FormPersonalDetailState extends State<FormPersonalDetail> {
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
              Text(
                appLoc.personalDetail,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ).useHiraginoKakuW6Font(),
              ),
              // largeVerticalSpacing(),
              // SvgPicture.asset(
              //   'assets/icons/profile/ic_vehicle_detail.svg',
              //   height: 136,
              //   width: 136,
              // ),
              largeVerticalSpacing(),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      placeholder: appLoc.firstName,
                      title: appLoc.firstName,
                      controller: provider.firstNameController,
                      inputType: TextInputType.name,
                      isError: provider.isFirstNameError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) => provider.setFirstNameError,
                        typeField: TypeField.name,
                      ).validate(),
                    ),
                  ),
                  mediumHorizontalSpacing(),
                  Expanded(
                    child: CustomTextField(
                      placeholder: appLoc.lastName,
                      title: appLoc.lastName,
                      controller: provider.lastNameController,
                      inputType: TextInputType.name,
                      isError: provider.isFirstNameError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) => provider.setFirstNameError,
                        typeField: TypeField.name,
                      ).validate(),
                    ),
                  ),
                ],
              ),
              smallVerticalSpacing(),
              CustomTextField(
                placeholder: appLoc.mobileNumber,
                title: appLoc.mobileNumber,
                controller: provider.mobileNumberController,
                inputType: TextInputType.number,
                isError: provider.isFirstNameError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setFirstNameError,
                  typeField: TypeField.name,
                ).validate(),
              ),
              mediumVerticalSpacing(),
              CustomDropDown(
                values: const ['India', 'United State', 'England', 'Canada'],
                selectedValue: null,
                hint: appLoc.country,
                onChange: (value) {},
              ),
              mediumVerticalSpacing(),
              ImagePickerTile(
                title: appLoc.uploadDL,
              ),
              mediumVerticalSpacing(),
              ImagePickerTile(
                title: appLoc.uploadId,
              ),
              largeVerticalSpacing(),
              CustomButton(
                text: Text(
                  appLoc.next,
                  style: txtButtonStyle,
                ),
                event: () {
                  // if (provider.formKey.currentState!.validate()) {
                  provider.setCurrentStep(2);
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
