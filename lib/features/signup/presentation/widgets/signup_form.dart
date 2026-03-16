import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/dimens.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/pages/create_profile.dart';
import 'package:appkey_taxiapp_driver/features/login/presentation/pages/login_page.dart';
import 'package:appkey_taxiapp_driver/features/signup/presentation/provider/signup_provider.dart';
import 'package:appkey_taxiapp_driver/features/signup/presentation/provider/signup_state.dart';
import 'package:appkey_taxiapp_driver/features/terms_and_conditions/terms_and_conditions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/static/enums.dart';
import '../../../../core/utility/validation_helper.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    // submit() {
    //   Navigator.pushReplacementNamed(context, CreateProfilePage.routeName);
    // }
 
    void submit() {
      FocusManager.instance.primaryFocus?.unfocus();
      final provider = context.read<SignupProvider>();
      provider.doSignupApi().listen((state) async {
        switch (state.runtimeType) {
          case SignupLoading:
            showLoading();
            break;
          case SignupFailure:
            final msg = (state as SignupFailure).failure;
            dismissLoading();
            showToast(message: msg);
            break;
          case SignupSuccess:
            dismissLoading();
            final session = locator<Session>();
            session.setLoggedIn = true;
            session.setIsProfileCompleted = false;
            // showToast(message: appLoc.success);
            Navigator.pushNamedAndRemoveUntil(
                context, CreateProfilePage.routeName, (route) => false);
            logMe("Authorization Token: ${session.sessionToken}");
            log("set is profile completed is:-->>  ${session.isProfileCompleted}");
            break;
        }
      });
    }

    return Consumer<SignupProvider>(
      builder: (context, provider, _) => Form(
        key: provider.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: sizeMedium,
          ),
          child: Column(
            children: [
              CustomTextField(
                prefixWidget: const Icon(Icons.email_outlined),
                placeholder: appLoc.emailaddress,
                title: appLoc.emailaddress,
                controller: provider.emailController,
                inputType: TextInputType.emailAddress,
                // fieldValidator: (value) {},
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
                // fieldValidator: (value) {},
                isError: provider.passwordError,
                onChanged: (value) {
                  provider.setPassword(value);
                },
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setPasswordError = value,
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
                // fieldValidator: (value) {},
                isError: provider.passwordConfirmError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) =>
                      provider.setPasswordConfirmError = value,
                  typeField: TypeField.confirmPassword,
                  pwd: provider.password,
                ).validate(),
              ),
              mediumVerticalSpacing(),
              Row(
                children: [
                  Transform.scale(
                    scale: 1,
                    child: Checkbox(
                      value: isChecked,
                      checkColor: Colors.white,
                      activeColor: primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: appLoc.iAgreeOn,
                      style: blactStyle.copyWith(
                        fontSize: 12,
                        color: grey7c7c7c,
                        fontWeight: FontWeight.w400,
                      ),
                      children: [
                        TextSpan(
                            text: appLoc.term + appLoc.and + appLoc.conditions,
                            style: blactStyle.copyWith(fontSize: 12),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                  context,
                                  TermsAndConditionsPage.routeName,
                                );
                              }),
                        // TextSpan(
                        //   text: appLoc.and,
                        //   style: blactStyle.copyWith(
                        //     fontSize: 12,
                        //     color: grey7c7c7c,
                        //     fontWeight: FontWeight.w400,
                        //   ),
                        // ),
                        // TextSpan(
                        //   text: appLoc.conditions,
                        //   style: blactStyle.copyWith(fontSize: 12),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
              mediumVerticalSpacing(),
              CustomButton(
                text: Text(
                  appLoc.signup,
                  style: txtButtonStyle,
                ),
                // buttonHeight: MediaQuery.of(context).size.height * 0.080,
                buttonHeight: 48,
                isRounded: true,
                event: () async {
                  provider.formKey.currentState!.validate();
                  if (provider.formKey.currentState!.validate()) {
                    if (isChecked) {
                      submit();
                    } else {
                      showToast(message: 'Please accept term and condition!');
                    }
                  }
                },
                bgColor: blackColor,
              ),
              mediumVerticalSpacing(),
              RichText(
                text: TextSpan(
                  text: appLoc.haveAccount,
                  style: blactStyle.copyWith(
                    fontSize: 14,
                    color: grey7c7c7c,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: appLoc.login,
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
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                    )
                  ],
                ),
              ),
              largeVerticalSpacing(),
            ],
          ),
        ),
      ),
    );
  }
}
