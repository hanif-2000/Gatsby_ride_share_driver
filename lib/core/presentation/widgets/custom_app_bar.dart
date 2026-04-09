import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/static/app_config.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:flutter/material.dart';
import '../../static/colors.dart';
import 'package:provider/provider.dart';
import '../providers/change_status_state.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool canBack;
  final bool centerTitle;
  final bool hideShadow;
  final Color? titleColor;
  final Color? buttonBackColor;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? widgetTitle;
  final void Function()? onBackAction;

  const CustomAppBar({
    Key? key,
    this.title,
    this.canBack = false,
    this.centerTitle = true,
    this.hideShadow = true,
    this.backgroundColor = Colors.white,
    this.titleColor,
    this.buttonBackColor = Colors.black,
    this.actions,
    this.widgetTitle,
    this.onBackAction,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    log("appbar called");
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        var session = locator<Session>();
        var socketProvider = context.read<LatestSocketProvider>();

        log("app bar called in homepage");
        log("app bar called in homepage isonline:-->>${provider.isOnline}");

        return AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor,
          elevation: hideShadow ? 0.0 : 4.0,
          centerTitle: centerTitle,
          titleSpacing: 10,
          leading: IconButton(
            onPressed: () {
              if (Scaffold.of(context).isDrawerOpen) {
                Scaffold.of(context).closeDrawer();
              } else {
                Scaffold.of(context).openDrawer();
              }
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
              child: SizedBox(
                width: 70,
                child: AnimatedToggleSwitch<bool>.dual(
                  current: provider.isOnline,
                  first: false,
                  second: true,
                  borderWidth: 4.0,
                  style: ToggleStyle(
                    borderColor: provider.isOnline ? primaryColor : greyA2A0A8,
                    backgroundColor: provider.isOnline ? whiteAccentColor : whiteAccentColor,
                    indicatorColor: provider.isOnline ? whiteAccentColor : whiteAccentColor,
                    borderRadius: BorderRadius.circular(50.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1.5),
                      ),
                    ],
                  ),
                  styleBuilder: (i) => ToggleStyle(
                    indicatorColor: provider.isOnline ? whiteColor : whiteColor,
                    backgroundColor: provider.isOnline ? primaryColor : greyA2A0A8,
                  ),
                  // ✅ FIX: Toggle ka sahi flow
                  onChanged: (b) async {
                    // Step 1: Pehle UI update karo
                    provider.changeStatus = b;

                    // Step 2: API call karo — targetOnline explicitly pass karo
                    provider.updateStatus(targetOnline: b).listen((event) async {
                      if (event is ChangeStatusLoaded) {
                        // ✅ Success — session update karo
                        session.setIsOnline = b;
                        socketProvider.updateLatLngAtStarting();
                        log("Status updated successfully: $b");
                      } else if (event is ChangeStatusFailure) {
                        // ✅ Failure — toggle wapas revert karo
                        log("Status update failed — reverting toggle");
                        showToast(message: "Status update failed. Try again.");
                      }
                    });

                    return Future.delayed(const Duration(seconds: 2));
                  },
                  indicatorSize: const Size.fromWidth(120),
                  iconBuilder: (value) => Padding(
                    padding: EdgeInsets.zero,
                    child: Icon(
                      Icons.local_taxi,
                      color: value ? primaryColor : greyA2A0A8,
                    ),
                  ),
                ),
              ),
            ),
          ],
          title: Container(
            padding: const EdgeInsets.only(left: 25),
            width: App(context).appWidth(30.0),
            child: Text(
              provider.isOnline ? appLoc.online : appLoc.offLine,
              style: priceTextStyle.copyWith(
                color: blackColor,
              ),
            ),
          ),
        );
      },
    );
  }
}