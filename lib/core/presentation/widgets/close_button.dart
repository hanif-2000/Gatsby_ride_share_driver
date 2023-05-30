import 'package:flutter/material.dart';

import '../../static/colors.dart';

class CloseDrawerButtonWidget extends StatelessWidget {
  const CloseDrawerButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(
          Icons.arrow_back,
          size: 25,
        ),
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
