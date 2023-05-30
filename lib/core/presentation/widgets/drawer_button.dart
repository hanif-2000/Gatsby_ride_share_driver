import 'package:flutter/material.dart';

import '../../static/colors.dart';
import '../../static/styles.dart';
import 'custom_list_tile.dart';

class DrawerButtonItemWidget extends StatelessWidget {
  const DrawerButtonItemWidget({
    Key? key,
    this.onTap,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final void Function()? onTap;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      titlePadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      enableDivider: false,
      padding: EdgeInsets.zero,
      // leading: Icon(icon, size: 30, color: primaryColor),
      title: Text(title, style: formTextFieldStyle),
      onTap: onTap,
    );
  }
}
