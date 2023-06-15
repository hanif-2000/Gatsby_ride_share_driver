import 'package:appkey_taxiapp_driver/core/presentation/pages/other_user_profile.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/presentation/pages/give_rating_screen.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, OtherUserProfile.routeName);
          },
          child: Container(
            height: 45,
            width: 45,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: redD03B3B,
            ),
          ),
        ),
        mediumHorizontalSpacing(),
        Column(
          children: [
            Text(
              'Johan Green',
              textAlign: TextAlign.center,
              style: titleStyle
                  .copyWith(
                    fontSize: 16,
                  )
                  .usePoppinsW5Font(),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(
                    // context, RatingListPage.routeName);
                    context,
                    GiveRatingScreen.routeName);
              },
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/home/ic_start.svg'),
                  smallHorizontalSpacing(),
                  Text(
                    '4.5',
                    textAlign: TextAlign.center,
                    style: titleStyle
                        .copyWith(
                          fontSize: 14,
                        )
                        .usePoppinsW6Font(),
                  ),
                  smallHorizontalSpacing(),
                  Text(
                    'Reviews',
                    textAlign: TextAlign.center,
                    style: titleStyle
                        .copyWith(
                          fontSize: 14,
                          color: yellowE5A829,
                          decoration: TextDecoration.underline,
                        )
                        .usePoppinsW5Font(),
                  ),
                ],
              ),
            )
          ],
        ),
        const Spacer(),
        Column(
          children: [
            Text(
              '\$80.00',
              textAlign: TextAlign.center,
              style: titleStyle
                  .copyWith(
                    fontSize: 16,
                  )
                  .usePoppinsW6Font(),
            ),
            Text(
              '4.5 Km',
              textAlign: TextAlign.center,
              style: titleStyle
                  .copyWith(
                    fontSize: 14,
                    color: greyB6B6B6,
                  )
                  .usePoppinsW5Font(),
            ),
          ],
        )
      ],
    );
  }
}
