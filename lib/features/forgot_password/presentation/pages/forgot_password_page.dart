import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/features/forgot_password/presentation/widgets/otp_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utility/injection.dart';
import '../providers/forgot_password_provider.dart';
import '../widgets/create_password_form.dart';
import '../widgets/forgot_password_form.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);
  static const routeName = '/ForgotPasswordPage';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<ForgotPasswordProvider>(),
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child:
              Consumer<ForgotPasswordProvider>(builder: (context, provider, _) {
            return provider.forgetScreens == ForgetScreens.forget
                ? const FormForgotPassword()
                : provider.forgetScreens == ForgetScreens.otp
                    ? FormOTP()
                    : FormCreatePassword();
          }),
        ),
      ),
    );
  }
}
