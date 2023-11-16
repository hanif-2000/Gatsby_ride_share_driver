import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_driver/core/utility/firebase_helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/image_picker_helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/upload_state.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/profile_edit_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/profile_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/static/enums.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';
import '../../../../core/utility/validation_helper.dart';

class FormEditProfile extends StatefulWidget {
  const FormEditProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<FormEditProfile> createState() => _FormEditProfileState();
}

class _FormEditProfileState extends State<FormEditProfile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileEditProvider>(
      builder: (context, provider, _) {
        return Form(
          key: provider.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon:
                              SvgPicture.asset('assets/icons/auth/ic_back.svg'),
                        ),
                      ),
                      // Center(
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(bottom: 20),
                      //     child: ProfileImagePicker(
                      //       imageURL: mergePhotoUrl(provider.imageUrl),
                      //       provider: provider,
                      //     ),
                      //   ),
                      // ),
                      Center(
                        child: SizedBox(
                          height: 121,
                          width: 121,
                          child: Stack(
                            children: [
                              provider.profileUploadImage == ''
                                  ? Image.asset(
                                      'assets/icons/profile/ic_personal_detail.png',
                                      height: 136,
                                      width: 136,
                                    )
                                  : Container(
                                      height: 136,
                                      width: 136,
                                      decoration: BoxDecoration(
                                        color: greyF9F9F9,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: NetworkImage(BASE_URL +
                                              provider.profileUploadImage),
                                          // image: FileImage(
                                          //   File(
                                          //     provider.profileImage,
                                          //   ),
                                          // ),
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
                                                  (state as UploadFailure)
                                                      .failure;
                                              dismissLoading();
                                              showToast(message: msg);
                                              break;
                                            case UploadSuccess:
                                              final imageName =
                                                  (state as UploadSuccess).data;
                                              // showToast(
                                              //     message: appLoc.success);
                                              provider.setProfileUploadImage(
                                                  imageName!);
                                              logMe(
                                                  'Image Name ---> ${provider.profileUploadImage}');
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
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    padding: const EdgeInsets.all(9),
                                    decoration: const BoxDecoration(
                                      color: greyF4F4F4,
                                      shape: BoxShape.circle,
                                    ),
                                    child: SvgPicture.asset(
                                      'assets/icons/profile/ic_camera.svg',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      largeVerticalSpacing(),

                      Text(
                        appLoc.firstName,
                        style: titleNameStyle
                            .copyWith(color: greyB6B6B6, fontSize: 15)
                            .usePoppinsW4Font(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      CustomTextField(
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
                      mediumVerticalSpacing(),

                      Text(
                        appLoc.lastName,
                        style: titleNameStyle
                            .copyWith(color: greyB6B6B6, fontSize: 15)
                            .usePoppinsW4Font(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      CustomTextField(
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
                      mediumVerticalSpacing(),
                      Text(
                        appLoc.mobileNumber,
                        style: titleNameStyle
                            .copyWith(color: greyB6B6B6, fontSize: 15)
                            .usePoppinsW4Font(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      CustomTextField(
                        placeholder: appLoc.phonenumber,
                        title: appLoc.phonenumber,
                        controller: provider.phoneController,
                        inputType: TextInputType.phone,
                        maxLength: 20,
                        isError: provider.phoneError,
                        fieldValidator: ValidationHelper(
                          loc: appLoc,
                          isError: (bool value) =>
                              provider.setPhoneError = value,
                          typeField: TypeField.phone,
                        ).validate(),
                      ),

                      mediumVerticalSpacing(),
                      Text(
                        appLoc.country,
                        style: titleNameStyle
                            .copyWith(color: greyB6B6B6, fontSize: 15)
                            .usePoppinsW4Font(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      CustomTextField(
                          placeholder: appLoc.country,
                          title: appLoc.country,
                          controller: TextEditingController(text: 'Canada'),
                          inputType: TextInputType.phone,
                          maxLength: 20,
                          isError: provider.phoneError,
                          fieldValidator: null),
                      // CustomDropDown(
                      //   values: const [
                      //     'India',
                      //     'United State',
                      //     'England',
                      //     'Canada'
                      //   ],
                      //   selectedValue: provider.countryName,
                      //   hint: appLoc.country,
                      //   onChange: (value) {
                      //     provider.setCountryName(value);
                      //   },
                      // ),
                      // mediumVerticalSpacing(),
                      // CustomTextField(
                      //   placeholder: appLoc.vehicleNumber,
                      //   title: appLoc.vehicleNumber,
                      //   controller: provider.vehicleController,
                      //   inputType: TextInputType.text,
                      //   isError: provider.vehicleError,
                      //   maxLength: 20,
                      //   fieldValidator: ValidationHelper(
                      //     loc: appLoc,
                      //     isError: (bool value) =>
                      //         provider.setVehicleError = value,
                      //     typeField: TypeField.name,
                      //   ).validate(),
                      // ),
                      // mediumVerticalSpacing(),
                      // CustomTextField(
                      //   placeholder: appLoc.carModel,
                      //   title: appLoc.carModel,
                      //   maxLength: 40,
                      //   controller: provider.carModelController,
                      //   inputType: TextInputType.text,
                      //   isError: provider.carModelError,
                      //   fieldValidator: ValidationHelper(
                      //     loc: appLoc,
                      //     isError: (bool value) =>
                      //         provider.setCarModelError = value,
                      //     typeField: TypeField.name,
                      //   ).validate(),
                      // ),
                      // mediumVerticalSpacing(),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.stretch,
                      //   children: [
                      //     Text(
                      //       appLoc.carType,
                      //       textAlign: TextAlign.left,
                      //       style: formLabelStyle,
                      //     ),
                      //     const SizedBox(height: 5.0),
                      //     Container(
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey[50],
                      //         borderRadius:
                      //             const BorderRadius.all(Radius.circular(6)),
                      //       ),
                      //       child: ButtonTheme(
                      //         alignedDropdown: true,
                      //         child: DropdownButtonHideUnderline(
                      //           child: DropdownButton<PriceCategory>(
                      //               icon: const Icon(
                      //                 Icons.keyboard_arrow_down,
                      //                 color: primaryColor,
                      //                 size: 40,
                      //               ),
                      //               hint: Text(
                      //                 appLoc.choosetaxi,
                      //                 style:
                      //                     const TextStyle(color: Colors.grey),
                      //               ),
                      //               value: provider.selectedCategory,
                      //               onChanged: (PriceCategory? item) {
                      //                 provider.setSelectedCategory = item;
                      //                 logMe(provider.selectedCategory);
                      //               },
                      //               items: provider.priceCategory
                      //                   .map((PriceCategory category) {
                      //                 return DropdownMenuItem<PriceCategory>(
                      //                   value: category,
                      //                   child: Row(
                      //                     mainAxisSize: MainAxisSize.max,
                      //                     mainAxisAlignment:
                      //                         MainAxisAlignment.spaceBetween,
                      //                     children: <Widget>[
                      //                       Text(
                      //                         category.categoryCar,
                      //                         style: const TextStyle(
                      //                           color: Colors.black,
                      //                         ),
                      //                       ),
                      //                       const SizedBox(
                      //                         width: 5,
                      //                       ),
                      //                       Text(
                      //                         '${category.seat.toString()} ${appLoc.people}',
                      //                         style: const TextStyle(
                      //                           color: Colors.black,
                      //                         ),
                      //                       )
                      //                     ],
                      //                   ),
                      //                 );
                      //               }).toList()),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // mediumVerticalSpacing(),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.pushNamed(
                      //       context,
                      //       ChangeEmailPage.routeName,
                      //     );
                      //   },
                      //   child: CustomTextField(
                      //     enabled: false,
                      //     title: appLoc.emailaddress,
                      //     controller: provider.emailController,
                      //     inputType: TextInputType.emailAddress,
                      //     isError: provider.emailError,
                      //     fieldValidator: ValidationHelper(
                      //       loc: appLoc,
                      //       isError: (bool value) =>
                      //           provider.setEmailError = value,
                      //       typeField: TypeField.email,
                      //     ).validate(),
                      //   ),
                      // ),

                      const SizedBox(
                        height: 30,
                      ),

                      CustomButton(
                        text: Text(
                          appLoc.next,
                          style: txtButtonStyle,
                        ),
                        buttonHeight: 48,
                        isRounded: true,
                        bgColor: blackColor,
                        event: () {
                          if (provider.formKey.currentState!.validate()) {
                            provider
                                .updateProfileForm(
                              url: 'api/webservice/driver/update-profile',
                              data: FormData.fromMap({
                                'first_name':
                                    provider.firstNameController.text.trim(),
                                'last_name':
                                    provider.lastNameController.text.trim(),
                                'phone': provider.phoneController.text.trim(),
                                'country': 'Canada',
                                'image': provider.profileUploadImage,
                              }),
                            )
                                .listen(
                              (event) async {
                                switch (event.runtimeType) {
                                  case ProfileLoading:
                                    showLoading();
                                    break;
                                  case ProfileFailure:
                                    final msg =
                                        (event as ProfileFailure).failure;
                                    showToast(message: msg);
                                    dismissLoading();
                                    break;
                                  case ProfileUpdateSuccess:
                                    dismissLoading();
                                    if (provider.selectedCategory !=
                                        provider.defaultSelectedCategory) {
                                      await FirebaseHelper.unsubTopic()
                                          .then((_) {});
                                      final session = locator<Session>();
                                      var homeProvider =
                                          Provider.of<HomeProvider>(context,
                                              listen: false);
                                      session.setSessionCategoryId = provider
                                          .selectedCategory!.categoryId
                                          .toString();
                                      if (homeProvider.isOnline) {
                                        await FirebaseHelper.setTopicDriver('1')
                                            .then((_) {});
                                      } else {
                                        await FirebaseHelper.setTopicDriver('0')
                                            .then((_) {});
                                      }
                                    }

                                    showToast(message: appLoc.profileupdated);
                                    Navigator.pop(context, true);

                                    break;
                                  default:
                                    showLoading();
                                    break;
                                }
                              },
                            );
                          }
                        },
                      ),
                      largeVerticalSpacing(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
