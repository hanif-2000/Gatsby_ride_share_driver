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
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // int extraMinutes = 0;
  // int extraHour = 0;
  // int extraSeconds = 0;

  var extraTimeTaken = "0";

  convertSecondsToMinutes() {
    if (widget.extraTime != '') {
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
        extraTimeTaken = "$hours" ' hr ' '$remainingMinutes' ' min ' '$remainingSeconds' ' sec ';
      });
    } else {}
  }

  @override
  void initState() {
    convertSecondsToMinutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        title: const Text(
          "Payment",
          style: TextStyle(
              fontFamily: "poPPinSemiBold", fontSize: 18.0, color: blackColor),
        ),
        centerTitle: true,
        elevation: 1.0,
        shadowColor: whiteColor.withOpacity(0.5),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
            Container(
              decoration: BoxDecoration(
                color: greyB2B2B2Color.withOpacity(0.13),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.only(
                  top: 13, bottom: 13, left: 11, right: 11),
              child: Column(
                children: [
                  TextInRow(
                    firstText: 'Distance',
                    secondText: "${widget.distance} Km",
                  ),
                  const Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: 'Estimated Amount',
                    secondText: r'CA$ ' + widget.totalPrice.toString(),
                  ),
                  const Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: 'Extra Distance',
                    // secondText: widget.extraDistance + " Km",
                    secondText: widget.extraDistance + " Km",
                  ),
                  const Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: 'Extra Distance Price',
                    // secondText: widget.extraDistance + " Km",
                    secondText: "CA\$ " + widget.extraDistancePrice,
                  ),
                  const Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: 'Extra Time',
                    secondText: extraTimeTaken,
                    // secondText:
                  ),
                  const Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: 'Extra Time Price',
                    // secondText: widget.extraTime.toString() + ' Min',
                    secondText: "CA\$ " + widget.extraTimePrice,
                  ),
                  const Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: 'Actual Payment',
                    // secondText: widget.extraTime.toString() + ' Min',
                    secondText: "CA\$ " + widget.grandTotal,
                  ),
                  const Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    firstText: 'Customer Pending Payment',
                    // secondText: widget.extraTime.toString() + ' Min',
                    secondText: "CA\$ " + widget.pendingAmount,
                  ),
                  const Divider(
                    color: whiteAccentColor,
                  ),
                  TextInRow(
                    secondTextweight: FontWeight.w700,
                    firstText: 'Grand Total',
                    secondText: r'CA$ ' + widget.newTotal,
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
            // const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
