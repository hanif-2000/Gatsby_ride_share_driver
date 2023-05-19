import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/validation_helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

class FormBankDetail extends StatefulWidget {
  const FormBankDetail({
    Key? key,
  }) : super(key: key);

  @override
  State<FormBankDetail> createState() => _FormBankDetailState();
}

class _FormBankDetailState extends State<FormBankDetail> {
  void submit() {
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
    return Consumer<CreateProfileProvider>(builder: (context, provider, _) {
      return Form(
        key: provider.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: sizeMedium,
          ),
          child: Column(
            children: [
              largeVerticalSpacing(),
              Text(
                appLoc.bankDetail,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ).useHiraginoKakuW6Font(),
              ),
              largeVerticalSpacing(),
              SvgPicture.asset(
                'assets/icons/profile/ic_bank_detail.svg',
                height: 136,
                width: 136,
              ),
              largeVerticalSpacing(),
              smallVerticalSpacing(),
              CustomTextField(
                placeholder: appLoc.bankName,
                title: appLoc.bankName,
                controller: provider.bankNameController,
                inputType: TextInputType.name,
                isError: provider.isFirstNameError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setFirstNameError,
                  typeField: TypeField.name,
                ).validate(),
              ),
              smallVerticalSpacing(),
              CustomTextField(
                placeholder: appLoc.accountNumber,
                title: appLoc.accountNumber,
                controller: provider.bankAccountController,
                inputType: TextInputType.number,
                isError: provider.isFirstNameError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setFirstNameError,
                  typeField: TypeField.name,
                ).validate(),
              ),
              smallVerticalSpacing(),
              CustomTextField(
                placeholder: appLoc.accountHolderName,
                title: appLoc.accountHolderName,
                controller: provider.bankHolderNameController,
                inputType: TextInputType.name,
                isError: provider.isFirstNameError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setFirstNameError,
                  typeField: TypeField.name,
                ).validate(),
              ),
              CustomTextField(
                placeholder: appLoc.ifscCode,
                title: appLoc.ifscCode,
                controller: provider.bankIFSCCodeController,
                inputType: TextInputType.text,
                isError: provider.isFirstNameError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setFirstNameError,
                  typeField: TypeField.name,
                ).validate(),
              ),
              largeVerticalSpacing(),
              CustomButton(
                text: Text(
                  appLoc.next,
                  style: txtButtonStyle,
                ),
                event: () {
                  // if (provider.formKey.currentState!.validate()) {
                  provider.setCurrentStep(3);
                  // submit();
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
