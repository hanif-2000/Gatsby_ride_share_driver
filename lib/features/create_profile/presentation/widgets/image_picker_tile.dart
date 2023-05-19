import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImagePickerTile extends StatelessWidget {
  const ImagePickerTile({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: greyF9F9F9,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: grey7c7c7c),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/profile/ic_upload.svg',
            height: 38,
            width: 38,
          ),
          mediumHorizontalSpacing(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: greyA2A0A8,
            ).useHiraginoMaruW4Font(),
          ),
        ],
      ),
    );
  }
}
