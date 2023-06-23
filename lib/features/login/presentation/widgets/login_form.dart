import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/dimens.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/forgot_password/presentation/pages/forgot_password_page.dart';
import 'package:appkey_taxiapp_driver/features/signup/presentation/pages/signup_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/static/enums.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../../../../core/utility/validation_helper.dart';
import '../providers/login_provider.dart';
import '../providers/login_state.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  void submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    final provider = context.read<LoginProvider>();
    provider.doLoginApi().listen((state) async {
      switch (state.runtimeType) {
        case LoginLoading:
          showLoading();
          break;
        case LoginFailure:
          final msg = (state as LoginFailure).failure;
          dismissLoading();
          showToast(message: msg);
          break;
        case LoginSuccess:
          dismissLoading();
          final session = locator<Session>();
          session.setLoggedIn = true;
          session.setIsProfileCompleted = true;
          // showToast(message: appLoc.success);
          Navigator.pushNamedAndRemoveUntil(
              context, HomePage.routeName, (route) => false);
          logMe("Authorization Token: ${session.sessionToken}");
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, provider, _) => Form(
        key: provider.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: sizeMedium,
          ),
          child: Column(
            children: [
              CustomTextField(
                // prefixWidget: SvgPicture.asset('assets/icons/auth/ic_gmail.svg', height: 12, width: 12,),
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
              mediumVerticalSpacing(),
              CustomTextField(
                prefixWidget: const Icon(Icons.lock_outline),
                placeholder: appLoc.password,
                title: appLoc.password,
                controller: provider.passwordController,
                inputType: TextInputType.visiblePassword,
                isSecure: true,
                isError: provider.passwordError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setPasswordError = value,
                  typeField: TypeField.password,
                ).validate(),
              ),
              mediumVerticalSpacing(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        ForgotPasswordPage.routeName,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        appLoc.forgotpassword,
                        style: blactStyle.copyWith(
                            color: grey7c7c7c, fontSize: fontMedium),
                      ),
                    ),
                  )
                ],
              ),
              mediumVerticalSpacing(),
              CustomButton(
                text: Text(
                  appLoc.login,
                  style: txtButtonStyle,
                ),
                // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                buttonHeight: 48,
                isRounded: true,
                event: () async {
                  if (provider.formKey.currentState!.validate()) {
                    submit();
                  }
                },
                bgColor: blackColor,
              ),
              largeVerticalSpacing(),
              RichText(
                text: TextSpan(
                  text: appLoc.dontHaveAccount,
                  style: blactStyle.copyWith(
                    fontSize: 14,
                    color: grey7c7c7c,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                        text: appLoc.signup,
                        style: blactStyle.copyWith(fontSize: 14),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Navigator.pushNamed(
                            //   context,
                            //   SignUpPage.routeName,
                            // );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpPage(),
                              ),
                            );
                          })
                  ],
                ),
              ),
              largeVerticalSpacing(),
              // Row(
              //   children: [
              //     const Flexible(
              //       fit: FlexFit.loose,
              //       flex: 1,
              //       child: Divider(),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //       child: Text(
              //         'Or login with',
              //         textAlign: TextAlign.center,
              //         style: formTextFieldStyle.copyWith(
              //             fontSize: 15,
              //             color: greyA2A0A8,
              //             fontWeight: FontWeight.w400),
              //       ),
              //     ),
              //     const Flexible(
              //       fit: FlexFit.loose,
              //       flex: 1,
              //       child: Divider(),
              //     ),
              //   ],
              // ),
              // largeVerticalSpacing(),
              // CustomButton(
              //   text: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       SvgPicture.asset('assets/icons/auth/ic_facebook.svg'),
              //       mediumHorizontalSpacing(),
              //       Text(
              //         appLoc.login_with_facebook,
              //         style: txtButtonStyle,
              //       ),
              //     ],
              //   ),
              //   // buttonHeight: MediaQuery.of(context).size.height * 0.080,
              //   buttonHeight: 48,
              //   isRounded: true,
              //   event: () async {},
              //   bgColor: blue3B5998,
              // ),
              // largeVerticalSpacing(),
            ],
          ),
        ),
      ),
    );
  }
}
