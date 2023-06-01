import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDialogLayout extends StatelessWidget {
  final Function()? onClose;
  final Function()? onDone;
  final String? image;
  final String? title;
  final String? description;
  final double? height;
  final double? width;
  final double? padding;

  const CustomDialogLayout(
      {Key? key,
      this.onClose,
      this.onDone,
      this.image,
      this.title,
      this.description,
      this.padding = 0,
      this.height = 65,
      this.width = 61})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 325,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0, top: 10),
              child: InkWell(
                onTap: onClose,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  width: 25,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/profile/ic_close.svg',
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 9,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: padding!),
                  child: SvgPicture.asset(
                    image!,
                    height: height,
                    width: width,
                  ),
                ),
                const SizedBox(
                  height: 17,
                ),
                Text(
                  title!,
                  style: const TextStyle(
                    color: black282828,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: grey767676,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 25,
                ),
                CustomButton(
                  text: Text(
                    appLoc.done,
                    style: txtButtonStyle,
                  ),
                  event: onDone!,
                  buttonHeight: 48,
                  isRounded: true,
                  bgColor: blackColor,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
