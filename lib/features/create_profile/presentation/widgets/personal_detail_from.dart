import 'dart:io';

import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_drop_down.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/validation_helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_provider.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_state.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/widgets/image_picker_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    final provider = context.read<CreateProfileProvider>();
    provider.doCreateProfileApi('').listen((state) async {
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
            showToast(message: appLoc.pwdreset);
            provider.setCurrentStep(2);
            // Navigator.pushReplacementNamed(context, ChangePasswordPage.routeName);
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
              Text(appLoc.personalDetail,
                  textAlign: TextAlign.center,
                  style: formTextFieldStyle.copyWith(fontSize: 24)),
              largeVerticalSpacing(),
              SizedBox(
                height: 136,
                width: 136,
                child: Stack(
                  children: [
                    provider.imageFile == null
                        ? Image.asset(
                            'assets/icons/profile/ic_personal_detail.png',
                            height: 136,
                            width: 136,
                          )
                        : Container(
                            height: 136,
                            width: 136,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(
                                  File(
                                    provider.imageFilePath,
                                  ),
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                          onTap: () async {
                            ///TODO: add personal image here

                            provider
                                .showImagePicker(context: context)
                                .then((value) {
                              logMe('Image file -----> $value');
                              if (value != '') {
                                provider.profileImage = value;
                              }
                            });
                          },
                          child: SvgPicture.asset(
                            'assets/icons/profile/ic_add_image.svg',
                            height: 40,
                            width: 40,
                          )),
                    ),
                  ],
                ),
              ),
              largeVerticalSpacing(),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      placeholder: appLoc.firstName,
                      title: appLoc.firstName,
                      controller: provider.firstNameController,
                      inputType: TextInputType.name,
                      isError: provider.firstNameError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) =>
                            provider.setFirstNameError = value,
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
                      isError: provider.lastNameError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) =>
                            provider.setLastNameError = value,
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
                isError: provider.mobileNumberError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) =>
                      provider.setMobileNumberError = value,
                  typeField: TypeField.phone,
                ).validate(),
              ),
              mediumVerticalSpacing(),
              CustomDropDown(
                values: const ['India', 'United State', 'England', 'Canada'],
                selectedValue: provider.countryName,
                hint: appLoc.country,
                onChange: (value) {
                  provider.setCountryName(value);
                },
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
                  if (provider.formKey.currentState!.validate()) {
                    // provider.setCurrentStep(2);
                    submit();
                  }
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
