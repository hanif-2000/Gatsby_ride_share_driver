import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({Key? key, this.icon, this.title, this.address})
      : super(key: key);
  final String? icon;
  final String? title;
  final String? address;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          icon!,
          height: 25,
          width: 25,
        ),
        mediumHorizontalSpacing(),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title!,
              textAlign: TextAlign.center,
              style: titleStyle
                  .copyWith(
                    fontSize: 18,
                  )
                  .usePoppinsW6Font(),
            ),
            smallVerticalSpacing(),
            SizedBox(
              width: MediaQuery.of(context).size.width - 86,
              child: Text(
                address!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: titleStyle
                    .copyWith(
                      fontSize: 16,
                    )
                    .usePoppinsW5Font(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
