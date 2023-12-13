import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/firebase_helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/model/vehicle_type_respose_model.dart';
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

class FormEditVehicle extends StatefulWidget {
  const FormEditVehicle({
    Key? key,
  }) : super(key: key);

  @override
  State<FormEditVehicle> createState() => _FormEditVehicleState();
}

class _FormEditVehicleState extends State<FormEditVehicle> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileEditProvider>(
      builder: (context, provider, _) {
        return WillPopScope(
          onWillPop: () async {
            if (provider.isVehicleEdit) {
              provider.setIsVehicleEdit(false);
              return false;
            } else {
              return true;
            }
          },
          child: Form(
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
                              if (provider.isVehicleEdit) {
                                provider.setIsVehicleEdit(false);
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            icon: SvgPicture.asset(
                              'assets/icons/auth/ic_back.svg',
                            ),
                          ),
                        ),
                        largeVerticalSpacing(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              appLoc.vehicleDetail,
                              style: titleNameStyle
                                  .copyWith(fontSize: 20)
                                  .usePoppinsW6Font(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Visibility(
                              visible: !provider.isVehicleEdit,
                              child: InkWell(
                                onTap: () {
                                  ///TODO: Edit vehicle detail here
                                  provider.setIsVehicleEdit(true);
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/icons/profile/ic_edit.svg'),
                                    smallHorizontalSpacing(),
                                    Text(
                                      appLoc.edit,
                                      style: titleNameStyle
                                          .copyWith(fontSize: 15)
                                          .usePoppinsW5Font(),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        largeVerticalSpacing(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              appLoc.vehicleType,
                              style: titleNameStyle
                                  .copyWith(color: greyB6B6B6, fontSize: 15)
                                  .usePoppinsW4Font(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5.0),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: grey7c7c7c.withOpacity(.8),
                                ),
                              ),
                              // decoration: BoxDecoration(
                              //   color: Colors.grey[50],
                              //   borderRadius:
                              //       const BorderRadius.all(Radius.circular(6)),
                              // ),
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<VehicleTypeDataModel>(
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: primaryColor,
                                        size: 30,
                                      ),
                                      hint: Text(
                                        provider.vehicleTypeController.text,
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      value: provider.selectedVehicle,
                                      onChanged: provider.isVehicleEdit
                                          ? (VehicleTypeDataModel? item) {
                                              provider.setSelectedVehicle =
                                                  item;

                                              provider.updateNewSelectedVehicle(
                                                  val: item!.id);

                                              log("selected vehice--> ${item.id}");

                                              // provider.selectedCategory=provider.
                                              // logMe(
                                              // "Form data validated ------------>>>>." +
                                              //     provider
                                              //         .selectedVehicle!.id
                                              //         .toString());
                                            }
                                          : null,
                                      items: provider.vehicleCategory
                                          .map((VehicleTypeDataModel category) {
                                        return DropdownMenuItem<
                                            VehicleTypeDataModel>(
                                          value: category,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                category.category,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                              // const SizedBox(
                                              //   width: 5,
                                              // ),
                                              // Text(
                                              //   '${category.seat.toString()} ${appLoc.people}',
                                              //   style: const TextStyle(
                                              //     color: Colors.black,
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        );
                                      }).toList()),
                                ),
                              ),
                            ),
                          ],
                        ),
                        largeVerticalSpacing(),
                        Text(
                          appLoc.vehicleName,
                          style: titleNameStyle
                              .copyWith(color: greyB6B6B6, fontSize: 15)
                              .usePoppinsW4Font(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        CustomTextField(
                          enabled: provider.isVehicleEdit,
                          placeholder: appLoc.vehicleName,
                          title: appLoc.vehicleName,
                          controller: provider.vehicleNameController,
                          inputType: TextInputType.name,
                          isError: provider.vehicleNameError,
                          fieldValidator: ValidationHelper(
                            loc: appLoc,
                            isError: (bool value) =>
                                provider.setVehicleNameError = value,
                            typeField: TypeField.name,
                          ).validate(),
                        ),
                        largeVerticalSpacing(),
                        Text(
                          appLoc.vehicleNumber,
                          style: titleNameStyle
                              .copyWith(color: greyB6B6B6, fontSize: 15)
                              .usePoppinsW4Font(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        CustomTextField(
                          textCapitalization: TextCapitalization.characters,
                          enabled: provider.isVehicleEdit,
                          placeholder: appLoc.vehicleNumber,
                          title: appLoc.vehicleNumber,
                          controller: provider.vehicleNumberController,
                          inputType: TextInputType.name,
                          isError: provider.vehicleNumberError,
                          fieldValidator: ValidationHelper(
                            loc: appLoc,
                            isError: (bool value) =>
                                provider.setVehicleNumberError = value,
                            typeField: TypeField.name,
                          ).validate(),
                        ),
                        largeVerticalSpacing(),
                        Text(
                          appLoc.vehicleModel,
                          style: titleNameStyle
                              .copyWith(color: greyB6B6B6, fontSize: 15)
                              .usePoppinsW4Font(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        CustomTextField(
                          enabled: provider.isVehicleEdit,
                          placeholder: appLoc.vehicleModel,
                          title: appLoc.vehicleModel,
                          controller: provider.vehicleModelController,
                          inputType: TextInputType.name,
                          maxLength: 20,
                          isError: provider.vehicleModelError,
                          fieldValidator: ValidationHelper(
                            loc: appLoc,
                            isError: (bool value) =>
                                provider.setVehicleModelError = value,
                            typeField: TypeField.name,
                          ).validate(),
                        ),
                        largeVerticalSpacing(),
                        Text(
                          appLoc.insuranceNumber,
                          style: titleNameStyle
                              .copyWith(color: greyB6B6B6, fontSize: 15)
                              .usePoppinsW4Font(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        CustomTextField(
                          enabled: provider.isVehicleEdit,
                          placeholder: appLoc.insuranceNumber,
                          title: appLoc.insuranceNumber,
                          controller: provider.vehicleInsuranceController,
                          inputType: TextInputType.number,
                          maxLength: 20,
                          isError: provider.vehicleInsuranceError,
                          fieldValidator: ValidationHelper(
                            loc: appLoc,
                            isError: (bool value) =>
                                provider.setVehicleInsuranceError = value,
                            typeField: TypeField.name,
                          ).validate(),
                        ),
                        largeVerticalSpacing(),
                        Visibility(
                          visible: provider.isVehicleEdit,
                          child: CustomButton(
                            text: Text(
                              appLoc.next,
                              style: txtButtonStyle,
                            ),
                            buttonHeight: 48,
                            isRounded: true,
                            bgColor: blackColor,
                            event: () {
                              if (provider.formKey.currentState!.validate()) {
                                log("Form data validated ------------>>>>.");
                                provider
                                    .updateProfileForm(
                                  url:
                                      'api/webservice/driver/vehicle/details/add',
                                  data: FormData.fromMap({
                                    'vehicle_type':
                                        provider.newSelectedVehicle == 0
                                            ? provider
                                                .selectedCategory!.categoryId
                                            : provider.newSelectedVehicle,
                                    'vehicle_name': provider
                                        .vehicleNameController.text
                                        .trim(),
                                    'vehicle_number': provider
                                        .vehicleNumberController.text
                                        .trim(),
                                    'vehicle_model': provider
                                        .vehicleModelController.text
                                        .trim(),
                                    'insurance_number': provider
                                        .vehicleInsuranceController.text,
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
                                          session.setSessionCategoryId =
                                              provider
                                                  .selectedCategory!.categoryId
                                                  .toString();
                                          if (homeProvider.isOnline) {
                                            await FirebaseHelper.setTopicDriver(
                                                    '1')
                                                .then((_) {});
                                          } else {
                                            await FirebaseHelper.setTopicDriver(
                                                    '0')
                                                .then((_) {});
                                          }
                                        }

                                        showToast(
                                            message: appLoc.profileupdated);
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
                        ),
                        largeVerticalSpacing(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
