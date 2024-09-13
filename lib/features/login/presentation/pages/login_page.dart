import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utility/injection.dart';
import '../providers/login_provider.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<LoginProvider>(),
      child: Scaffold(
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
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: Text(
                        appLoc.welcome,
                        textAlign: TextAlign.center,
                        style: titleStyle,
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      child: Text(
                        appLoc.signInAccount,
                        textAlign: TextAlign.center,
                        style: formTextFieldStyle.copyWith(fontSize: 15, color: grey7c7c7c,),
                      ),
                    ),
                  ],
                ),
              ),
              const LoginForm(),

              
            ],
          ),
        ),
      ),
    );
  }
}
