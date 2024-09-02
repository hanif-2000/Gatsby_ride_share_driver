import 'dart:io';

import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImagePickerTile extends StatelessWidget {
  const ImagePickerTile(
      {super.key, required this.title, this.onTap, this.selectedImage = '', this.onDelete});
  final String title;
  final Function()? onTap;
  final Function()? onDelete;
  final String? selectedImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: greyF9F9F9,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: grey7c7c7c),
        ),
        child: selectedImage == ''
            ? Row(
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
                    ).usePoppinsW4Font(),
                  ),
                ],
              )
            : Stack(
                children: [
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(
                      File(
                        selectedImage!,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: InkWell(
                      onTap: onDelete,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
