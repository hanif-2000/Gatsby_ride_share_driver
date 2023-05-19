import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/widgets/form_change_password.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/custom_app_title_bar.dart';

class ChangePasswordPage extends StatefulWidget {
  static const String routeName = "/ChangePasswordPage";
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: CustomAppTtitleBar(
          centerTitle: true,
          canBack: true,
          title: appLoc.changepassword.toUpperCase(),
          hideShadow: true,
        ),
        body: SafeArea(child: LayoutBuilder(
          builder: (context, constraints) {
            return ListView(
              children: const [FormChangePassword()],
            );
          },
        )));
  }
}
