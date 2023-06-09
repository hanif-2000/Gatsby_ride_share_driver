import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';

class ProfileFieldTile extends StatelessWidget {
  const ProfileFieldTile({Key? key, this.title, this.value}) : super(key: key);
  final String? title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title??'',
          style: titleNameStyle
              .copyWith(color: greyB6B6B6, fontSize: 15)
              .usePoppinsW4Font(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        smallVerticalSpacing(),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: greyF9F9F9,
            border: Border.all(
              color: greyE7E7E7,
            ),
          ),
          child: Text(
            value ?? '',
            style: titleStyle
                .copyWith(
                  fontSize: 15,
                )
                .usePoppinsW5Font(),
          ),
        ),
      ],
    );
  }
}
