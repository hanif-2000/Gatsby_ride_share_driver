import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../static/colors.dart';
import '../../utility/helper.dart';

class CustomCacheNetworkImage extends StatelessWidget {
  final String img;
  final double size;
  const CustomCacheNetworkImage({
    super.key,
    required this.img,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    log("image value is:------>>>. $img");
    return ((img == '') || (img == '-'))
        ? CircleAvatar(
            backgroundColor: transparentColor,
            radius: size / 2,
            backgroundImage: const AssetImage('assets/images/user_avatar.png'),
          )
        : CachedNetworkImage(
            imageUrl: mergePhotoUrl(img),
            imageBuilder: (context, imageProvider) => Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) {
              if (downloadProgress.progress != null) {
                var percent = (downloadProgress.progress!) * 100;
                log("Download percentage is :${percent.toInt()}");
              }
              log("DOWNLOAD PROGRESS IS:-->> ${downloadProgress.progress}");
              return CircularProgressIndicator(
                value: downloadProgress.progress,
              );
            },
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
  }
}
