import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';

class RefuseOrderDialog extends StatelessWidget {
  final String msg;
  final void Function() noButton;
  final void Function() yesButton;

  RefuseOrderDialog(
      {required this.msg, required this.noButton, required this.yesButton});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        color: Color.fromRGBO(0, 0, 0, 0.4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 200 * 0.7,
                    // width: 200,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35)),
                      // border: Border(
                      //     bottom: BorderSide(color: HexColor('#707070'), width: 0.3)),
                    ),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        msg,
                        style: TextStyle(
                            fontFamily: 'Hiragino Kaku',
                            // fontWeight: FontWeight.bold,
                            fontSize: 22),
                        textAlign: TextAlign.center,
                      ),
                    )),
                  ),
                  Divider(height: 1, thickness: 1.0, color: Colors.grey[300]),
                  // Container(
                  //   height: 0.3,
                  //   color: HexColor('#707070'),
                  // ),
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
                        GestureDetector(
                          child: Text(appLoc.no,
                              style: TextStyle(
                                  color: primaryColor,
                                  fontFamily: 'Hiragino Kaku',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          onTap: () {
                            noButton();
                          },
                        ),
                        GestureDetector(
                          child: Text(appLoc.yes,
                              style: TextStyle(
                                  color: errorRedColor,
                                  fontFamily: 'Hiragino Kaku',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          onTap: () async {
                            yesButton();
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
