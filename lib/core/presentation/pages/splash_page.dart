import 'dart:async';

import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/pages/create_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../features/login/presentation/pages/login_page.dart';
import '../../static/assets.dart';
import '../../utility/global_function.dart';
import '../../utility/helper.dart';
import '../../utility/injection.dart';
import '../../utility/session_helper.dart';
import '../providers/currency_state.dart';
import '../providers/splash_provider.dart';
import 'home_page/home_page.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);
  static const routeName = '/splash';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      Timer(const Duration(seconds: 2), () async {
        if (await checkPermission()) {
          await sessionClearOrder();

          ///TODO: comment this when APIs will start working
          // Navigator.pushNamedAndRemoveUntil(
          //     context, HomePage.routeName, (route) => false);
          context.read<SplashProvider>().fetchCurrency().listen((state) async {
            switch (state.runtimeType) {
              case CurrencyLoaded:
                checkUserSession().then((value) async {
                  if (value) {
                    checkProfileSession().then((value1) {
                      if (value1) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomePage.routeName, (route) => false);
                      } else {
                        Navigator.pushNamedAndRemoveUntil(context,
                            CreateProfilePage.routeName, (route) => false);
                      }
                    });
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginPage.routeName, (route) => false);
                  }
                });
                break;
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLoc = AppLocalizations.of(context)!;
    myLocale = Localizations.localeOf(context);
    sessionHelper = locator<Session>();

    return LayoutBuilder(
      builder: (context, constraints) {
        // double imgHeight = constraints.maxWidth * 0.5;
        // double imgWidth = imgHeight;
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          color: whiteColor,
          child: SvgPicture.asset(
            'assets/images/splash_img.svg',
            fit: BoxFit.fitWidth,
          ),

          // Center(
          //   child: Hero(
          //     tag: "taxiIcon",
          //     child: Image.asset(
          //       logoSplash,
          //       height: imgHeight,
          //       width: imgWidth,
          //     ),
          //   ),
          // ),
        );
      },
    );
  }
}
