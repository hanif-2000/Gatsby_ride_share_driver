import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/persentation/pages/contact_us_page.dart';
import 'package:appkey_taxiapp_driver/features/privacy_policy/page/privacy_policy_page.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/pages/edit_bank_page.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/pages/edit_vehicle_page.dart';
import 'package:flutter/material.dart';
import '../../static/colors.dart';
import '../../utility/helper.dart';
import '../providers/change_status_state.dart';
import '../widgets/close_button.dart';
import '../widgets/custom_dialog_logout.dart';
import '../widgets/drawer_button.dart';
import '../widgets/profile_drawer.dart';
import 'splash_page.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';

class HomeDrawerPage extends StatelessWidget {
  const HomeDrawerPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Drawer(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CloseDrawerButtonWidget(),
                const ProfileInformationDrawer(),
                Expanded(
                  flex: 2,
                  child: ListView(
                    children: [
                      DrawerButtonItemWidget(
                        title: appLoc.vehicleDetail,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            EditVehiclePage.routeName,
                          );
                        },
                      ),
                      DrawerButtonItemWidget(
                        title: appLoc.bankDetail,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            EditBankPage.routeName,
                          );
                        },
                      ),
                      DrawerButtonItemWidget(
                        title: appLoc.contactUs,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ContactUsPage.routeName,
                          );
                        },
                      ),
                      DrawerButtonItemWidget(
                        title: appLoc.privacyPolicy,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PrivacyPolicyPage.routeName,
                          );
                        },
                      ),
                      DrawerButtonItemWidget(
                        title: appLoc.termConditions,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            PrivacyPolicyPage.routeName,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => CustomLogoutDialog(
                        positiveAction: () async {
                          var provider =
                              Provider.of<HomeProvider>(context, listen: false);
                          provider.updateStatus(isFromLogout: true).listen(
                            (event) async {
                              if (event is ChangeStatusLoaded) {
                                await sessionLogOut().then(
                                  (_) => Navigator.of(context)
                                      .pushNamedAndRemoveUntil(
                                          SplashPage.routeName,
                                          (route) => false),
                                );
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: greyEFEFF4,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      appLoc.logout,
                      style: titleNameStyle
                          .copyWith(color: greyB6B6B6, fontSize: 15)
                          .usePoppinsW6Font(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                mediumVerticalSpacing(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
