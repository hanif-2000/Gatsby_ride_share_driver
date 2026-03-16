import 'dart:developer';
import 'dart:io';

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
import 'package:flutter/services.dart';
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
    
    // === LOG: SUBMIT API BODY ===
    final requestBody = {
      "first_name": provider.firstNameController.text.trim(),
      "last_name": provider.lastNameController.text.trim(),
      "phone": provider.mobileNumberController.text.trim(),
      "country": 'CA',
      "city": provider.cityController.text.trim(),
      "state": provider.stateController.text.trim(),
      "address": provider.addressController.text.trim(),
      "postal_code": provider.postalCodeController.text.trim(),
      "dob": provider.dobController.text.trim(),
      "id_number": provider.idNumberController.text.trim(),
      "driving_licence": provider.dlImageUploadNameFront,
      "driving_licence_back": provider.dlImageUploadNameBack,
      "image": provider.profileUploadName,
      "id_proof": provider.idProofImageUploadName,
    };
    
    log("╔════════════════════════════════════════════════════════════");
    log("║ SUBMIT PROFILE API CALLED");
    log("╠════════════════════════════════════════════════════════════");
    log("║ Endpoint: api/webservice/driver/profile/details/add");
    log("╠════════════════════════════════════════════════════════════");
    log("║ REQUEST BODY:");
    requestBody.forEach((key, value) {
      log("║   $key: $value");
    });
    log("╚════════════════════════════════════════════════════════════");
    
    provider.doCreateProfileApi('api/webservice/driver/profile/details/add', requestBody).listen((state) async {
      switch (state.runtimeType) {
        case CreateProfileLoading:
          log(">>> SUBMIT API: Loading...");
          showLoading();
          break;
        case CreateProfileFailure:
          final msg = (state as CreateProfileFailure).failure;
          log(">>> SUBMIT API: FAILURE - $msg");
          dismissLoading();
          showToast(message: msg);
          break;
        case CreateProfileSuccess:
          final data = (state as CreateProfileSuccess).data;
          log(">>> SUBMIT API: SUCCESS");
          log(">>> Response success: ${data.success}");
          log(">>> Response message: ${data.message}");
          dismissLoading();
          if (data.success == 1) {
            provider.setCurrentStep(2);
          } else {
            showToast(message: data.message ?? appLoc.failed);
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
                          ImagePickerHelper.showPicker(
                            context: context,
                            imagePicker: provider.imagePicker,
                            successCallBack: (path) {
                              if(path == null){
                                return;
                              }
                              
                              // === LOG: PROFILE IMAGE UPLOAD ===
                              log("╔════════════════════════════════════════════════════════════");
                              log("║ PROFILE IMAGE UPLOAD");
                              log("╠════════════════════════════════════════════════════════════");
                              log("║ File Path: $path");
                              try {
                                final file = File(path);
                                log("║ File Exists: ${file.existsSync()}");
                                if (file.existsSync()) {
                                  log("║ File Size: ${file.lengthSync()} bytes");
                                  log("║ File Size (MB): ${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB");
                                  log("║ File Extension: ${path.split('.').last}");
                                }
                              } catch (e) {
                                log("║ File Check Error: $e");
                              }
                              log("╚════════════════════════════════════════════════════════════");
                              
                              provider.setProfileImage(path);
                              provider.doUploadProfileApi(path).listen((state) async {
                                switch (state.runtimeType) {
                                  case UploadLoading:
                                    log(">>> PROFILE UPLOAD: Loading...");
                                    showLoading();
                                    break;
                                  case UploadFailure:
                                    final msg = (state as UploadFailure).failure;
                                    log(">>> PROFILE UPLOAD: FAILURE - $msg");
                                    dismissLoading();
                                    showToast(message: msg);
                                    break;
                                  case UploadSuccess:
                                    final imageName = (state as UploadSuccess).data;
                                    log(">>> PROFILE UPLOAD: SUCCESS");
                                    log(">>> Image Name received: $imageName");
                                    provider.setProfileUploadName(imageName!);
                                    logMe('Image Name ---> ${provider.profileUploadName}');
                                    dismissLoading();
                                    break;
                                }
                              });
                            },
                            failedCallBack: (error) {
                              log(">>> PROFILE IMAGE PICKER: FAILED - $error");
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
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                      ],
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
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                        FilteringTextInputFormatter.deny(RegExp("[0-9]")),
                      ],
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
                      inputType: TextInputType.text,
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
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now());

                        if (pickedDate != null) {
                          print(pickedDate);
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);

                          provider.setdobController = formattedDate;

                          print(formattedDate);
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
                      placeholder: "Province",
                      title: "Province",
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
              CustomTextField(
                placeholder: "Canada",
                title: "Canada",
                isReadOnly: true,
                controller: TextEditingController(text: "Canada"),
                inputType: TextInputType.number,
                isError: provider.idNumberError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setIdNumberError = value,
                  typeField: TypeField.idNumber,
                ).validate(),
              ),
              mediumVerticalSpacing(),

              //ID Number
              CustomTextField(
                placeholder: "Enter Driving License Number",
                title: "Enter Driving License Number",
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
                      if(file == null){
                        return;
                      }
                      
                      // === LOG: DL FRONT IMAGE UPLOAD ===
                      log("╔════════════════════════════════════════════════════════════");
                      log("║ DL FRONT IMAGE UPLOAD");
                      log("╠════════════════════════════════════════════════════════════");
                      log("║ File Path: $file");
                      try {
                        final fileObj = File(file);
                        log("║ File Exists: ${fileObj.existsSync()}");
                        if (fileObj.existsSync()) {
                          log("║ File Size: ${fileObj.lengthSync()} bytes");
                          log("║ File Size (MB): ${(fileObj.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB");
                          log("║ File Extension: ${file.split('.').last}");
                        }
                      } catch (e) {
                        log("║ File Check Error: $e");
                      }
                      log("╚════════════════════════════════════════════════════════════");
                      
                      provider.setDlImageFront(file);
                      provider.doUploadProfileApi(file).listen((state) async {
                        switch (state.runtimeType) {
                          case UploadLoading:
                            log(">>> DL FRONT UPLOAD: Loading...");
                            showLoading();
                            break;
                          case UploadFailure:
                            final msg = (state as UploadFailure).failure;
                            log(">>> DL FRONT UPLOAD: FAILURE - $msg");
                            dismissLoading();
                            showToast(message: msg);
                            break;
                          case UploadSuccess:
                            final imageName = (state as UploadSuccess).data;
                            log(">>> DL FRONT UPLOAD: SUCCESS");
                            log(">>> Image Name received: $imageName");
                            provider.setDlImageUploadNameFront(imageName!);
                            logMe('Image Name ---> ${provider.profileUploadName}');
                            dismissLoading();
                            break;
                        }
                      });
                    },
                    failedCallBack: (error) {
                      log(">>> DL FRONT IMAGE PICKER: FAILED - $error");
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
                      if(file == null){
                        return;
                      }
                      
                      // === LOG: DL BACK IMAGE UPLOAD ===
                      log("╔════════════════════════════════════════════════════════════");
                      log("║ DL BACK IMAGE UPLOAD");
                      log("╠════════════════════════════════════════════════════════════");
                      log("║ File Path: $file");
                      try {
                        final fileObj = File(file);
                        log("║ File Exists: ${fileObj.existsSync()}");
                        if (fileObj.existsSync()) {
                          log("║ File Size: ${fileObj.lengthSync()} bytes");
                          log("║ File Size (MB): ${(fileObj.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB");
                          log("║ File Extension: ${file.split('.').last}");
                        }
                      } catch (e) {
                        log("║ File Check Error: $e");
                      }
                      log("╚════════════════════════════════════════════════════════════");
                      
                      provider.setDlImageBack(file);
                      provider.doUploadProfileApi(file).listen((state) async {
                        switch (state.runtimeType) {
                          case UploadLoading:
                            log(">>> DL BACK UPLOAD: Loading...");
                            showLoading();
                            break;
                          case UploadFailure:
                            final msg = (state as UploadFailure).failure;
                            log(">>> DL BACK UPLOAD: FAILURE - $msg");
                            dismissLoading();
                            showToast(message: msg);
                            break;
                          case UploadSuccess:
                            final imageName = (state as UploadSuccess).data;
                            log(">>> DL BACK UPLOAD: SUCCESS");
                            log(">>> Image Name received: $imageName");
                            provider.setDlImageUploadNameBack(imageName!);
                            logMe('Image Name ---> ${provider.profileUploadName}');
                            dismissLoading();
                            break;
                        }
                      });
                    },
                    failedCallBack: (error) {
                      log(">>> DL BACK IMAGE PICKER: FAILED - $error");
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

              //Next Button
              CustomButton(
                text: Text(
                  appLoc.next,
                  style: txtButtonStyle,
                ),
                event: () {
                  log("╔════════════════════════════════════════════════════════════");
                  log("║ NEXT BUTTON PRESSED - VALIDATION CHECK");
                  log("╠════════════════════════════════════════════════════════════");
                  log("║ Profile Image Name: ${provider.profileUploadName}");
                  log("║ DL Front Image Name: ${provider.dlImageUploadNameFront}");
                  log("║ DL Back Image Name: ${provider.dlImageUploadNameBack}");
                  log("║ ID Proof Image Name: ${provider.idProofImageUploadName}");
                  log("╚════════════════════════════════════════════════════════════");
                  
                  if (provider.profileUploadName == '') {
                    showToast(message: 'Please select profile image!');
                  } else if (provider.formKey.currentState!.validate()) {
                    if (provider.dlImageUploadNameFront == '') {
                      showToast(message: 'Please upload Front Driving Licence!');
                    } else if (provider.dlImageUploadNameBack == '') {
                      showToast(message: 'Please upload Back Driving Licence!');
                    } else {
                      log("short country code is:==>>" + provider.shortCountryName.toString());
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