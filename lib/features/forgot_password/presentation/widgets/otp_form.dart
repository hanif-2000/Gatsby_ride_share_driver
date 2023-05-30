import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/features/forgot_password/presentation/providers/forgot_password_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
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

class FormOTP extends StatefulWidget {
  const FormOTP({
    Key? key,
  }) : super(key: key);

  @override
  State<FormOTP> createState() => _FormOTPState();
}

class _FormOTPState extends State<FormOTP> {
  void submit(String email) {
    // Navigator.pushReplacementNamed(context, CreatePasswordPage.routeName);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const CreatePasswordPage(),
    //   ),
    // );
    final provider = context.read<ForgotPasswordProvider>();
    provider
        .doForgotPasswordApi(
            url: 'api/webservice/otp/verify',
            formData: FormData.fromMap({
              'email': provider.emailController.text.trim(),
              'otp': provider.pin,
              'type': 'Driver',
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
            showToast(message: appLoc.otpVerifySuccess);
            provider.setForgetScreens(ForgetScreens.password);
          } else {
            // if (data.message == '1') {
            //   showToast(message: appLoc.emailnotmatch);
            showToast(message: data.message ?? appLoc.emailnotmatch);
            // } else {
            //   showToast(message: appLoc.failed);
            // }
          }

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 24, color: primaryColor, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: greyB6B6B6),
        borderRadius: BorderRadius.circular(15),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: primaryColor, width: 2),
      borderRadius: BorderRadius.circular(15),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration,
    );
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
                    context
                        .read<ForgotPasswordProvider>()
                        .setForgetScreens(ForgetScreens.forget);
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
                  appLoc.otpVerification,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ).usePoppinsW6Font(),
                ),
              ),
              Flexible(
                fit: FlexFit.loose,
                flex: 1,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                  child: Text(
                    appLoc.enterOTP +
                        ' ' +
                        context
                            .read<ForgotPasswordProvider>()
                            .emailController
                            .text
                            .trim(),
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
                  Pinput(
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    // validator: (s) {
                    //   return s == '2222' ? null : 'Pin is incorrect';
                    // },
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) => provider.setPin(pin),
                  ),
                  largeVerticalSpacing(),
                  Text(
                    appLoc.didntReceiveOTP,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: grey7D7979,
                    ).usePoppinsW4Font(),
                  ),
                  provider.second >= 1
                      ? Text(
                          '${provider.second}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                            decoration: TextDecoration.underline,
                          ).usePoppinsW4Font(),
                        )
                      : InkWell(
                          onTap: () {
                            ///TODO: send OTP to user again
                            provider
                                .doForgotPasswordApi(
                                    url: 'api/webservice/password/forgot',
                                    formData: FormData.fromMap({
                                      'email':
                                          provider.emailController.text.trim(),
                                      'type': 'Driver',
                                    }))
                                .listen((state) async {
                              switch (state.runtimeType) {
                                case ForgotPasswordLoading:
                                  showLoading();
                                  break;
                                case ForgotPasswordFailure:
                                  final msg =
                                      (state as ForgotPasswordFailure).failure;
                                  dismissLoading();
                                  showToast(message: msg);
                                  break;
                                case ForgotPasswordSuccess:
                                  final data =
                                      (state as ForgotPasswordSuccess).data;
                                  dismissLoading();
                                  if (data.success == 1) {
                                    provider.setSecond(30);
                                    provider.otpCountDown();
                                    showToast(
                                        message:
                                            data.message ?? appLoc.otpSent);
                                  } else {
                                    showToast(
                                        message: data.message ?? appLoc.failed);
                                  }
                                  break;
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              appLoc.resendOTP,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                color: primaryColor,
                                decoration: TextDecoration.underline,
                              ).usePoppinsW4Font(),
                            ),
                          ),
                        ),
                  largeVerticalSpacing(),
                  CustomButton(
                    text: Text(
                      appLoc.verifyNow,
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
