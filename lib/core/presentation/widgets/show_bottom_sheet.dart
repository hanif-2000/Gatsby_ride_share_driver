import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:flutter/material.dart';


class CustomBottomSheet {
  static showBottomSheet(BuildContext context, Widget child,
      {Function(dynamic)? callBack}) async {
    showModalBottomSheet(
      backgroundColor: whiteColor,
      // isDismissible: false,
      // enableDrag: false,
      context: context,
      isScrollControlled: true,
      // constraints: const BoxConstraints(
      //   maxHeight: double.maxFinite
      // ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child,
      ),
    ).then((value) {
      if (callBack != null) {
        callBack(value);
      }
      // printf('Returned value ---> $value');
    });
  }
}
