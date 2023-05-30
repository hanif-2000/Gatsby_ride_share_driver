import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/core/utility/validation_helper.dart';
import 'package:appkey_taxiapp_driver/features/forgot_password/presentation/providers/forgot_password_provider.dart';
import 'package:appkey_taxiapp_driver/features/forgot_password/presentation/providers/forgot_password_state.dart';
import 'package:appkey_taxiapp_driver/features/login/presentation/pages/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

class FormCreatePassword extends StatefulWidget {
  const FormCreatePassword({
    Key? key,
  }) : super(key: key);

  @override
  State<FormCreatePassword> createState() => _FormCreatePasswordState();
}

class _FormCreatePasswordState extends State<FormCreatePassword> {
  void submit() {
    final provider = context.read<ForgotPasswordProvider>();
    provider
        .doForgotPasswordApi(
            url: 'api/webservice/password/reset',
            formData: FormData.fromMap({
              'email': provider.emailController.text.trim(),
              'password': provider.passwordConfirmController.text.trim(),
            }))
        .listen((state) async {
      switch (state.runtimeType) {
        case ForgotPasswordLoading:
          showLoading();
          break;
        case ForgotPasswordFailure:
          final msg = (state as ForgotPasswordFailure).failure;
          dismissLoading();
          showToast(message: msg);
          break;
        case ForgotPasswordSuccess:
          final data = (state as ForgotPasswordSuccess).data;
          dismissLoading();
          if (data.success == 1) {
            showToast(message: appLoc.pwdreset);
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
          } else {
            if (data.message == '1') {
              showToast(message: appLoc.emailnotmatch);
            } else {
              showToast(message: appLoc.failed);
            }
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        AspectRatio(
          aspectRatio: 3 / 1.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    context
                        .read<ForgotPasswordProvider>()
                        .setForgetScreens(ForgetScreens.otp);
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/auth/ic_back.svg',
                  ),
                ),
              ),
              mediumVerticalSpacing(),
              Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: Text(
                  appLoc.resetPassword,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ).usePoppinsW6Font(),
                ),
              ),
              smallVerticalSpacing(),
              Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                  child: Text(
                    appLoc.pleaseEnterYourEmailAddress,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: grey7D7979,
                    ).usePoppinsW4Font(),
                  ),
                ),
              ),
            ],
          ),
        ),
        Consumer<ForgotPasswordProvider>(
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
                      prefixWidget: const Icon(Icons.lock_outline),
                      placeholder: appLoc.newPassword,
                      title: appLoc.newPassword,
                      controller: provider.passwordController,
                      inputType: TextInputType.visiblePassword,
                      isSecure: true,
                      isError: provider.passwordError,
                      fieldValidator: ValidationHelper(
                        loc: appLoc,
                        isError: (bool value) =>
                            provider.setPasswordError = value,
                        typeField: TypeField.password,
                      ).validate(),
                    ),
                    mediumVerticalSpacing(),
                    CustomTextField(
                      prefixWidget: const Icon(Icons.lock_outline),
                      placeholder: appLoc.confirmpassword,
                      title: appLoc.confirmpassword,
                      controller: provider.passwordConfirmController,
                      inputType: TextInputType.visiblePassword,
                      isSecure: true,
                      isError: provider.passwordConfirmError,
                      fieldValidator: ValidationHelper(
                              loc: appLoc,
                              isError: (bool value) =>
                                  provider.setPasswordConfirmError = value,
                              typeField: TypeField.confirmPassword,
                              pwd: provider.passwordController.text.trim())
                          .validate(),
                    ),
                    largeVerticalSpacing(),
                    CustomButton(
                      text: Text(
                        appLoc.done,
                        style: txtButtonStyle,
                      ),
                      event: () {
                        if (provider.formKey.currentState!.validate()) {
                          submit(/*provider.emailController.text*/);
                        }
                      },
                      buttonHeight: 48,
                      isRounded: true,
                      bgColor: blackColor,
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
