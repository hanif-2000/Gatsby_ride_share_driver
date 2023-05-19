import 'package:flutter/material.dart';

import '../../static/colors.dart';

class CloseDrawerButtonWidget extends StatelessWidget {
  const CloseDrawerButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: CircleAvatar(
        backgroundColor: primaryColor,
        radius: 12,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(
            Icons.close,
            size: 18,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
