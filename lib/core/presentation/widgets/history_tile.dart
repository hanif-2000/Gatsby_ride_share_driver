import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/history/data/models/history_response_model.dart';
import 'package:appkey_taxiapp_driver/features/order_detail/presentation/page/order_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({Key? key, this.order}) : super(key: key);
  final HistoryOrder? order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, OrderDetailPage.routeName,
            arguments: order);
      },
      child: Container(
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
                    "${DateFormat.yMMMd().format((DateFormat("yyyy-MM-dd HH:mm:ss").parse(order!.orderTime.toString(), true)).toLocal())} ${DateFormat.jm().format((DateFormat("yyyy-MM-dd HH:mm:ss").parse(order!.orderTime.toString(), true)).toLocal())}",

                    // "${(DateFormat("yyyy-MM-dd HH:mm:ss").parse(order!.orderTime.toString(), true)).toLocal()}",

                    // '${DateFormat.yMMMd().format(order!.orderTime!)}, ${DateFormat.jm().format(order!.orderTime!)}',
                    // '${order!.orderTime.toIso8601String()}',
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
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: getStatusColor(
                            order!.status,
                          ),
                        ),
                      ),
                      smallHorizontalSpacing(),
                      Text(
                        getOrderStatus(order!.status),
                        // appLoc.inProgress,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: getStatusColor(
                            order!.status,
                          ),
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
                                // 'PJCX+6R3, Sector 115',
                                order!.startAddress,
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
                                order!.endAddress,
                                // 'PJCX+6R3, Sector 115',
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
                  smallHorizontalSpacing(),
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
                        order!.tip == "0"
                            ? 'CA\$ ${order!.total} '
                            : 'CA\$ ${order!.grandTotal}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
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
                        '${order!.vehicleCategory.category} (${order!.vehicleCategory.seat} Person)',
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
                        order!.paymentMethod == 1
                            ? 'Cash Payment'
                            : order!.paymentMethod == 2
                                ? "Credit Card"
                                : order!.paymentMethod == 3
                                    ? 'Google Pay'
                                    : 'Apple Pay',
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
      ),
    );
  }
}
