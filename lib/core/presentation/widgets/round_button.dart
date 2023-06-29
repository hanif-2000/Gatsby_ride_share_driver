import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class RoundAlertButton extends StatelessWidget {
  final double? width;
  final void Function() onPressed;
  final String label;
  final Color bgColor;
  final Color? txtColor;

  RoundAlertButton(
      {this.width,
      required this.onPressed,
      required this.label,
      required this.bgColor,
      this.txtColor});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: width == null
          ? MediaQuery.of(context).size.width
          : MediaQuery.of(context).size.width * width!,
      height: 45,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(bgColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          )),
        ),
        onPressed: () {
          onPressed();
        },
        child: AutoSizeText(
          label,
          style: TextStyle(color: txtColor ?? Colors.white),
          minFontSize: 5,
          maxLines: 1,
        ),
        // color: bgColor,
      ),
    );
  }
}
