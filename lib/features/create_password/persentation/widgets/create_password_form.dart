import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/features/login/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';

class FormCreatePassword extends StatefulWidget {
  const FormCreatePassword({
    Key? key,
  }) : super(key: key);

  @override
  State<FormCreatePassword> createState() => _FormCreatePasswordState();
}

class _FormCreatePasswordState extends State<FormCreatePassword> {
  void submit(/*String email*/) {
    Navigator.pushReplacementNamed(context, LoginPage.routeName);
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
    return
        // Consumer<ForgotPasswordProvider>(builder: (context, provider, _) {
        // return Form(
        //   key: provider.formKey,
        //   child:
        Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: sizeMedium,
      ),
      child: Column(
        children: [
          largeVerticalSpacing(),
          CustomTextField(
            prefixWidget: const Icon(Icons.lock_outline),
            placeholder: appLoc.newPassword,
            title: appLoc.newPassword,
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
      //     ),
      //   );
      // },
    );
  }
}
