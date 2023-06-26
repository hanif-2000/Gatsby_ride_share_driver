import 'package:appkey_taxiapp_driver/core/presentation/pages/other_user_profile.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/order_provider.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/page/rating_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

class UserProfileTile extends StatelessWidget {
  const UserProfileTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        return provider.customerDetail == null
            ? const CircularProgressIndicator(
                color: Colors.blue,
              )
            : Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, OtherUserProfile.routeName);
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: redD03B3B,
                        image: DecorationImage(
                          image: NetworkImage(
                            '$BASE_URL${provider.customerDetail!.data.photo}',
                          ),
                        ),
                      ),
                    ),
                  ),
                  mediumHorizontalSpacing(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${provider.customerDetail!.data.name}',
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
                              context, RatingListPage.routeName);
                          // context,
                          // GiveRatingScreen.routeName);
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
                        '\$${provider.orderDetail!.totalPrice.toStringAsFixed(0)}',
                        textAlign: TextAlign.center,
                        style: titleStyle
                            .copyWith(
                              fontSize: 16,
                            )
                            .usePoppinsW6Font(),
                      ),
                      Text(
                        '${provider.orderDetail!.distance} Km',
                        textAlign: TextAlign.center,
                        style: titleStyle
                            .copyWith(
                              fontSize: 14,
                              color: greyB6B6B6,
                            )
                            .usePoppinsW5Font(),
                      ),
                    ],
                  ),
                ],
              );
      },
    );
  }
}
