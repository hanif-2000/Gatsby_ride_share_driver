import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.text,
      required this.event,
      required this.bgColor,
      this.shape,
      this.isRounded = false,
      this.buttonHeight})
      : super(key: key);
  final dynamic text;
  final Function() event;
  final Color bgColor;
  final bool isRounded;
  final OutlinedBorder? shape;
  final double? buttonHeight;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: isRounded
          ? ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // <-- Radius
              ),
              minimumSize: Size.fromHeight(buttonHeight ?? 58.0),
              primary: bgColor,
            )
          : ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(buttonHeight ?? 58.0),
              primary: bgColor,
              shape: shape),
      onPressed: () => event(),
      child: text is String ? Text(text, style: txtButtonStyle) : text,
    );
  }
}
