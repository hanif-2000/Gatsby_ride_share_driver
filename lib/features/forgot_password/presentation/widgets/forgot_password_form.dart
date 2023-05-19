import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/enums.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';
import '../../../../core/utility/validation_helper.dart';
import '../../../create_password/persentation/pages/change_password_page.dart';
import '../providers/forgot_password_provider.dart';

class FormForgotPassword extends StatefulWidget {
  const FormForgotPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<FormForgotPassword> createState() => _FormForgotPasswordState();
}

class _FormForgotPasswordState extends State<FormForgotPassword> {
  void submit(String email) {
    Navigator.pushReplacementNamed(context, CreatePasswordPage.routeName);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const CreatePasswordPage(),
    //   ),
    // );
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
    //         Navigator.pushReplacementNamed(context, ChangePasswordPage.routeName);
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
    return Consumer<ForgotPasswordProvider>(builder: (context, provider, _) {
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
                prefixWidget: const Icon(Icons.email_outlined),
                placeholder: appLoc.emailaddress,
                title: appLoc.emailaddress,
                controller: provider.emailController,
                inputType: TextInputType.emailAddress,
                isError: provider.emailError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setEmailError = value,
                  typeField: TypeField.email,
                ).validate(),
              ),
              largeVerticalSpacing(),
              CustomButton(
                text: Text(
                  appLoc.send,
                  style: txtButtonStyle,
                ),
                event: () {
                  // if (provider.formKey.currentState!.validate()) {
                  submit(provider.emailController.text);
                  // }
                },
                buttonHeight: 48,
                isRounded: true,
                bgColor: blackColor,
              )
            ],
          ),
        ),
      );
    });
  }
}
