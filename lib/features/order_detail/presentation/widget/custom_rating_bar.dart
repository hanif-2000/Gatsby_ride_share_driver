import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar({
    Key? key,
    this.initialRating = 5,
    this.isEditable = true,
    this.onUpdate,
    this.itemSize = 24,
  }) : super(key: key);
  final double? initialRating;
  final bool? isEditable;
  final Function(double)? onUpdate;
  final double? itemSize;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: initialRating!,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: itemSize!,
      ignoreGestures: isEditable!,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.star,
        size: 12,
        color: yellowE5A829,
      ),
      onRatingUpdate: (rating) {
        ///Update rating
        if (onUpdate != null) {
          onUpdate!(rating);
        }
      },
    );
  }
}
