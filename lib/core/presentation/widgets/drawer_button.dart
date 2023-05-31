import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../static/colors.dart';
import '../../static/styles.dart';
import 'custom_list_tile.dart';

class DrawerButtonItemWidget extends StatelessWidget {
  const DrawerButtonItemWidget({
    Key? key,
    this.onTap,
    required this.title,
  }) : super(key: key);

  final void Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: greyEFEFF4,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    titleNameStyle.copyWith(color: black030303, fontSize: 15),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SvgPicture.asset('assets/icons/home/ic_next.svg'),
            ],
          ),
        ),
      ),
    );
  }
}
