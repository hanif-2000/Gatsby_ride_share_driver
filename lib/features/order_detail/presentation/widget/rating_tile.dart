import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/order_detail/presentation/widget/custom_rating_bar.dart';
import 'package:flutter/material.dart';

class RatingTile extends StatelessWidget {
  const RatingTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: greyF4F4F4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CustomRatingBar(
                initialRating: 5,
                isEditable: true,
                itemSize: 18,
              ),
              Text(
                '(4.6)',
                style: titleStyle
                    .copyWith(
                      fontSize: 14,
                    )
                    .usePoppinsW6Font(),
              ),
              const Spacer(),
              Text(
                '2 min ago',
                style: titleStyle
                    .copyWith(
                      fontSize: 12,
                      color: greyB6B6B6,
                    )
                    .usePoppinsW4Font(),
              ),
            ],
          ),
          mediumVerticalSpacing(),
          Text(
            'Very Continent ride and really nice driver behaviour. Quick service really enjoyed the ride.',
            style: titleStyle
                .copyWith(
                  fontSize: 14,
                )
                .usePoppinsW4Font(),
          ),
        ],
      ),
    );
  }
}
