import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/change_email_provider.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/change_password_provider.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';

import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

import '../providers/profile_state.dart';

class FormChangePassword extends StatefulWidget {
  const FormChangePassword({
    Key? key,
  }) : super(key: key);

  @override
  State<FormChangePassword> createState() => _FormChangePasswordState();
}

class _FormChangePasswordState extends State<FormChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChangePasswordProvider>(builder: (context, provider, _) {
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
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Center(
                        child: Text(
                          appLoc.enteryournewpwd,
                          style: formLabelHeaderStyle,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      title: appLoc.oldPassword,
                      placeholder: appLoc.oldPassword,
                      controller: provider.currentPasswordController,
                      inputType: TextInputType.visiblePassword,
                      isSecure: true,
                      isError: provider.passwordError,
                      fieldValidator: (val) {
                        if (val == '') {
                          return appLoc.mustnotempty;
                        }
                        return null;
                      },
                    ),
                    mediumVerticalSpacing(),
                    CustomTextField(
                      placeholder: appLoc.newPassword,
                      title: appLoc.newPassword,
                      controller: provider.passwordController,
                      inputType: TextInputType.visiblePassword,
                      isSecure: true,
                      isError: provider.passwordError,
                      fieldValidator: (val) {
                        if (val == '') {
                          return appLoc.mustnotempty;
                        }
                        return null;
                      },
                    ),
                    mediumVerticalSpacing(),
                    CustomTextField(
                      placeholder: appLoc.confirmpassword,
                      title: appLoc.confirmpassword,
                      controller: provider.passwordConfirmController,
                      inputType: TextInputType.visiblePassword,
                      isSecure: true,
                      isError: provider.passwordError,
                      fieldValidator: (val) {
                        if (val == '') {
                          return appLoc.mustnotempty;
                        }
                        if (val != provider.passwordController.text) {
                          return appLoc.confirmationpwdnotmatch;
                        }
                        return null;
                      },
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
                                .updatePasswordForm(
                                    currentPwd:
                                        provider.currentPasswordController.text,
                                    newPwd: provider.passwordController.text,
                                    confirmPwd:
                                        provider.passwordConfirmController.text)
                                .listen((event) {
                              switch (event.runtimeType) {
                                case ProfileLoading:
                                  showLoading();
                                  break;
                                case ProfileFailure:
                                  final data = (event as ProfileFailure);
                                  if (data.failure == '4') {
                                    showToast(
                                        message: appLoc.oldPasswordValidation);
                                  } else {
                                    showToast(message: appLoc.failed);
                                  }
                                  dismissLoading();
                                  break;
                                case ChangePasswordSuccess:
                                  final data =
                                      (event as ChangePasswordSuccess).data;
                                  dismissLoading();
                                  if (data.success == 1) {
                                    showToast(message: appLoc.success);
                                    Navigator.pop(context);
                                  } else {
                                    showToast(message: appLoc.failed);
                                  }

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
