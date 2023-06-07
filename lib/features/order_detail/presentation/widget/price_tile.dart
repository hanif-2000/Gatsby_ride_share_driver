import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:flutter/material.dart';

import '../../../../core/static/colors.dart';

class PriceTile extends StatelessWidget {
  const PriceTile({
    Key? key,
    this.title,
    this.value,
    this.fontSize = 16,
  }) : super(key: key);
  final String? title;
  final String? value;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title!,
            textAlign: TextAlign.center,
            style: titleStyle
                .copyWith(
                  fontSize: fontSize,
                )
                .usePoppinsW6Font(),
          ),
          Text(
            value!,
            textAlign: TextAlign.center,
            style: titleStyle
                .copyWith(
                  fontSize: fontSize,
                  color: blackColor,
                )
                .usePoppinsW5Font(),
          ),
        ],
      ),
    );
  }
}
