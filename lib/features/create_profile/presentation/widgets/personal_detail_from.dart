import 'dart:io';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_drop_down.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/utility/image_picker_helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/validation_helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_provider.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_state.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/widgets/image_picker_tile.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/upload_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
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
    provider.doCreateProfileApi('api/webservice/driver/profile/details/add', {
      "first_name": provider.firstNameController.text.trim(),
      "last_name": provider.lastNameController.text.trim(),
      "phone": provider.mobileNumberController.text.trim(),
      "country": provider.countryName,
      "city": provider.cityController.text.trim(),
      "state": provider.stateController.text.trim(),
      "address": provider.addressController.text.trim(),
      "postal_code": provider.postalCodeController.text.trim(),
      "dob": provider.dobController.text.trim(),
      "id_number": provider.idNumberController.text.trim(),
      "driving_licence": provider.dlImageUploadNameFront,
      "driving_licence_back": provider.dlImageUploadNameBack,
      // "profile_photo": provider.profileUploadName,
      "image": provider.profileUploadName,
      "id_proof": provider.idProofImageUploadName,
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
            provider.setCurrentStep(2);
            // Navigator.pushReplacementNamed(context, ChangePasswordPage.routeName);
          } else {
            // if (data.message == '1') {
            //   showToast(message: appLoc.emailnotmatch);
            // } else {
            showToast(message: data.message ?? appLoc.failed);
            // }
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
                    provider.profileImage == ''
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
                                    provider.profileImage,
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
                          ImagePickerHelper.showPicker(
                            context: context,
                            imagePicker: provider.imagePicker,
                            successCallBack: (file) {
                              provider.setProfileImage(file!.path);
                              provider
                                  .doUploadProfileApi(file.path)
                                  .listen((state) async {
                                switch (state.runtimeType) {
                                  case UploadLoading:
                                    showLoading();
                                    break;
                                  case UploadFailure:
                                    final msg =
                                        (state as UploadFailure).failure;
                                    dismissLoading();
                                    showToast(message: msg);
                                    break;
                                  case UploadSuccess:
                                    final imageName =
                                        (state as UploadSuccess).data;
                                    // showToast(message: appLoc.success);
                                    provider.setProfileUploadName(imageName!);
                                    logMe(
                                        'Image Name ---> ${provider.profileUploadName}');
                                    dismissLoading();
                                    break;
                                }
                              });
                            },
                            failedCallBack: (error) {
                              showToast(message: error);
                              provider.setProfileImage('');
                            },
                          );
                        },
                        child: SvgPicture.asset(
                          'assets/icons/profile/ic_add_image.svg',
                          height: 40,
                          width: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              largeVerticalSpacing(),
              Row(
                children: [
                  //First Name
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

                  //Last Name
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

              //Mobile Number
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
              smallVerticalSpacing(),

              //Address
              CustomTextField(
                placeholder: "Address",
                title: "Address",
                controller: provider.addressController,
                inputType: TextInputType.text,
                isError: provider.addressError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setAddressError = value,
                  typeField: TypeField.address,
                ).validate(),
              ),
              smallVerticalSpacing(),

              //Postal code and Date Of Birth
              Row(
                children: [
                  //Postal Code
                  Expanded(
                    child: CustomTextField(
                      placeholder: "Postal Code",
                      title: "Postal Code",
                      controller: provider.postalCodeController,
                      inputType: TextInputType.phone,
                      isError: provider.postalCodeError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) =>
                            provider.setPostalCodeError = value,
                        typeField: TypeField.postalCode,
                      ).validate(),
                    ),
                  ),
                  mediumHorizontalSpacing(),

                  //DOB
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        logMe("-->> ON Tap Called");
                        DateTime? pickedDate = await showDatePicker(
                            context: context, //context of current state
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);

                          provider.setdobController = formattedDate;

                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                        } else {
                          print("Date is not selected");
                        }
                      },
                      child: IgnorePointer(
                        child: CustomTextField(
                          isReadOnly: true,
                          placeholder: "Date of Birth",
                          title: "Date of Birth",
                          controller: provider.dobController,
                          inputType: TextInputType.name,
                          isError: provider.dobError,
                          fieldValidator: ValidationHelper(
                            loc: appLoc,
                            isError: (bool value) =>
                                provider.setDobError = value,
                            typeField: TypeField.dob,
                          ).validate(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              smallVerticalSpacing(),

              //City and State Selection
              Row(
                children: [
                  //Select City
                  Expanded(
                    child: CustomTextField(
                      placeholder: "City",
                      title: "City",
                      controller: provider.cityController,
                      inputType: TextInputType.name,
                      isError: provider.cityError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) => provider.setCityError = value,
                        typeField: TypeField.city,
                      ).validate(),
                    ),
                  ),
                  mediumHorizontalSpacing(),

                  //Select State
                  Expanded(
                    child: CustomTextField(
                      placeholder: "State",
                      title: "State",
                      controller: provider.stateController,
                      inputType: TextInputType.name,
                      isError: provider.stateError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) => provider.setStateError = value,
                        typeField: TypeField.state,
                      ).validate(),
                    ),
                  ),
                ],
              ),
              mediumVerticalSpacing(),
              //Country Selection
              CustomDropDown(
                values: const ['India', 'United State', 'England', 'Canada'],
                selectedValue: provider.countryName,
                hint: appLoc.country,
                onChange: (value) {
                  provider.setCountryName(value);
                },
              ),
              mediumVerticalSpacing(),

              //ID Number
              CustomTextField(
                placeholder: "Enter ID Number",
                title: "Enter ID Number",
                controller: provider.idNumberController,
                inputType: TextInputType.number,
                isError: provider.idNumberError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setIdNumberError = value,
                  typeField: TypeField.idNumber,
                ).validate(),
              ),
              smallVerticalSpacing(),

              //Upload driving License Front
              ImagePickerTile(
                title: appLoc.uploadDL + " (Front)",
                selectedImage: provider.dlImageFront,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  ImagePickerHelper.showPicker(
                    context: context,
                    imagePicker: provider.imagePicker,
                    successCallBack: (file) {
                      provider.setDlImageFront(file!.path);
                      provider
                          .doUploadProfileApi(file.path)
                          .listen((state) async {
                        switch (state.runtimeType) {
                          case UploadLoading:
                            showLoading();
                            break;
                          case UploadFailure:
                            final msg = (state as UploadFailure).failure;
                            dismissLoading();
                            showToast(message: msg);
                            break;
                          case UploadSuccess:
                            final imageName = (state as UploadSuccess).data;
                            // showToast(message: appLoc.success);
                            provider.setDlImageUploadNameFront(imageName!);
                            logMe(
                                'Image Name ---> ${provider.profileUploadName}');
                            dismissLoading();
                            break;
                        }
                      });
                    },
                    failedCallBack: (error) {
                      showToast(message: error);
                      provider.setProfileImage('');
                    },
                  );
                },
                onDelete: () {
                  provider.setDlImageFront('');

                  provider.setDlImageUploadNameFront('');
                },
              ),
              mediumVerticalSpacing(),

              //Upload driving License Back
              ImagePickerTile(
                title: appLoc.uploadDL + " (Back)",
                selectedImage: provider.dlImageBack,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  ImagePickerHelper.showPicker(
                    context: context,
                    imagePicker: provider.imagePicker,
                    successCallBack: (file) {
                      provider.setDlImageBack(file!.path);
                      provider
                          .doUploadProfileApi(file.path)
                          .listen((state) async {
                        switch (state.runtimeType) {
                          case UploadLoading:
                            showLoading();
                            break;
                          case UploadFailure:
                            final msg = (state as UploadFailure).failure;
                            dismissLoading();
                            showToast(message: msg);
                            break;
                          case UploadSuccess:
                            final imageName = (state as UploadSuccess).data;
                            // showToast(message: appLoc.success);
                            provider.setDlImageUploadNameBack(imageName!);
                            logMe(
                                'Image Name ---> ${provider.profileUploadName}');
                            dismissLoading();
                            break;
                        }
                      });
                    },
                    failedCallBack: (error) {
                      showToast(message: error);
                      provider.setProfileImage('');
                    },
                  );
                },
                onDelete: () {
                  provider.setDlImageBack('');
                  provider.setDlImageUploadNameBack('');
                },
              ),
              mediumVerticalSpacing(),

              //Upload Id Proof
              ImagePickerTile(
                title: appLoc.uploadId,
                selectedImage: provider.idProofImage,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  ImagePickerHelper.showPicker(
                    context: context,
                    imagePicker: provider.imagePicker,
                    successCallBack: (file) {
                      provider.setIdProofImage(file!.path);
                      provider
                          .doUploadProfileApi(file.path)
                          .listen((state) async {
                        switch (state.runtimeType) {
                          case UploadLoading:
                            showLoading();
                            break;
                          case UploadFailure:
                            final msg = (state as UploadFailure).failure;
                            dismissLoading();
                            showToast(message: msg);
                            break;
                          case UploadSuccess:
                            final imageName = (state as UploadSuccess).data;
                            // showToast(message: appLoc.success);
                            provider.setIdProofImageUploadName(imageName!);
                            logMe(
                                'Image Name ---> ${provider.profileUploadName}');
                            dismissLoading();
                            break;
                        }
                      });
                    },
                    failedCallBack: (error) {
                      showToast(message: error);
                      provider.setProfileImage('');
                    },
                  );
                },
                onDelete: () {
                  provider.setIdProofImage('');
                  provider.setIdProofImageUploadName('');
                },
              ),
              largeVerticalSpacing(),

              //Next Button
              CustomButton(
                text: Text(
                  appLoc.next,
                  style: txtButtonStyle,
                ),
                event: () {
                  // provider.setCurrentStep(2);
                  if (provider.profileUploadName == '') {
                    showToast(message: 'Please select profile image!');
                  } else if (provider.formKey.currentState!.validate()) {
                    if (provider.countryName == null) {
                      showToast(message: 'Please select country!');
                    } else if (provider.dlImageUploadNameFront == '') {
                      showToast(
                          message: 'Please upload Front Driving Licence!');
                    } else if (provider.dlImageUploadNameBack == '') {
                      showToast(message: 'Please upload Back Driving Licence!');
                    } else if (provider.idProofImageUploadName == '') {
                      showToast(message: 'Please upload ID proof!');
                    } else {
                      submit();
                    }
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
