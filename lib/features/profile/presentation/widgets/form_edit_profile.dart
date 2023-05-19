import 'package:appkey_taxiapp_driver/core/static/assets.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/pages/change_email_page.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/profile_edit_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/profile_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/widgets/profile_image_result.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/entities/price_category.dart';
import '../../../../core/presentation/pages/splash_page.dart';
import '../../../../core/presentation/providers/home_provider.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';

import '../../../../core/presentation/widgets/custom_dialog_logout.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/static/enums.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/firebase_helper.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../../../../core/utility/validation_helper.dart';
import '../providers/profile_state.dart';

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
    return Consumer<ProfileEditProvider>(builder: (context, provider, _) {
      return Form(
        key: provider.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: ProfileImagePicker(
                          imageURL: mergePhotoUrl(provider.imageUrl),
                          provider: provider,
                        ),
                      ),
                    ),
                    CustomTextField(
                      placeholder: appLoc.name,
                      title: appLoc.name,
                      controller: provider.nameController,
                      inputType: TextInputType.name,
                      isError: provider.nameError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) => provider.setNameError = value,
                        typeField: TypeField.name,
                      ).validate(),
                    ),
                    mediumVerticalSpacing(),
                    CustomTextField(
                      placeholder: appLoc.phonenumber,
                      title: appLoc.phonenumber,
                      controller: provider.phoneController,
                      inputType: TextInputType.phone,
                      maxLength: 20,
                      isError: provider.phoneError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) => provider.setPhoneError = value,
                        typeField: TypeField.phone,
                      ).validate(),
                    ),
                    mediumVerticalSpacing(),
                    CustomTextField(
                      placeholder: appLoc.vehicleNumber,
                      title: appLoc.vehicleNumber,
                      controller: provider.vehicleController,
                      inputType: TextInputType.text,
                      isError: provider.vehicleError,
                      maxLength: 20,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) =>
                            provider.setVehicleError = value,
                        typeField: TypeField.name,
                      ).validate(),
                    ),
                    mediumVerticalSpacing(),
                    CustomTextField(
                      placeholder: appLoc.carModel,
                      title: appLoc.carModel,
                      maxLength: 40,
                      controller: provider.carModelController,
                      inputType: TextInputType.text,
                      isError: provider.carModelError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) =>
                            provider.setCarModelError = value,
                        typeField: TypeField.name,
                      ).validate(),
                    ),
                    mediumVerticalSpacing(),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            appLoc.carType,
                            textAlign: TextAlign.left,
                            style: formLabelStyle,
                          ),
                          const SizedBox(height: 5.0),
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<PriceCategory>(
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: primaryColor,
                                        size: 40,
                                      ),
                                      hint: Text(
                                        appLoc.choosetaxi,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      value: provider.selectedCategory,
                                      onChanged: (PriceCategory? item) {
                                        provider.setSelectedCategory = item;
                                        logMe(provider.selectedCategory);
                                      },
                                      items: provider.priceCategory
                                          .map((PriceCategory category) {
                                        return DropdownMenuItem<PriceCategory>(
                                            value: category,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  category.categoryCar,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '${category.seat.toString()} ${appLoc.people}',
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                )
                                              ],
                                            ));
                                      }).toList()),
                                ),
                              )),
                        ]),
                    mediumVerticalSpacing(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ChangeEmailPage.routeName,
                        );
                      },
                      child: CustomTextField(
                        enabled: false,
                        title: appLoc.emailaddress,
                        controller: provider.emailController,
                        inputType: TextInputType.emailAddress,
                        isError: provider.emailError,
                        fieldValidator: ValidationHelper(
                          loc: appLoc,
                          isError: (bool value) =>
                              provider.setEmailError = value,
                          typeField: TypeField.email,
                        ).validate(),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomButton(
                        buttonHeight:
                            MediaQuery.of(context).size.height * 0.080,
                        isRounded: true,
                        text: Text(
                          appLoc.save,
                          style: txtButtonStyle,
                        ),
                        event: () {
                          if (provider.formKey.currentState!.validate()) {
                            provider
                                .updateProfileForm(
                                    name: provider.nameController.text,
                                    phone: provider.phoneController.text,
                                    carModel: provider.carModelController.text,
                                    platNumber: provider.vehicleController.text,
                                    photo: provider.imageFile)
                                .listen((event) async {
                              switch (event.runtimeType) {
                                case ProfileLoading:
                                  showLoading();
                                  break;
                                case ProfileFailure:
                                  final msg = (event as ProfileFailure).failure;
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
                            });
                          }
                        },
                        bgColor: primaryDarkColor)
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
