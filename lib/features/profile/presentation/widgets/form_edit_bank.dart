import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/firebase_helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
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

class FormEditBank extends StatefulWidget {
  const FormEditBank({
    Key? key,
  }) : super(key: key);

  @override
  State<FormEditBank> createState() => _FormEditBankState();
}

class _FormEditBankState extends State<FormEditBank> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileEditProvider>(
      builder: (context, provider, _) {
        return WillPopScope(
          onWillPop: () async {
            if (provider.isBankEdit) {
              provider.setIsBankEdit(false);
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
                              if (provider.isBankEdit) {
                                provider.setIsBankEdit(false);
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
                              appLoc.bankDetail,
                              style: titleNameStyle
                                  .copyWith(fontSize: 20)
                                  .usePoppinsW6Font(),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Visibility(
                              visible: !provider.isBankEdit,
                              child: InkWell(
                                onTap: () {
                                  ///TODO: Edit vehicle detail here
                                  provider.setIsBankEdit(true);
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
                        mediumVerticalSpacing(),
                        Text(
                          appLoc.bankName,
                          style: titleNameStyle
                              .copyWith(color: greyB6B6B6, fontSize: 15)
                              .usePoppinsW4Font(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        CustomTextField(
                          enabled: provider.isBankEdit,
                          placeholder: appLoc.bankName,
                          title: appLoc.bankName,
                          controller: provider.bankNameController,
                          inputType: TextInputType.name,
                          isError: provider.bankNameError,
                          fieldValidator: ValidationHelper(
                            loc: appLoc,
                            isError: (bool value) =>
                                provider.setBankNameError = value,
                            typeField: TypeField.name,
                          ).validate(),
                        ),
                        largeVerticalSpacing(),
                        Text(
                          appLoc.accountNumber,
                          style: titleNameStyle
                              .copyWith(color: greyB6B6B6, fontSize: 15)
                              .usePoppinsW4Font(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        CustomTextField(
                          enabled: provider.isBankEdit,
                          placeholder: appLoc.accountNumber,
                          title: appLoc.accountNumber,
                          controller: provider.bankAccountController,
                          inputType: TextInputType.number,
                          isError: provider.bankAccountError,
                          fieldValidator: ValidationHelper(
                            loc: appLoc,
                            isError: (bool value) =>
                                provider.setBankAccountError = value,
                            typeField: TypeField.name,
                          ).validate(),
                        ),
                        largeVerticalSpacing(),
                        Text(
                          appLoc.accountHolderName,
                          style: titleNameStyle
                              .copyWith(color: greyB6B6B6, fontSize: 15)
                              .usePoppinsW4Font(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        CustomTextField(
                          enabled: provider.isBankEdit,
                          placeholder: appLoc.accountHolderName,
                          title: appLoc.accountHolderName,
                          controller: provider.bankHolderNameController,
                          inputType: TextInputType.name,
                          maxLength: 20,
                          isError: provider.bankHolderNameError,
                          fieldValidator: ValidationHelper(
                            loc: appLoc,
                            isError: (bool value) =>
                                provider.setBankHolderNameError = value,
                            typeField: TypeField.name,
                          ).validate(),
                        ),
                        largeVerticalSpacing(),
                        Text(
                          "Transit Number",
                          style: titleNameStyle
                              .copyWith(color: greyB6B6B6, fontSize: 15)
                              .usePoppinsW4Font(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        //Transit number
                        CustomTextField(
                          enabled: provider.isBankEdit,
                          placeholder: "Transit Number",
                          title: appLoc.ifscCode,
                          controller: provider.bankTransitController,
                          inputType: TextInputType.number,
                          maxLength: 20,
                          isError: provider.bankTransitError,
                          fieldValidator: ValidationHelper(
                            loc: appLoc,
                            isError: (bool value) =>
                                provider.setBankAccountError = value,
                            typeField: TypeField.name,
                          ).validate(),
                        ),
                        largeVerticalSpacing(),

                        Text(
                          "Institution Number",
                          style: titleNameStyle
                              .copyWith(color: greyB6B6B6, fontSize: 15)
                              .usePoppinsW4Font(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        //Transit number
                        CustomTextField(
                          enabled: provider.isBankEdit,
                          placeholder: "Institution Number",
                          title: "Institution",
                          controller: provider.bankInstitutionController,
                          inputType: TextInputType.number,
                          maxLength: 20,
                          isError: provider.bankTransitError,
                          fieldValidator: ValidationHelper(
                            loc: appLoc,
                            isError: (bool value) =>
                                provider.setBankAccountError = value,
                            typeField: TypeField.name,
                          ).validate(),
                        ),
                        largeVerticalSpacing(),

                        Visibility(
                          visible: provider.isBankEdit,
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
                                provider
                                    .updateProfileForm(
                                  url: 'api/webservice/driver/bank/details/add',
                                  data: FormData.fromMap({
                                    "bank_name":
                                        provider.bankNameController.text.trim(),
                                    "account_number": provider
                                        .bankAccountController.text
                                        .trim(),
                                    "account_holder_name": provider
                                        .bankHolderNameController.text
                                        .trim(),
                                    "transit_number": provider
                                        .bankTransitController.text
                                        .trim(),
                                    "institution_number": provider
                                        .bankInstitutionController.text
                                        .trim(),
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
