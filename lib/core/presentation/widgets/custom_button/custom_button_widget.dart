import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.text,
      required this.event,
      required this.bgColor,
      this.shape,
      this.image = '',
      this.showBorder = false,
      this.isRounded = false,
      this.buttonHeight})
      : super(key: key);
  final dynamic text;
  final Function() event;
  final Color bgColor;
  final bool isRounded;
  final bool showBorder;
  final OutlinedBorder? shape;
  final double? buttonHeight;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: isRounded
          ? ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: showBorder ? Colors.black : bgColor),
                borderRadius: BorderRadius.circular(10), // <-- Radius
              ), backgroundColor: bgColor,
              minimumSize: Size.fromHeight(buttonHeight ?? 58.0),
            )
          : ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(buttonHeight ?? 58.0), backgroundColor: bgColor,
              shape: shape),
      onPressed: () => event(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image != ''
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SvgPicture.asset(image!),
                )
              : const SizedBox.shrink(),
          text is String ? Text(text, style: txtButtonStyle) : text,
        ],
      ),
    );
  }
}
