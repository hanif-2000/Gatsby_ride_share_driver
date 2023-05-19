import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/dimens.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/widgets/custom_app_title_bar.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/utility/injection.dart';
import '../providers/forgot_password_provider.dart';
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
          // appBar: CustomAppTtitleBar(
          //   centerTitle: true,
          //   canBack: true,
          //   backgroundColor: primaryColor,
          //   title: appLoc.changepassword.toUpperCase(),
          //   hideShadow: true,
          // ),
          //
          body: SafeArea(
            child: ListView(
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
                            fontWeight: FontWeight.bold,
                          ).useHiraginoKakuW6Font(),
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: Text(
                          appLoc.pleaseenteryouremailaddress,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: grey7D7979,
                            fontWeight: FontWeight.w400,
                          ).useHiraginoKakuW6Font(),
                        ),
                      ),
                    ],
                  ),
                ),
                const FormForgotPassword(),
                mediumVerticalSpacing(),
              ],
            ),
          ),
        ));
  }
}
