import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/forgot_password_form.dart';

class OTPPage extends StatelessWidget {
  const OTPPage({Key? key}) : super(key: key);
  static const routeName = '/OTPPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
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
                    child: Text(
                      appLoc.enterOTP+'raj1@mailinator.com',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: grey7D7979,
                        fontWeight: FontWeight.w400,
                      ).usePoppinsW6Font(),
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
    );
  }
}
