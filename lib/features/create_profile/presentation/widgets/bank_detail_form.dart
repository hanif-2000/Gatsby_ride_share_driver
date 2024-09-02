import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/validation_helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_provider.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_state.dart';
import 'package:appkey_taxiapp_driver/features/login/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

class FormBankDetail extends StatefulWidget {
  const FormBankDetail({
    super.key,
  });

  @override
  State<FormBankDetail> createState() => _FormBankDetailState();
}

class _FormBankDetailState extends State<FormBankDetail> {
  void submit() {
    final provider = context.read<CreateProfileProvider>();
    provider.doCreateProfileApi('api/webservice/driver/bank/details/add', {
      "bank_name": provider.bankNameController.text.trim(),
      "account_number": provider.bankAccountController.text.trim(),
      "account_holder_name": provider.bankHolderNameController.text.trim(),
      "transit_number": provider.bankTransitController.text.trim(),
      "institution_number": provider.bankInstitutionController.text.trim(),
    }).listen((state) async {
      switch (state.runtimeType) {
        case CreateProfileLoading:
          showLoading();
          break;
        case CreateProfileFailure:
          final msg = (state as CreateProfileFailure).failure;
          dismissLoading();
          showToast(message: msg);
          break;
        case CreateProfileSuccess:
          final data = (state as CreateProfileSuccess).data;
          dismissLoading();
          if (data.success == 1) {
            final session = locator<Session>();
            session.setIsProfileCompleted = true;
            showToast(message: 'Please wait Admin will verify your account!');
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.routeName, (route) => false);
          } else {
            // if (data.message == '1') {
            //   showToast(message: appLoc.emailnotmatch);
            // } else {
            showToast(message: data.message ?? appLoc.failed);
            // }
          }

          break;
      }
    });
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
                style: formTextFieldStyle.copyWith(fontSize: 24),
              ),
              largeVerticalSpacing(),
              Image.asset(
                'assets/icons/profile/ic_bank_detail.png',
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
                isError: provider.bankNameError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setBankNameError = value,
                  typeField: TypeField.name,
                ).validate(),
              ),
              smallVerticalSpacing(),
              CustomTextField(
                placeholder: appLoc.accountNumber,
                title: appLoc.accountNumber,
                controller: provider.bankAccountController,
                inputType: TextInputType.number,
                isError: provider.bankAccountError,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setBankAccountError = value,
                  typeField: TypeField.name,
                ).validate(),
              ),
              smallVerticalSpacing(),
              CustomTextField(
                placeholder: appLoc.accountHolderName,
                title: appLoc.accountHolderName,
                controller: provider.bankHolderNameController,
                inputType: TextInputType.name,
                isError: provider.bankHolderNameError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) =>
                      provider.setBankHolderNameError = value,
                  typeField: TypeField.name,
                ).validate(),
              ),

              //Transit number
              CustomTextField(
                placeholder: "Transit Number",
                title: "Transit Number",
                controller: provider.bankTransitController,
                inputType: TextInputType.number,
                isError: provider.bankTransitError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) => provider.setBankTransitErr = value,
                  typeField: TypeField.name,
                ).validate(),
              ),

              //Transit number
              CustomTextField(
                placeholder: "Institution Number",
                title: "Institution Number",
                controller: provider.bankInstitutionController,
                inputType: TextInputType.number,
                isError: provider.bankInstitutionCodeError,
                fieldValidator: ValidationHelper(
                  loc: appLoc,
                  isError: (bool value) =>
                      provider.setBankInstitutionErr = value,
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
                  if (provider.formKey.currentState!.validate()) {
                    if(provider.bankNameController.text.trim().isEmpty){
                      showToast(message: "Please enter bank name");
                      return;
                    }else if(provider.bankAccountController.text.trim().isEmpty){
                      showToast(message: "Please enter account number");
                      return;
                    }else if(provider.bankHolderNameController.text.trim().isEmpty){
                      showToast(message: "Please enter account holder name");
                      return;
                    }else if(provider.bankTransitController.text.trim().isEmpty){
                      showToast(message: "Please enter bank transit");
                      return;
                    }else if(provider.bankInstitutionController.text.trim().isEmpty){
                      showToast(message: "Please enter institution number");
                      return;
                    }else{
                      submit();
                    }
                  }
                },
                buttonHeight: 48,
                isRounded: true,
                bgColor: blackColor,
              ),
              // largeVerticalSpacing(),
              smallVerticalSpacing(),

// // Login Button

//               CustomButton(
//                 text: Text(
//                   appLoc.login,
//                   style: txtButtonStyle,
//                 ),
//                 event: () {
//                   final session = locator<Session>();

//                   session.setIsProfileCompleted = true;

//                   Navigator.pushNamedAndRemoveUntil(
//                       context, LoginPage.routeName, (route) => false);
//                   log("click on login button");
//                 },
//                 buttonHeight: 48,
//                 isRounded: true,
//                 bgColor: blackColor,
//               ),
            ],
          ),
        ),
      );
    });
  }
}
