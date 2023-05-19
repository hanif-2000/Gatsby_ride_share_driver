import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/dimens.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/pages/create_profile.dart';
import 'package:appkey_taxiapp_driver/features/forgot_password/presentation/pages/forgot_password_page.dart';
import 'package:appkey_taxiapp_driver/features/login/presentation/pages/login_page.dart';
import 'package:appkey_taxiapp_driver/features/login/presentation/providers/login_provider.dart';
import 'package:appkey_taxiapp_driver/features/signup/presentation/provider/signup_provider.dart';
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
    submit() {
      Navigator.pushReplacementNamed(context, CreateProfilePage.routeName);
    }
    return
        // Consumer<LoginProvider>(
        // builder: (context, provider, _) =>
        //     Form(
        // key: provider.formKey,
        // child:
        Padding(
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
            controller: TextEditingController(),
            inputType: TextInputType.emailAddress,
            fieldValidator: (value) {},
            // isError: provider.emailError,
            // fieldValidator: ValidationHelper(
            //   loc: appLoc,
            //   isError: (bool value) => provider.setEmailError = value,
            //   typeField: TypeField.email,
            // ).validate(),
          ),
          mediumVerticalSpacing(),
          CustomTextField(
            prefixWidget: const Icon(Icons.lock_outline),
            placeholder: appLoc.password,
            title: appLoc.password,
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
            placeholder: appLoc.password,
            title: appLoc.password,
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
                      text: appLoc.term,
                      style: blactStyle.copyWith(fontSize: 12),
                    ),
                    TextSpan(
                      text: appLoc.and,
                      style: blactStyle.copyWith(
                        fontSize: 12,
                        color: grey7c7c7c,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    TextSpan(
                      text: appLoc.conditions,
                      style: blactStyle.copyWith(fontSize: 12),
                    ),
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
              // if (provider.formKey.currentState!.validate()) {
                submit();
              // }
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
                      })
              ],
            ),
          ),
          largeVerticalSpacing(),
        ],
      ),
      // ),
      // ),
    );
  }
}
