import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/signup/presentation/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);
  static const routeName = '/signup';

  @override
  Widget build(BuildContext context) {
    return
        // ChangeNotifierProvider(
        // create: (context) => locator<LoginProvider>(),
        // child:
        Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: ListView(
          children: [
            AspectRatio(
              aspectRatio: 5 / 2,
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
                      icon: SvgPicture.asset('assets/icons/auth/ic_back.svg'),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Text(
                        appLoc.signup,
                        textAlign: TextAlign.center,
                        style: titleStyle,
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    flex: 1,
                    child: Text(
                      appLoc.createyouraccount,
                      textAlign: TextAlign.center,
                      style: formTextFieldStyle.copyWith(
                        fontSize: 13,
                        color: grey7D7979,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            largeVerticalSpacing(),
            const SignUpForm(),
          ],
        ),
      ),
      // ),
    );
  }
}
