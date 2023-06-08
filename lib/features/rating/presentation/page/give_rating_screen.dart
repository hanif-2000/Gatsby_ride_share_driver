import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GiveRatingScreen extends StatelessWidget {
  const GiveRatingScreen({Key? key}) : super(key: key);
  static const routeName = '/GiveRatingScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          largeVerticalSpacing(),
          largeVerticalSpacing(),
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset('assets/icons/auth/ic_back.svg'),
            ),
          ),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              border: Border.all(color: greenF0F9F1),
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }
}
