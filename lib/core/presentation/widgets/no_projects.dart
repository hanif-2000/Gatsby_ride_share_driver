import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoProjects extends StatelessWidget {
  final String text;
  const NoProjects({
    Key? key,
    this.isOffline = false,
    required this.text,
  }) : super(key: key);
  final bool isOffline;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        largeVerticalSpacing(),
        largeVerticalSpacing(),
        SvgPicture.asset('assets/icons/home/car_img.svg'),
        largeVerticalSpacing(),
        Text(
          isOffline ? 'Go Online!' : appLoc.waiting,
          textAlign: TextAlign.center,
          style: formTextFieldStyle.copyWith(
            fontSize: 24,
          ),
        ),
        mediumVerticalSpacing(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Text(
            isOffline
                ? 'You are currently offline go online to get rides.' + text
                : appLoc.waitForTheReside,
            textAlign: TextAlign.center,
            style: formTextFieldStyle.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: greyA2A0A8,
            ),
          ),
        ),
      ],
    );
  }
}
