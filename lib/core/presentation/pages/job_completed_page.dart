import 'package:appkey_taxiapp_driver/core/presentation/pages/home_page/home_page.dart';
import 'package:appkey_taxiapp_driver/features/receipt/persentation/pages/receipt_page.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JobCompletedPage extends StatelessWidget {
  const JobCompletedPage({Key? key}) : super(key: key);
  static const routeName = '/JobCompletedPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              largeVerticalSpacing(),
              largeVerticalSpacing(),
              SvgPicture.asset('assets/icons/home/job_completed.svg'),
              largeVerticalSpacing(),
              Column(
                children: [
                  Text(
                    'Great Job!',
                    textAlign: TextAlign.center,
                    style: titleStyle
                        .copyWith(
                          fontSize: 25,
                        )
                        .usePoppinsW5Font(),
                  ),
                  smallVerticalSpacing(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70.0),
                    child: Text(
                      'You completed the ride successfully.',
                      textAlign: TextAlign.center,
                      style: titleStyle
                          .copyWith(fontSize: 17, color: greyA2A0A8)
                          .usePoppinsW4Font(),
                    ),
                  ),
                ],
              ),
              mediumVerticalSpacing(),
              largeVerticalSpacing(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    largeVerticalSpacing(),
                    largeVerticalSpacing(),
                    CustomButton(
                      text: Text(
                        appLoc.findNextRide,
                        style: txtButtonStyle,
                      ),
                      event: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          HomePage.routeName,
                          (route) => false,
                        );
                      },
                      buttonHeight: 48,
                      isRounded: true,
                      bgColor: blackColor,
                    ),
                    largeVerticalSpacing(),
                    CustomButton(
                      text: Text(
                        appLoc.getReceipt,
                        style: txtButtonStyle.copyWith(color: blackColor),
                      ),
                      event: () {
                        ///TODO: receipt
                        Navigator.pushNamed(context, ReceiptPage.routeName);
                      },
                      showBorder: true,
                      buttonHeight: 48,
                      isRounded: true,
                      bgColor: Colors.white,
                    ),
                    largeVerticalSpacing(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
