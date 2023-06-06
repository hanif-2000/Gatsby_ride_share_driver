import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/utility/validation_helper.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/persentation/provider/contact_us_provider.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/persentation/provider/contact_us_state.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/persentation/widgets/custom_dialog_layout.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/persentation/widgets/show_custom_dialog.dart';
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
  void submit() {
    // Navigator.pushReplacementNamed(context, LoginPage.routeName);
    final provider = context.read<ContactUsProvider>();
    provider
        .doContactUsAPI(
            email: provider.emailController.text.trim(),
            message: provider.firstNameController.text.trim())
        .listen((state) async {
      switch (state.runtimeType) {
        case ContactUsLoading:
          showLoading();
          break;
        case ContactUsFailure:
          final msg = (state as ContactUsFailure).failure;
          dismissLoading();
          showToast(message: msg);
          break;
        case ContactUsSuccess:
          final data = (state as ContactUsSuccess).data;
          dismissLoading();
          if (data!.success == 1) {
            // showToast(message: appLoc.pwdreset);
            showToast(message: data.message!);
            showEmailDialog();
            // Navigator.pushReplacementNamed(context, LoginPage.routeName);
          } else {
            // if (data.message == '1') {
            // showToast(message: appLoc.emailnotmatch);
            // } else {
            showToast(message: appLoc.failed);
            // }
          }
          break;
      }
    });
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
                  placeholder: appLoc.pleaseEnterEmail,
                  title: appLoc.pleaseEnterEmail,
                  controller: provider.emailController,
                  inputType: TextInputType.emailAddress,
                  isError: provider.emailError,
                  fieldValidator: ValidationHelper(
                    loc: appLoc,
                    isError: (bool value) => provider.setEmailError = value,
                    typeField: TypeField.email,
                  ).validate(),
                ),
                CustomTextField(
                  maxLine: 5,
                  placeholder: appLoc.pleaseEnterMessage,
                  title: appLoc.pleaseEnterMessage,
                  controller: provider.firstNameController,
                  inputType: TextInputType.multiline,
                  isError: provider.firstNameError,
                  fieldValidator: ValidationHelper(
                    loc: appLoc,
                    isError: (bool value) => provider.setFirstNameError = value,
                    typeField: TypeField.name,
                  ).validate(),
                ),
                largeVerticalSpacing(),
                CustomButton(
                  text: Text(
                    appLoc.sendMessage,
                    style: txtButtonStyle,
                  ),
                  event: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    if (provider.formKey.currentState!.validate()) {
                      submit();
                    }
                  },
                  buttonHeight: 48,
                  isRounded: true,
                  bgColor: blackColor,
                ),
                mediumVerticalSpacing(),
                CustomButton(
                  text: Text(
                    appLoc.cancel,
                    style: txtButtonStyle.copyWith(color: blackColor),
                  ),
                  event: () {
                    Navigator.pop(context);
                  },
                  buttonHeight: 48,
                  isRounded: true,
                  bgColor: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showEmailDialog() {
    ShowDialog.showCustomDialog(
      context: context,
      child: CustomDialogLayout(
        image: 'assets/icons/profile/ic_sent.svg',
        title: appLoc.messageSent,
        height: 100,
        description: appLoc.yourMessageHasBeenSent,
        onClose: () {
          ///TODO: onClose here
          Navigator.pop(context);
        },
        onDone: () {
          ///TODO: onDone here
          // if (provider.formKey.currentState!.validate()) {
          //   submit(/*provider.emailController.text*/);
          // }
          Navigator.pop(context);
          Navigator.pop(context);
        },
      ),
    );
  }
}
