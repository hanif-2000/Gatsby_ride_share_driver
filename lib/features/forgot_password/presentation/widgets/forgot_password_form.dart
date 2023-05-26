import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/features/forgot_password/presentation/providers/forgot_password_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/presentation/widgets/custom_text_field.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/enums.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';
import '../../../../core/utility/validation_helper.dart';
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
    final provider = context.read<ForgotPasswordProvider>();

    // Navigator.pushReplacementNamed(context, OTPPage.routeName);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const CreatePasswordPage(),
    //   ),
    // );
    provider
        .doForgotPasswordApi(
            url: 'api/webservice/password/forgot', email: email)
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
            provider.setForgetScreens(ForgetScreens.otp);
            // Navigator.pushReplacementNamed(
            //     context, CreatePasswordPage.routeName);
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
          aspectRatio: 3 / 1.4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/auth/ic_back.svg',
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: Text(
                  appLoc.resetPassword,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ).usePoppinsW6Font(),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40.0, vertical: 8),
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
        Consumer<ForgotPasswordProvider>(builder: (context, provider, _) {
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
                      if (provider.formKey.currentState!.validate()) {
                        submit(provider.emailController.text);
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
        }),
      ],
    );
  }
}
