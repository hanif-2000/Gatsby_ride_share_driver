import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/change_email_provider.dart';
import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';
import '../providers/profile_state.dart';

class FormChangeEmail extends StatefulWidget {
  const FormChangeEmail({
    Key? key,
  }) : super(key: key);

  @override
  State<FormChangeEmail> createState() => _FormChangeEmailState();
}

class _FormChangeEmailState extends State<FormChangeEmail> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeEmailProvider>(builder: (context, provider, _) {
      return Form(
        key: provider.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                        child: Text(
                          appLoc.pleaseenteranewemailaddress,
                          style: formLabelHeaderStyle,
                        ),
                      ),
                    ),
                    CustomTextField(
                      title: appLoc.newemailaddress,
                      placeholder: appLoc.pleaseenteranewemailaddress,
                      controller: provider.emailController,
                      inputType: TextInputType.emailAddress,
                      isError: provider.emailError,
                      fieldValidator: (val) {
                        if (val == '') {
                          return appLoc.mustnotempty;
                        }
                        return null;
                      },
                    ),
                    mediumVerticalSpacing(),
                    CustomTextField(
                      title: appLoc.reenteremailaddress,
                      placeholder: appLoc.reenteremailaddress,
                      controller: provider.emailConfirmController,
                      inputType: TextInputType.emailAddress,
                      isError: provider.emailError,
                      fieldValidator: (val) {
                        if (val == '') {
                          return appLoc.mustnotempty;
                        }
                        if (val != provider.emailController.text) {
                          return appLoc.emailnotmatch;
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
                                .updateEmaileForm(
                                    email: provider.emailController.text)
                                .listen((event) {
                              switch (event.runtimeType) {
                                case ProfileLoading:
                                  showLoading();
                                  break;
                                case ProfileFailure:
                                  showToast(message: appLoc.failed);
                                  dismissLoading();
                                  break;
                                case ProfileUpdateSuccess:
                                  dismissLoading();
                                  showToast(message: appLoc.emailaddresschange);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);

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
