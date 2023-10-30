import 'package:appkey_taxiapp_driver/core/presentation/widgets/cache_network_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/features/rating/data/model/rating_list_data_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/utility/helper.dart';

class RatingListTile extends StatelessWidget {
  const RatingListTile({Key? key, this.ratingItem}) : super(key: key);
  final RatingItem? ratingItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 5,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 20,
        horizontal: 16,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: greyEFEFF4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomCacheNetworkImage(img: ratingItem!.image, size: 45),
              // Container(
              //   height: 45,
              //   width: 45,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: redD03B3B,
              //     image: DecorationImage(
              //         image: NetworkImage(
              //           '$BASE_URL${ratingItem!.image}',
              //         ),
              //         fit: BoxFit.cover),
              //   ),
              // ),
              mediumHorizontalSpacing(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ratingItem!.name,
                    textAlign: TextAlign.center,
                    style: titleStyle
                        .copyWith(
                          fontSize: 16,
                        )
                        .usePoppinsW5Font(),
                  ),
                  Text(
                    DateFormat.yMMMd().format(ratingItem!.createdAt),
                    textAlign: TextAlign.center,
                    style: titleStyle
                        .copyWith(
                          fontSize: 10,
                        )
                        .usePoppinsW4Font(),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  SvgPicture.asset('assets/icons/home/ic_start.svg'),
                  smallHorizontalSpacing(),
                  Text(
                    '${ratingItem!.rating}',
                    textAlign: TextAlign.center,
                    style: titleStyle
                        .copyWith(
                          fontSize: 14,
                        )
                        .usePoppinsW6Font(),
                  ),
                  smallHorizontalSpacing(),
                ],
              ),
            ],
          ),
          mediumVerticalSpacing(),
          Text(
            ratingItem!.review ?? '',
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
