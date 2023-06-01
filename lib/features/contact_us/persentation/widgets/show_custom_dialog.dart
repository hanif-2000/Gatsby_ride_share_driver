import 'package:flutter/material.dart';

class ShowDialog {
  static showCustomDialog({BuildContext? context, Widget? child}) {
    showDialog(
      context: context!,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          //this right here
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: child!,
          ),
        );
      },
    );
  }
}