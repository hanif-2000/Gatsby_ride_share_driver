import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomContainerHome extends StatelessWidget {
  const BottomContainerHome({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    return Consumer<HomeProvider>(builder: (context, provider, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Color.fromRGBO(0, 0, 0, 0.4),
            ),
            height: deviceSize.height * 0.16,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Spacer(),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        provider.isOnline
                            ? appLoc.isonlineNow
                            : appLoc.curentlyOfline,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  AnimatedToggleSwitch<bool>.dual(
                    current: provider.isOnline,
                    first: false,
                    second: true,
                  //  dif: 80.0,
                    spacing: 80.0,
                    borderWidth: 5.0,
                    height: 45,
                    style: ToggleStyle(
                      borderColor: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                    ),
                    styleBuilder: (i) => ToggleStyle(indicatorColor:  provider.isOnline ? primaryColor : greyA2A0A8),
                 //   innerColor: provider.isOnline ? primaryColor : Colors.black,
                    onChanged: (b) {
                      // provider.updateStatus().listen((event) async {});
                      provider.changeStatus = b;
                      return Future.delayed(const Duration(seconds: 2));
                    },
                    indicatorSize: const Size.fromWidth(38),
                 //   colorBuilder: (b) => b ? Colors.black : Colors.grey,
                    iconBuilder: (value) => const Icon(
                      Icons.local_taxi,
                      color: whiteColor,
                    ),
                    textBuilder: (value) => value
                        ? Center(
                            child: Text(
                            appLoc.online,
                            style: const TextStyle(
                                    color: whiteColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)
                                .usePoppinsW6Font(),
                          ))
                        : Center(
                            child: Text(appLoc.offLine,
                                style: const TextStyle(
                                        color: whiteColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)
                                        .usePoppinsW6Font())),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
