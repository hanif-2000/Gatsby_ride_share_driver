import 'package:flutter/material.dart';

import '../../../features/about_us/presentation/pages/aboutus_page.dart';
import '../../../features/history/presentation/pages/history_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../static/colors.dart';
import '../../utility/firebase_helper.dart';
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
                const SizedBox(
                  height: 20.0,
                ),
                const Divider(
                  height: 2,
                  color: secondaryColor,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  flex: 2,
                  child: ListView(
                    children: [
                      DrawerButtonItemWidget(
                        icon: Icons.person,
                        title: appLoc.profile,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            ProfilePage.routeName,
                          );
                        },
                      ),
                      DrawerButtonItemWidget(
                        icon: Icons.history,
                        title: appLoc.history,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            HistoryPage.routeName,
                          );
                        },
                      ),
                      DrawerButtonItemWidget(
                        icon: Icons.people,
                        title: appLoc.we,
                        onTap: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AboutUsPage.routeName,
                          );
                        },
                      ),
                      DrawerButtonItemWidget(
                        icon: Icons.logout,
                        title: appLoc.logout,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => CustomLogoutDialog(
                              positiveAction: () async {
                                var provider = Provider.of<HomeProvider>(
                                    context,
                                    listen: false);
                                provider
                                    .updateStatus(isFromLogout: true)
                                    .listen((event) async {
                                  if (event is ChangeStatusLoaded) {
                                    await sessionLogOut().then((_) =>
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                SplashPage.routeName,
                                                (route) => false));
                                  }
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
