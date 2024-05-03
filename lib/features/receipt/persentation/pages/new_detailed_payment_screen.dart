import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/utility/convert_decimal_helper.dart';
import 'package:flutter/material.dart';
import '../../../../core/static/colors.dart';
import '../../widgets/common_text.dart';
import '../../widgets/text_in_row.dart';

class PaymentScreen extends StatefulWidget {
  final dynamic totalPrice;
  final dynamic grandTotal;
  final dynamic extraDistancePrice;
  final dynamic extraTimePrice;
  final dynamic extraDistance;
  final dynamic extraTime;
  final String distance;
  final dynamic newTotal;
  final dynamic pendingAmount;
  final dynamic techFee;
  final dynamic baseFare;
  final dynamic minimumFare;
  final dynamic actualDistance;
  final dynamic totalTime;
  final dynamic price_km;
  final dynamic price_min;

  const PaymentScreen({
    Key? key,
    required this.totalPrice,
    required this.extraDistance,
    required this.extraTime,
    required this.extraDistancePrice,
    required this.extraTimePrice,
    required this.grandTotal,
    required this.distance,
    required this.newTotal,
    required this.pendingAmount,
    required this.techFee,
    required this.baseFare,
    required this.minimumFare,
    required this.actualDistance,
    required this.totalTime,
    required this.price_km,
    required this.price_min,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // int extraMinutes = 0;
  // int extraHour = 0;
  // int extraSeconds = 0;

  var extraTimeTaken = "0";
  var totalTimeTaken = "0";

  convertSecondsToMinutes() {
    log("extra time :-->>${widget.extraTime}");
    if ((widget.extraTime.toString() != '')) {
      int seconds = int.parse(
          widget.extraTime); // Replace this with your desired number of seconds

      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;

      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;

      print('$seconds seconds is equivalent to:');
      print(
          '$hours hours, $remainingMinutes minutes, and $remainingSeconds seconds');

      setState(() {
        extraTimeTaken = "$hours"
            ' hr '
            '$remainingMinutes'
            ' min '
            '$remainingSeconds'
            ' sec ';
      });
    } else {}
  }

  convertSecondsToMinutesTotal() {
    log("extra time :-->>${widget.totalTime}");
    if ((widget.totalTime.toString() != '')) {
      final seconds = double.parse(widget.totalTime).toInt(); // Replace this with your desired number of seconds

      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;

      int hours = minutes ~/ 60;
      int remainingMinutes = minutes % 60;

      print('$seconds seconds is equivalent to:');
      print(
          '$hours hours, $remainingMinutes minutes, and $remainingSeconds seconds');

      setState(() {
        totalTimeTaken = "$hours"
            ' hr '
            '$remainingMinutes'
            ' min '
            '$remainingSeconds'
            ' sec ';
      });
    } else {}
  }

  @override
  void initState() {
    convertSecondsToMinutes();
    convertSecondsToMinutesTotal();
    super.initState();

    log("extra time is :${widget.extraTime}");
    log("extra distance is :${widget.extraDistance}");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            text: "Payment Information",
            fontWeight: FontWeight.w600,
            fontColor: blackColor,
            fontFamily: "poPPinMedium",
            fontSize: 16,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              color: greyB2B2B2Color.withOpacity(0.13),
              borderRadius: BorderRadius.circular(8),
            ),
            padding:
                const EdgeInsets.only(top: 13, bottom: 13, left: 11, right: 11),
            child: Column(
              children: [
                // TextInRow(
                //   firstText: 'Distance',
                //   secondText: "${widget.distance} Km",
                // ),
                // const Divider(
                //   color: whiteAccentColor,
                // ),
                // TextInRow(
                //   firstText: 'Estimated Amount',
                //   secondText: r'CA$ ' +
                //       convertToTwoDecimal(widget.totalPrice.toString()),
                // ),
                // const Divider(
                //   color: whiteAccentColor,
                // ),

                TextInRow(
                  firstText: 'Total Distance',
                  secondText: "${double.parse(widget.actualDistance.toString()).toStringAsFixed(2)} Km",
                ),
                const Divider(
                  color: whiteAccentColor,
                ),

                TextInRow(
                  firstText: 'Extra Distance',
                  // secondText: widget.extraDistance + " Km",
                  secondText: "${widget.extraDistance} Km",
                ),
                const Divider(
                  color: whiteAccentColor,
                ),
                TextInRow(
                  firstText: 'Per Km Price',
                  // secondText: widget.extraDistance + " Km",
                  secondText:
                      "CA\$ ${convertToTwoDecimal(widget.price_km??"0")}",
                ),
                const Divider(
                  color: whiteAccentColor,
                ),
                TextInRow(
                  firstText: 'Total Distance Price',
                  // secondText: widget.extraDistance + " Km",
                  secondText:
                      "CA\$ ${convertToTwoDecimal(widget.extraDistancePrice.toString())}",
                ),
                const Divider(
                  color: whiteAccentColor,
                ),

                TextInRow(
                  firstText: 'Total Time Taken',
                  secondText: totalTimeTaken.toString(),
                  // secondText:
                ),
                const Divider(
                  color: whiteAccentColor,
                ),
                TextInRow(
                  firstText: 'Extra Time',
                  secondText: extraTimeTaken.toString(),
                  // secondText:
                ),
                const Divider(
                  color: whiteAccentColor,
                ),
                TextInRow(
                  firstText: 'Per Minute Price',
                  secondText:  "CA\$ ${convertToTwoDecimal(widget.price_min??"0")}",
                  // secondText:
                ),
                const Divider(
                  color: whiteAccentColor,
                ),
                TextInRow(
                  firstText: 'Total Time Price',
                  // secondText: widget.extraTime.toString() + ' Min',
                  secondText:
                      "CA\$ ${convertToTwoDecimal(widget.extraTimePrice.toString())}",
                ),
                const Divider(
                  color: whiteAccentColor,
                ),
                // TextInRow(
                //   firstText: 'Actual Payment',
                //   // secondText: widget.extraTime.toString() + ' Min',
                //   secondText:
                //       "CA\$ ${convertToTwoDecimal(widget.totalPrice.toString())}",
                // ),
                // const Divider(
                //   color: whiteAccentColor,
                // ),
               /* TextInRow(
                  firstText: 'Customer Pending Payment',
                  // secondText: widget.extraTime.toString() + ' Min',
                  secondText:
                      "CA\$ ${convertToTwoDecimal(widget.pendingAmount.toString())}",
                ),
                const Divider(
                  color: whiteAccentColor,
                ),
*/        TextInRow(
                  firstText: 'Minimum Fare',
                  secondText: r'CA$ ' +
                      convertToTwoDecimal(widget.minimumFare.toString()),
                ),
                const Divider(
                  color: whiteAccentColor,
                ),

                TextInRow(
                  firstText: 'Tech Fee',
                  secondText:
                      r'CA$ ' + convertToTwoDecimal(widget.techFee),
                ),
                const Divider(
                  color: whiteAccentColor,
                ),
                TextInRow(
                  firstText: 'Base Fare',
                  secondText:
                      r'CA$ ' + convertToTwoDecimal(widget.baseFare.toString()),
                ),
                const Divider(
                  color: whiteAccentColor,
                ),

                TextInRow(
                    secondTextweight: FontWeight.w700,
                    firstText: 'Grand Total',
                    secondText: r'CA$ ' + widget.newTotal
                    // widget.newTotal != ""
                    //     ? (double.parse(widget.grandTotal.toString()))
                    //         .toStringAsFixed(2)
                    //     : "0",
                    ),
              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: _deviceSize.height * .02),
          //   child: const Text(
          //     "Payment Through",
          //     style: TextStyle(
          //       fontFamily: "poPPinMedium",
          //       fontSize: 13.0,
          //       color: grey7D7979Color,
          //     ),
          //   ),
          // ),

          // GooglePayButton(
          //   paymentConfigurationAsset: 'google_pay_config.json',
          //   paymentItems: _paymentItems,
          //   style: GooglePayButtonStyle.black,
          //   type: GooglePayButtonType.pay,
          //   margin: const EdgeInsets.only(top: 15.0),
          //   onPaymentResult: onGooglePayResult,
          //   loadingIndicator: const Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // )

          // // Example pay button configured using an asset
          // FutureBuilder<PaymentConfiguration>(
          //     future: _googlePayConfigFuture,
          //     builder: (context, snapshot) => snapshot.hasData
          //         ? GooglePayButton(
          //             paymentConfiguration: snapshot.data!,
          //             paymentItems: _paymentItems,
          //             type: GooglePayButtonType.buy,
          //             margin: const EdgeInsets.only(top: 15.0),
          //             onPaymentResult: onGooglePayResult,
          //             loadingIndicator: const Center(
          //               child: CircularProgressIndicator(),
          //             ),
          //           )
          //         : const SizedBox.shrink()),
          // // Example pay button configured using a string
          // ApplePayButton(
          //   paymentConfiguration: PaymentConfiguration.fromJsonString(
          //       payment_configurations.defaultApplePay),
          //   paymentItems: _paymentItems,
          //   style: ApplePayButtonStyle.black,
          //   type: ApplePayButtonType.buy,
          //   margin: const EdgeInsets.only(top: 15.0),
          //   onPaymentResult: onApplePayResult,
          //   loadingIndicator: const Center(
          //     child: CircularProgressIndicator(),
          //   ),
          // ),
          SizedBox(height: MediaQuery.of(context).size.height * .05)
        ],
      ),
    );
  }
}
