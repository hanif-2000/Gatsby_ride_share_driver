import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/history/data/models/history_response_model.dart';
import 'package:appkey_taxiapp_driver/features/order_detail/presentation/widget/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class RatingTile extends StatelessWidget {
  const RatingTile({Key? key, this.rating}) : super(key: key);
  final RatingList? rating;

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
                '(${rating!.rating})',
                style: titleStyle
                    .copyWith(
                      fontSize: 14,
                    )
                    .usePoppinsW6Font(),
              ),
              const Spacer(),
              Text(
                '${timeago.format(rating!.createdAt)}',
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
            rating!.review,
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
