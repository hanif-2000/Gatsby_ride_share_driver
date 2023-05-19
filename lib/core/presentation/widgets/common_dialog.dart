import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';

class CommonDialog extends StatelessWidget {
  final String msg;
  final String? title;
  final void Function()? onTap;

  const CommonDialog({Key? key, required this.msg, this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200 * 0.7,
              decoration: const BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35)),
              ),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    title != null
                        ? Text(
                            title!,
                            style: TextStyle(
                                fontFamily: 'Hiragino Kaku',
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                            textAlign: TextAlign.center,
                          )
                        : SizedBox.shrink(),
                    Text(
                      msg,
                      style:
                          TextStyle(fontFamily: 'Hiragino Kaku', fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )),
            ),
            Container(
              height: 0.3,
              color: secondaryColor,
            ),
            Container(
              height: 200 * 0.3,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(35),
                    bottomRight: Radius.circular(35)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  onTap == null
                      ? GestureDetector(
                          child: Text(appLoc.ok,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontFamily: 'Hiragino Kaku',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        )
                      : GestureDetector(
                          child: Text(appLoc.ok,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontFamily: 'Hiragino Kaku',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          onTap: onTap,
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
