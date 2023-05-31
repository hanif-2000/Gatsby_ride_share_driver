import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/utility/validation_helper.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/persentation/provider/contact_us_provider.dart';
import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

class FormContactUs extends StatefulWidget {
  const FormContactUs({
    Key? key,
  }) : super(key: key);

  @override
  State<FormContactUs> createState() => _FormContactUsState();
}

class _FormContactUsState extends State<FormContactUs> {
  void submit(/*String email*/) {
    // Navigator.pushReplacementNamed(context, LoginPage.routeName);
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
    //         Navigator.pushReplacementNamed(context, LoginPage.routeName);
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
    return Consumer<ContactUsProvider>(
      builder: (context, provider, _) {
        return Form(
          key: provider.formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: sizeMedium,
            ),
            child: Column(
              children: [
                largeVerticalSpacing(),
                CustomTextField(
                  enabled: false,
                  title: appLoc.emailaddress,
                  controller: TextEditingController(),
                  inputType: TextInputType.emailAddress,
                  isError: provider.emailError,
                  fieldValidator: ValidationHelper(
                    loc: appLoc,
                    isError: (bool value) => provider.setEmailError = value,
                    typeField: TypeField.email,
                  ).validate(),
                ),
                mediumVerticalSpacing(),
                CustomTextField(
                  prefixWidget: const Icon(Icons.lock_outline),
                  placeholder: appLoc.confirmpassword,
                  title: appLoc.confirmpassword,
                  controller: TextEditingController(),
                  inputType: TextInputType.visiblePassword,
                  isSecure: true,
                  fieldValidator: (value) {},
                  // isError: provider.passwordError,
                  // fieldValidator: ValidationHelper(
                  //   loc: appLoc,
                  //   isError: (bool value) => provider.setPasswordError = value,
                  //   typeField: TypeField.password,
                  // ).validate(),
                ),
                largeVerticalSpacing(),
                CustomButton(
                    text: Text(
                      appLoc.done,
                      style: txtButtonStyle,
                    ),
                    event: () {
                      // if (provider.formKey.currentState!.validate()) {
                      submit(/*provider.emailController.text*/);
                      // }
                    },
                    buttonHeight: 48,
                    isRounded: true,
                    bgColor: blackColor)
              ],
            ),
          ),
        );
      },
    );
  }
}
