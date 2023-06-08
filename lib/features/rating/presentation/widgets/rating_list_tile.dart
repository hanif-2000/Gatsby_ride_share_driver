import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utility/helper.dart';

class RatingListTile extends StatelessWidget {
  const RatingListTile({Key? key}) : super(key: key);

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
              Container(
                height: 45,
                width: 45,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: redD03B3B,
                ),
              ),
              mediumHorizontalSpacing(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alex Robin',
                    textAlign: TextAlign.center,
                    style: titleStyle
                        .copyWith(
                          fontSize: 16,
                        )
                        .usePoppinsW5Font(),
                  ),
                  Text(
                    '12 May 2023',
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
                    '4.5',
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
            'Lorem ipsum dolor sit amet consectetur. Scelerisque ornare nunc adipiscing ipsum id turpis quis. Viverra amet arcu eget quisque cras risus lacus tristique morbi. Nisl magnis aliquam tortor dui adipiscing .',
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
