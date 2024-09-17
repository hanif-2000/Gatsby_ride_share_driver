import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/utility/convert_decimal_helper.dart';
import 'package:flutter/material.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/utility/duration_helper.dart';
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
    super.key,
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
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {


  String totalDistancePrice() {
    double extraDistance = double.parse(widget.actualDistance.toString());
    double priceKm = double.parse(widget.price_km.toString());
    var totalDistancePrice = extraDistance*priceKm;
    return totalDistancePrice.toStringAsFixed(2);

  }

  @override
  void initState() {
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

                TextInRow(
                  firstText: 'Total Distance',
                  secondText: "${double.parse(widget.actualDistance.toString()).toStringAsFixed(2)} Km",
                ),
                const Divider(
                  color: whiteAccentColor,
                ),

           /*     TextInRow(
                  firstText: 'Extra Distance',
                  // secondText: widget.extraDistance + " Km",
                  secondText: "${widget.extraDistance} Km",
                ),
                const Divider(
                  color: whiteAccentColor,
                ),*/
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
                     // "CA\$ ${convertToTwoDecimal(widget.extraDistancePrice.toString())}",
                      "CA\$ ${totalDistancePrice()}",
                ),
                const Divider(
                  color: whiteAccentColor,
                ),

                TextInRow(
                  firstText: 'Total Time Taken',
                  secondText: formatDuration(widget.totalTime),
                  // secondText:
                ),
                const Divider(
                  color: whiteAccentColor,
                ),
               /* TextInRow(
                  firstText: 'Extra Time',
                  secondText: extraTimeTaken.toString(),
                  // secondText:
                ),
                const Divider(
                  color: whiteAccentColor,
                ),*/
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
                TextInRow(
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
                    ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * .05)
        ],
      ),
    );
  }
}
