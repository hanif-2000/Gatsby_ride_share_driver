import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:flutter/material.dart';

class RejectTile extends StatelessWidget {
  const RejectTile({Key? key, this.title, this.onTap}) : super(key: key);
  final String? title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 14),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: greyDBDBDB,
        ),
        child: Text(
          title!,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12, color: black282828)
              .usePoppinsW5Font(),
        ),
      ),
    );
  }
}
