import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.2),
            blurRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(
              20.0,
            ),
            decoration: const BoxDecoration(
              color: greyF9F9F9,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '12 May 2023, 12:30PM',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ).usePoppinsW6Font(),
                ),
                Row(
                  children: [
                    Container(
                      height: 6,
                      width: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: yellowE5A829,
                      ),
                    ),
                    smallHorizontalSpacing(),
                    Text(
                      appLoc.inProgress,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: greyB6B6B6,
                      ).usePoppinsW6Font(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
              left: 20.0,
              right: 20,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/home/ic_pickup.svg',
                            height: 23,
                            width: 23,
                          ),
                          mediumHorizontalSpacing(),
                          Expanded(
                            child: Text(
                              'PJCX+6R3, Sector 115',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ).usePoppinsW4Font(),
                            ),
                          ),
                        ],
                      ),
                      mediumVerticalSpacing(),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/home/ic_drop_pin.svg',
                            height: 23,
                            width: 23,
                          ),
                          mediumHorizontalSpacing(),
                          Expanded(
                            child: Text(
                              'PJCX+6R3, Sector 115',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ).usePoppinsW4Font(),
                            ),
                          ),
                        ],
                      ),
                      mediumVerticalSpacing(),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      appLoc.totalFare,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ).usePoppinsW6Font(),
                    ),
                    Text(
                      '\$112',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                      ).usePoppinsW6Font(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const Divider(
                  color: grey9c9c9c,
                ),
                mediumVerticalSpacing(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appLoc.rideType,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ).usePoppinsW5Font(),
                    ),
                    Text(
                      'Mini (4 Person)',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ).usePoppinsW5Font(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appLoc.paymentmethod,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ).usePoppinsW5Font(),
                    ),
                    smallVerticalSpacing(),
                    Text(
                      'Cash Payment',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ).usePoppinsW5Font(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          mediumVerticalSpacing(),
        ],
      ),
    );
  }
}
