import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/pages/change_password_page.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import '../../../../core/presentation/pages/splash_page.dart';
import '../../../../core/presentation/widgets/custom_button/custom_button_widget.dart';
import '../../../../core/presentation/widgets/custom_dialog_logout.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

class BottomProfile extends StatefulWidget {
  const BottomProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomProfile> createState() => _BottomProfileState();
}

class _BottomProfileState extends State<BottomProfile> {
  var socketProvider = locator<LatestSocketProvider>();
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (context, provider, _) {
      return SizedBox(
        height: 260,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                  flex: 1,
                  child: CustomButton(
                      text: Text(
                        appLoc.editprofile,
                        style: txtButtonProfileStyle,
                      ),
                      buttonHeight: MediaQuery.of(context).size.height * 0.080,
                      isRounded: true,
                      event: () {
                        Navigator.push( context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EditProfilePage())).then((value) {
                          if (value != null) {
                            provider.refreshProfile();
                          }
                        });
                      },
                      bgColor: primaryColor)),
              smallVerticalSpacing(),
              Flexible(
                  flex: 1,
                  child: CustomButton(
                      buttonHeight: MediaQuery.of(context).size.height * 0.080,
                      isRounded: true,
                      text: Text(
                        appLoc.changepassword,
                        style: txtButtonProfileStyle,
                      ),
                      event: () {
                        Navigator.pushNamed(
                            context, ChangePasswordPage.routeName);
                      },
                      bgColor: primaryColor)),
              mediumVerticalSpacing(),
              Flexible(
                  flex: 1,
                  child: CustomButton(
                      buttonHeight: MediaQuery.of(context).size.height * 0.080,
                      isRounded: true,
                      text: Text(
                        appLoc.logout,
                        style: txtButtonStyle,
                      ),
                      event: () {
                        showDialog(
                          context: context,
                          builder: (_) => CustomLogoutDialog(
                            positiveAction: () async {
                              await socketProvider.disconnectSocket();
                              await sessionLogOut().then((_) =>
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      SplashPage.routeName, (route) => false));
                            },
                          ),
                        );
                      },
                      bgColor: blackColor))
            ],
          ),
        ),
      );
    });
  }
}
