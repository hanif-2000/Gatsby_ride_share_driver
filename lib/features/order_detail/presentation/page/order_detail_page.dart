import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/convert_one_decimal_helper.dart';
import 'package:appkey_taxiapp_driver/features/history/data/models/history_response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/pages/other_user_profile.dart';
import '../../../../core/presentation/providers/home_provider.dart';
import '../../../../core/presentation/widgets/cache_network_widget.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/app_settings.dart';
import '../../../../core/utility/helper.dart';
import '../../../rating/presentation/page/give_rating_screen.dart';
import '../../../rating/presentation/page/rating_list_page.dart';
import '../widget/address_tile.dart';
import '../widget/price_tile.dart';
import '../widget/rating_tile.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({Key? key, this.order}) : super(key: key);
  static const routeName = '/OrderDetailPage';
  final HistoryOrder? order;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  var extraTimeTaken = "0 hr 0 Min 0 Sec";

  convertSecondsToMinutes() {
    if (widget.order!.extraTimeTaken != '') {
      int seconds = int.parse(widget.order!.extraTimeTaken
          .toString()); // Replace this with your desired number of seconds

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

  @override
  void initState() {
    convertSecondsToMinutes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            largeVerticalSpacing(),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: SvgPicture.asset('assets/icons/auth/ic_back.svg'),
                  ),
                  Text(
                    appLoc.tripDetail,
                    textAlign: TextAlign.center,
                    style: titleStyle.copyWith(
                      fontSize: fontLarge,
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              color: yellowF9EACC,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    // '${DateFormat.yMMMd().format(order!.orderTime!)}, ${DateFormat.jm().format(order!.orderTime!)}',
                    "${DateFormat.yMMMd().format((DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.order!.orderTime.toString(), true)).toLocal())} ${DateFormat.jm().format((DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.order!.orderTime.toString(), true)).toLocal())}",
                    textAlign: TextAlign.center,
                    style: titleStyle
                        .copyWith(
                          fontSize: 14,
                        )
                        .usePoppinsW5Font(),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: getStatusColor(
                            widget.order!.status,
                          ),
                        ),
                      ),
                      smallHorizontalSpacing(),
                      Text(
                        getOrderStatus(widget.order!.status),
                        textAlign: TextAlign.center,
                        style: titleStyle
                            .copyWith(
                              fontSize: 14,
                              color: getStatusColor(
                                widget.order!.status,
                              ),
                            )
                            .usePoppinsW5Font(),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Consumer<HomeProvider>(builder: (context, provider, _) {
              return SizedBox(
                height: 216,
                child: GoogleMap(
                  mapType: MapType.normal,
                  gestureRecognizers: {}..add(
                      Factory<PanGestureRecognizer>(
                        () => PanGestureRecognizer(),
                      ),
                    ),
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: false,
                  initialCameraPosition: const CameraPosition(
                    target: DEFAULT_LATLNG,
                    zoom: 14.4746,
                  ),
                  polylines: provider.polylines,
                  markers: Set<Marker>.of(provider.markers.values),
                  onMapCreated: (GoogleMapController controller) async {
                    provider.googleMapController = controller;
                    // await provider.setCurrentLocation(
                    //     widget.orderDetail, widget.customerDetail);
                    final pickup = LatLng(
                        double.tryParse(
                            widget.order!.startCoordinate!.split(',').first)!,
                        double.tryParse(
                            widget.order!.startCoordinate!.split(',').last)!);
                    final drop = LatLng(
                        double.tryParse(
                            widget.order!.endCoordinate!.split(',').first)!,
                        double.tryParse(
                            widget.order!.endCoordinate!.split(',').last)!);
                    await provider.createPickupAndDropMarker(pickup, drop);
                    await provider.setPolylineDirection(pickup, drop);
                  },
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const UserProfileTile(),
                  SizedBox(
                    child: Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, OtherUserProfile.routeName);
                            },
                            child: CustomCacheNetworkImage(
                                img: widget.order!.image, size: 45)

                            // Container(
                            //   height: 45,
                            //   width: 45,
                            //   decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: redD03B3B,
                            //     image: DecorationImage(
                            //       image: NetworkImage(
                            //         '$BASE_URL${order!.image}',
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            ),
                        mediumHorizontalSpacing(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.order!.userName,
                              textAlign: TextAlign.center,
                              style: titleStyle
                                  .copyWith(
                                    fontSize: 16,
                                  )
                                  .usePoppinsW5Font(),
                            ),
                            InkWell(
                              onTap: () {
                                log(widget.order!.customerId!);
                                Navigator.pushNamed(
                                    context, RatingListPage.routeName,
                                    arguments:
                                        int.parse(widget.order!.customerId!));
                                // context,
                                GiveRatingScreen.routeName;
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      'assets/icons/home/ic_start.svg'),
                                  smallHorizontalSpacing(),
                                  Text(
                                    convertToOneDecimal(
                                        widget.order!.rating.toString()),
                                    textAlign: TextAlign.center,
                                    style: titleStyle
                                        .copyWith(
                                          fontSize: 14,
                                        )
                                        .usePoppinsW6Font(),
                                  ),
                                  smallHorizontalSpacing(),

                                  /*** REVIEWS */
                                  Text(
                                    'Reviews',
                                    textAlign: TextAlign.center,
                                    style: titleStyle
                                        .copyWith(
                                          fontSize: 14,
                                          color: yellowE5A829,
                                          decoration: TextDecoration.underline,
                                        )
                                        .usePoppinsW5Font(),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'CA\$ ${widget.order!.newTotal}',
                              // widget.order!.tip == '0'
                              //     ? 'CA\$ ${widget.order!.total.toStringAsFixed(2)}'
                              //     : 'CA\$ ${widget.order!.grandTotal.toStringAsFixed(2)}',
                              textAlign: TextAlign.center,
                              style: titleStyle
                                  .copyWith(
                                    fontSize: 16,
                                  )
                                  .usePoppinsW6Font(),
                            ),
                            Text(
                              '${widget.order!.distance} Km',
                              textAlign: TextAlign.center,
                              style: titleStyle
                                  .copyWith(
                                    fontSize: 14,
                                    color: greyB6B6B6,
                                  )
                                  .usePoppinsW5Font(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  largeVerticalSpacing(),

                  /*** ORIGIN ADDRESS */
                  AddressTile(
                    icon: 'assets/icons/home/ic_pickup.svg',
                    title: 'Pickup Location',
                    address: widget.order!.startAddress,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(
                      color: grey9c9c9c,
                    ),
                  ),

                  /*** DESTINATION ADDRESS */

                  AddressTile(
                    icon: 'assets/icons/home/ic_drop_pin.svg',
                    title: 'Drop location',
                    address: widget.order!.endAddress,
                  ),
                  largeVerticalSpacing(),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: yellowF9EACC,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${DateFormat.yMMMd().format((DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.order!.orderTime.toString(), true)).toLocal())} ${DateFormat.jm().format((DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.order!.orderTime.toString(), true)).toLocal())}",
                          // '${DateFormat.yMMMd().format(widget.order!.orderTime!)}, ${DateFormat.jm().format(widget.order!.orderTime!)}',
                          textAlign: TextAlign.center,
                          style: titleStyle
                              .copyWith(
                                fontSize: 14,
                              )
                              .usePoppinsW5Font(),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: getStatusColor(
                                  widget.order!.status,
                                ),
                              ),
                            ),
                            smallHorizontalSpacing(),
                            Text(
                              getOrderStatus(widget.order!.status),
                              textAlign: TextAlign.center,
                              style: titleStyle
                                  .copyWith(
                                    fontSize: 14,
                                    color: getStatusColor(
                                      widget.order!.status,
                                    ),
                                  )
                                  .usePoppinsW5Font(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  largeVerticalSpacing(),

                  getOrderStatus(widget.order!.status) != appLoc.cancelled
                      ? Container(
                          child: Column(children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: whiteAccentColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Container(
                                  //   width: 6,
                                  //   height: 6,
                                  //   decoration: BoxDecoration(
                                  //     shape: BoxShape.circle,
                                  //     color: getStatusColor(
                                  //       widget.order!.status,
                                  //     ),
                                  //   ),
                                  // ),

                                  const Text(
                                    "Payment Status",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  // smallHorizontalSpacing(),
                                  Text(
                                    widget.order!.paymentStatus == "no"
                                        ? "Pending"
                                        : "Paid",
                                    textAlign: TextAlign.center,
                                    style: titleStyle
                                        .copyWith(
                                            fontSize: 14,
                                            color:
                                                widget.order!.paymentStatus ==
                                                        "no"
                                                    ? redf52d56Color
                                                    : green2DAA5FColor)
                                        .usePoppinsW5Font(),
                                  ),
                                ],
                              ),
                            ),
                            PriceTile(
                              title: 'Distance',
                              value: '${widget.order!.distance} KM',
                            ),
                            PriceTile(
                              title: 'Cab Type',
                              value:
                                  '${widget.order!.vehicleCategory.category}( ${widget.order!.vehicleCategory.seat} Persons)',
                            ),
                            // PriceTile(
                            //   title: 'Price',
                            //   value: 'CA\$ ${widget.order!.total}',
                            // ),
                            PriceTile(
                              title: 'Current Ride Payment',
                              // value: 'CA\$ ${(widget.order!.grandTotal).toStringAsFixed(2)}',
                              value: 'CA\$ ${(widget.order!.total)}',
                            ),
                            PriceTile(
                              title: 'Pending Ride Payment',
                              value: 'CA\$ ${widget.order!.pendingAmount}',
                            ),
                            PriceTile(
                              title: 'Extra Time Taken',
                              value: ((widget.order!.extraTimeTaken != '') ||
                                      (widget.order!.extraTimeTaken != null))
                                  ? extraTimeTaken
                                  : '0 hr 0 min 0 sec',
                            ),
                            PriceTile(
                              title: 'Extra Time Price',
                              // value: 'CA\$ ${(widget.order!.grandTotal).toStringAsFixed(2)}',
                              value: 'CA\$ ${(widget.order!.extraTimePrice)}',
                            ),

                            PriceTile(
                              title: 'Extra Distance',
                              // value: 'CA\$ ${(widget.order!.grandTotal).toStringAsFixed(2)}',
                              value: '${(widget.order!.extraDistance)} Km',
                            ),
                            PriceTile(
                              title: 'Extra Distance Price',
                              // value: 'CA\$ ${(widget.order!.grandTotal).toStringAsFixed(2)}',
                              value:
                                  'CA\$ ${(widget.order!.extraDistancePrice)}',
                            ),

                            PriceTile(
                              title: 'Tip',
                              value: 'CA\$ ${widget.order!.tip}',
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 16.0),
                              child: Divider(
                                color: grey9c9c9c,
                              ),
                            ),
                            PriceTile(
                              title: 'Total',
                              value:
                                  // 'CA\$ ${(double.parse(widget.order!.newTotal)).toStringAsFixed(2)}',
                                  'CA\$ ${(double.parse(widget.order!.newTotal))}',

                              // value: widget.order!.tip == '0'
                              //     ? 'CA\$ ${widget.order!.total.toStringAsFixed(2)}'
                              //     : 'CA\$ ${widget.order!.grandTotal.toStringAsFixed(2)}',
                              fontSize: 18,
                            ),
                          ]),
                        )
                      : const SizedBox()
                  // PriceTile(
                  //   title: 'Distance',
                  //   value: '${widget.order!.distance} KM',
                  // ),
                  // PriceTile(
                  //   title: 'Cab Type',
                  //   value:
                  //       '${widget.order!.vehicleCategory.category}( ${widget.order!.vehicleCategory.seat} Persons)',
                  // ),
                  // // PriceTile(
                  // //   title: 'Price',
                  // //   value: 'CA\$ ${widget.order!.total}',
                  // // ),
                  // PriceTile(
                  //   title: 'Current Ride Payment',
                  //   // value: 'CA\$ ${(widget.order!.grandTotal).toStringAsFixed(2)}',
                  //   value: 'CA\$ ${(widget.order!.grandTotal)}',
                  // ),
                  // PriceTile(
                  //   title: 'Pending Ride Payment',
                  //   value: 'CA\$ ${widget.order!.pendingAmount}',
                  // ),
                  // PriceTile(
                  //   title: 'Tip',
                  //   value: 'CA\$ ${widget.order!.tip}',
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.only(top: 16.0),
                  //   child: Divider(
                  //     color: grey9c9c9c,
                  //   ),
                  // ),
                  // PriceTile(
                  //   title: 'Total',
                  //   value:
                  //       // 'CA\$ ${(double.parse(widget.order!.newTotal)).toStringAsFixed(2)}',
                  //       'CA\$ ${(double.parse(widget.order!.newTotal))}',

                  //   // value: widget.order!.tip == '0'
                  //   //     ? 'CA\$ ${widget.order!.total.toStringAsFixed(2)}'
                  //   //     : 'CA\$ ${widget.order!.grandTotal.toStringAsFixed(2)}',
                  //   fontSize: 18,
                  // ),
                  ,
                  largeVerticalSpacing(),

                  ...List.generate(
                    widget.order!.ratingList.length,
                    (index) {
                      if (widget.order!.ratingList[index].type == 2) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rating Given',
                              textAlign: TextAlign.center,
                              style: titleStyle
                                  .copyWith(
                                    fontSize: 16,
                                    color: grey7D7979,
                                  )
                                  .usePoppinsW5Font(),
                            ),
                            mediumVerticalSpacing(),
                            RatingTile(
                              rating: widget.order!.ratingList[index],
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            largeVerticalSpacing(),
                            Text(
                              'Rating Received',
                              textAlign: TextAlign.center,
                              style: titleStyle
                                  .copyWith(
                                    fontSize: 16,
                                    color: grey7D7979,
                                  )
                                  .usePoppinsW5Font(),
                            ),
                            mediumVerticalSpacing(),
                            RatingTile(
                              rating: widget.order!.ratingList[index],
                            ),
                          ],
                        );
                      }
                    },
                  ),

                  // Text(
                  //   'Rating Given',
                  //   textAlign: TextAlign.center,
                  //   style: titleStyle
                  //       .copyWith(
                  //         fontSize: 16,
                  //         color: grey7D7979,
                  //       )
                  //       .usePoppinsW5Font(),
                  // ),
                  // mediumVerticalSpacing(),
                  // const RatingTile(),
                  // largeVerticalSpacing(),
                  // Text(
                  //   'Rating Received',
                  //   textAlign: TextAlign.center,
                  //   style: titleStyle
                  //       .copyWith(
                  //         fontSize: 16,
                  //         color: grey7D7979,
                  //       )
                  //       .usePoppinsW5Font(),
                  // ),
                  // mediumVerticalSpacing(),
                  // const RatingTile(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//     );
//   }
// }



// class OrderDetailPage extends StatelessWidget {
//   const OrderDetailPage({Key? key, this.order}) : super(key: key);
//   static const routeName = '/OrderDetailPage';
//   final HistoryOrder? order;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // body: ListView(
//       //   children: [
//       //     AspectRatio(
//       //       aspectRatio: 5 / 4.4,
//       //       child: Column(
//       //         children: [
//       //           // largeVerticalSpacing(),
//       //           Padding(
//       //             padding: const EdgeInsets.only(top: 20, bottom: 16),
//       //             child: Row(
//       //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //               children: [
//       //                 IconButton(
//       //                   onPressed: () {
//       //                     Navigator.pop(context);
//       //                   },
//       //                   icon: SvgPicture.asset('assets/icons/auth/ic_back.svg'),
//       //                 ),
//       //                 Text(
//       //                   appLoc.tripDetail,
//       //                   textAlign: TextAlign.center,
//       //                   style: titleStyle.copyWith(
//       //                     fontSize: fontLarge,
//       //                   ),
//       //                 ),
//       //                 const SizedBox(
//       //                   width: 30,
//       //                 ),
//       //               ],
//       //             ),
//       //           ),
//       //           Container(
//       //             padding: const EdgeInsets.all(20),
//       //             color: yellowF9EACC,
//       //             child: Row(
//       //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //               children: [
//       //                 Text(
//       //                   '10 May 2023, 12:30PM',
//       //                   textAlign: TextAlign.center,
//       //                   style: titleStyle
//       //                       .copyWith(
//       //                         fontSize: 14,
//       //                       )
//       //                       .usePoppinsW5Font(),
//       //                 ),
//       //                 Row(
//       //                   children: [
//       //                     Container(
//       //                       width: 6,
//       //                       height: 6,
//       //                       decoration: const BoxDecoration(
//       //                         shape: BoxShape.circle,
//       //                         color: green2DAA5F,
//       //                       ),
//       //                     ),
//       //                     smallHorizontalSpacing(),
//       //                     Text(
//       //                       'Completed',
//       //                       textAlign: TextAlign.center,
//       //                       style: titleStyle
//       //                           .copyWith(
//       //                             fontSize: 14,
//       //                             color: green2DAA5F,
//       //                           )
//       //                           .usePoppinsW5Font(),
//       //                     ),
//       //                   ],
//       //                 )
//       //               ],
//       //             ),
//       //           ),
//       //           SizedBox(
//       //             height: 216,
//       //             child: GoogleMap(
//       //               mapType: MapType.normal,
//       //               myLocationButtonEnabled: false,
//       //               zoomControlsEnabled: false,
//       //               initialCameraPosition: const CameraPosition(
//       //                 target: JAPAN_LATLNG,
//       //                 zoom: 14.4746,
//       //               ),
//       //               onMapCreated: (GoogleMapController controller) async {
//       //                 // provider.googleMapController = controller;
//       //                 // await provider.setCurrentLocation(
//       //                 //     widget.orderDetail, widget.customerDetail);
//       //               },
//       //             ),
//       //           ),
//       //         ],
//       //       ),
//       //     ),
//       //     Padding(
//       //       padding: const EdgeInsets.all(20.0),
//       //       child: Column(
//       //         crossAxisAlignment: CrossAxisAlignment.start,
//       //         children: [
//       //           Row(
//       //             children: [
//       //               Container(
//       //                 height: 45,
//       //                 width: 45,
//       //                 decoration: const BoxDecoration(
//       //                   shape: BoxShape.circle,
//       //                   color: redD03B3B,
//       //                 ),
//       //               ),
//       //               mediumHorizontalSpacing(),
//       //               Column(
//       //                 children: [
//       //                   Text(
//       //                     'Johan Green',
//       //                     textAlign: TextAlign.center,
//       //                     style: titleStyle
//       //                         .copyWith(
//       //                           fontSize: 16,
//       //                         )
//       //                         .usePoppinsW5Font(),
//       //                   ),
//       //                   Row(
//       //                     children: [
//       //                       SvgPicture.asset('assets/icons/home/ic_start.svg'),
//       //                       smallHorizontalSpacing(),
//       //                       Text(
//       //                         '4.5',
//       //                         textAlign: TextAlign.center,
//       //                         style: titleStyle
//       //                             .copyWith(
//       //                               fontSize: 14,
//       //                             )
//       //                             .usePoppinsW6Font(),
//       //                       ),
//       //                       smallHorizontalSpacing(),
//       //                       Text(
//       //                         'Reviews',
//       //                         textAlign: TextAlign.center,
//       //                         style: titleStyle
//       //                             .copyWith(
//       //                               fontSize: 14,
//       //                               color: yellowE5A829,
//       //                               decoration: TextDecoration.underline,
//       //                             )
//       //                             .usePoppinsW5Font(),
//       //                       ),
//       //                     ],
//       //                   )
//       //                 ],
//       //               ),
//       //               const Spacer(),
//       //               Column(
//       //                 children: [
//       //                   Text(
//       //                     '\$80.00',
//       //                     textAlign: TextAlign.center,
//       //                     style: titleStyle
//       //                         .copyWith(
//       //                           fontSize: 16,
//       //                         )
//       //                         .usePoppinsW6Font(),
//       //                   ),
//       //                   Text(
//       //                     '4.5 Km',
//       //                     textAlign: TextAlign.center,
//       //                     style: titleStyle
//       //                         .copyWith(
//       //                           fontSize: 14,
//       //                           color: greyB6B6B6,
//       //                         )
//       //                         .usePoppinsW5Font(),
//       //                   ),
//       //                 ],
//       //               )
//       //             ],
//       //           ),
//       //           largeVerticalSpacing(),
//       //           const AddressTile(
//       //             icon: 'assets/icons/home/ic_pickup.svg',
//       //             title: 'Pickup Location',
//       //             address: 'PJCX+6R3, Sector 115, Lorem ipsum dolor sit amet',
//       //           ),
//       //           const Padding(
//       //             padding: EdgeInsets.symmetric(vertical: 16.0),
//       //             child: Divider(
//       //               color: grey9c9c9c,
//       //             ),
//       //           ),
//       //           const AddressTile(
//       //             icon: 'assets/icons/home/ic_drop_pin.svg',
//       //             title: 'Drop location',
//       //             address: 'PJCX+6R3, Sector 115, Lorem ipsum dolor sit amet',
//       //           ),
//       //           largeVerticalSpacing(),
//       //           Container(
//       //             padding: const EdgeInsets.all(20),
//       //             decoration: BoxDecoration(
//       //               color: yellowF9EACC,
//       //               borderRadius: BorderRadius.circular(8),
//       //             ),
//       //             child: Row(
//       //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       //               children: [
//       //                 Text(
//       //                   '10 May 2023, 12:30PM',
//       //                   textAlign: TextAlign.center,
//       //                   style: titleStyle
//       //                       .copyWith(
//       //                         fontSize: 14,
//       //                       )
//       //                       .usePoppinsW5Font(),
//       //                 ),
//       //                 Row(
//       //                   children: [
//       //                     Container(
//       //                       width: 6,
//       //                       height: 6,
//       //                       decoration: const BoxDecoration(
//       //                         shape: BoxShape.circle,
//       //                         color: green2DAA5F,
//       //                       ),
//       //                     ),
//       //                     smallHorizontalSpacing(),
//       //                     Text(
//       //                       'Completed',
//       //                       textAlign: TextAlign.center,
//       //                       style: titleStyle
//       //                           .copyWith(
//       //                             fontSize: 14,
//       //                             color: green2DAA5F,
//       //                           )
//       //                           .usePoppinsW5Font(),
//       //                     ),
//       //                   ],
//       //                 )
//       //               ],
//       //             ),
//       //           ),
//       //           largeVerticalSpacing(),
//       //           const PriceTile(
//       //             title: 'Distance',
//       //             value: '10 KM',
//       //           ),
//       //           const PriceTile(
//       //             title: 'Cab Type',
//       //             value: 'Mini( 4 Persons)  ',
//       //           ),
//       //           const PriceTile(
//       //             title: 'Price',
//       //             value: '\$112',
//       //           ),
//       //           const Padding(
//       //             padding: EdgeInsets.only(top: 16.0),
//       //             child: Divider(
//       //               color: grey9c9c9c,
//       //             ),
//       //           ),
//       //           const PriceTile(
//       //             title: 'Total',
//       //             value: '\$112',
//       //             fontSize: 18,
//       //           ),
//       //           largeVerticalSpacing(),
//       //           Text(
//       //             'Rating Given',
//       //             textAlign: TextAlign.center,
//       //             style: titleStyle
//       //                 .copyWith(
//       //                   fontSize: 16,
//       //                   color: grey7D7979,
//       //                 )
//       //                 .usePoppinsW5Font(),
//       //           ),
//       //           mediumVerticalSpacing(),
//       //           const RatingTile(),
//       //           largeVerticalSpacing(),
//       //           Text(
//       //             'Rating Received',
//       //             textAlign: TextAlign.center,
//       //             style: titleStyle
//       //                 .copyWith(
//       //                   fontSize: 16,
//       //                   color: grey7D7979,
//       //                 )
//       //                 .usePoppinsW5Font(),
//       //           ),
//       //           mediumVerticalSpacing(),
//       //           const RatingTile(),
//       //         ],
//       //       ),
//       //     ),
//       //   ],
//       // ),

//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             largeVerticalSpacing(),
//             Padding(
//               padding: const EdgeInsets.only(top: 20, bottom: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   IconButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: SvgPicture.asset('assets/icons/auth/ic_back.svg'),
//                   ),
//                   Text(
//                     appLoc.tripDetail,
//                     textAlign: TextAlign.center,
//                     style: titleStyle.copyWith(
//                       fontSize: fontLarge,
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 30,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(20),
//               color: yellowF9EACC,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     // '${DateFormat.yMMMd().format(widget.order!.orderTime!)}, ${DateFormat.jm().format(widget.order!.orderTime!)}',
//                     "${DateFormat.yMMMd().format((DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.order!.orderTime.toString(), true)).toLocal())} ${DateFormat.jm().format((DateFormat("yyyy-MM-dd HH:mm:ss").parse(widget.order!.orderTime.toString(), true)).toLocal())}",
//                     textAlign: TextAlign.center,
//                     style: titleStyle
//                         .copyWith(
//                           fontSize: 14,
//                         )
//                         .usePoppinsW5Font(),
//                   ),
//                   Row(
//                     children: [
//                       Container(
//                         width: 6,
//                         height: 6,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: getStatusColor(
//                             widget.order!.status,
//                           ),
//                         ),
//                       ),
//                       smallHorizontalSpacing(),
//                       Text(
//                         getOrderStatus(widget.order!.status),
//                         textAlign: TextAlign.center,
//                         style: titleStyle
//                             .copyWith(
//                               fontSize: 14,
//                               color: getStatusColor(
//                                 widget.order!.status,
//                               ),
//                             )
//                             .usePoppinsW5Font(),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             Consumer<HomeProvider>(builder: (context, provider, _) {
//               return SizedBox(
//                 height: 216,
//                 child: GoogleMap(
//                   mapType: MapType.normal,
//                   gestureRecognizers: {}..add(
//                       Factory<PanGestureRecognizer>(
//                         () => PanGestureRecognizer(),
//                       ),
//                     ),
//                   myLocationButtonEnabled: true,
//                   zoomControlsEnabled: false,
//                   initialCameraPosition: const CameraPosition(
//                     target: DEFAULT_LATLNG,
//                     zoom: 14.4746,
//                   ),
//                   polylines: provider.polylines,
//                   markers: Set<Marker>.of(provider.markers.values),
//                   onMapCreated: (GoogleMapController controller) async {
//                     provider.googleMapController = controller;
//                     // await provider.setCurrentLocation(
//                     //     widget.orderDetail, widget.customerDetail);
//                     final pickup = LatLng(
//                         double.tryParse(
//                             widget.order!.startCoordinate.split(',').first)!,
//                         double.tryParse(
//                             widget.order!.startCoordinate.split(',').last)!);
//                     final drop = LatLng(
//                         double.tryParse(widget.order!.endCoordinate.split(',').first)!,
//                         double.tryParse(widget.order!.endCoordinate.split(',').last)!);
//                     await provider.createPickupAndDropMarker(pickup, drop);
//                     await provider.setPolylineDirection(pickup, drop);
//                   },
//                 ),
//               );
//             }),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // const UserProfileTile(),
//                   SizedBox(
//                     child: Row(
//                       children: [
//                         InkWell(
//                             onTap: () {
//                               Navigator.pushNamed(
//                                   context, OtherUserProfile.routeName);
//                             },
//                             child: CustomCacheNetworkImage(
//                                 img: widget.order!.image, size: 45)

//                             // Container(
//                             //   height: 45,
//                             //   width: 45,
//                             //   decoration: BoxDecoration(
//                             //     shape: BoxShape.circle,
//                             //     color: redD03B3B,
//                             //     image: DecorationImage(
//                             //       image: NetworkImage(
//                             //         '$BASE_URL${widget.order!.image}',
//                             //       ),
//                             //     ),
//                             //   ),
//                             // ),
//                             ),
//                         mediumHorizontalSpacing(),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               widget.order!.userName,
//                               textAlign: TextAlign.center,
//                               style: titleStyle
//                                   .copyWith(
//                                     fontSize: 16,
//                                   )
//                                   .usePoppinsW5Font(),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 log(order!.customerId);
//                                 Navigator.pushNamed(
//                                     context, RatingListPage.routeName,
//                                     arguments: int.parse(order!.customerId));
//                                 // context,
//                                 GiveRatingScreen.routeName;
//                               },
//                               child: Row(
//                                 children: [
//                                   SvgPicture.asset(
//                                       'assets/icons/home/ic_start.svg'),
//                                   smallHorizontalSpacing(),
//                                   Text(
//                                     '${order!.rating}',
//                                     textAlign: TextAlign.center,
//                                     style: titleStyle
//                                         .copyWith(
//                                           fontSize: 14,
//                                         )
//                                         .usePoppinsW6Font(),
//                                   ),
//                                   smallHorizontalSpacing(),
//                                   Text(
//                                     'Reviews',
//                                     textAlign: TextAlign.center,
//                                     style: titleStyle
//                                         .copyWith(
//                                           fontSize: 14,
//                                           color: yellowE5A829,
//                                           decoration: TextDecoration.underline,
//                                         )
//                                         .usePoppinsW5Font(),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                         const Spacer(),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Text(
//                               'CA\$ ${order!.newTotal}',
//                               // order!.tip == '0'
//                               //     ? 'CA\$ ${order!.total.toStringAsFixed(2)}'
//                               //     : 'CA\$ ${order!.grandTotal.toStringAsFixed(2)}',
//                               textAlign: TextAlign.center,
//                               style: titleStyle
//                                   .copyWith(
//                                     fontSize: 16,
//                                   )
//                                   .usePoppinsW6Font(),
//                             ),
//                             Text(
//                               '${order!.distance} Km',
//                               textAlign: TextAlign.center,
//                               style: titleStyle
//                                   .copyWith(
//                                     fontSize: 14,
//                                     color: greyB6B6B6,
//                                   )
//                                   .usePoppinsW5Font(),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   largeVerticalSpacing(),
//                   AddressTile(
//                     icon: 'assets/icons/home/ic_pickup.svg',
//                     title: 'Pickup Location',
//                     address: order!.startAddress,
//                   ),
//                   const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 16.0),
//                     child: Divider(
//                       color: grey9c9c9c,
//                     ),
//                   ),
//                   AddressTile(
//                     icon: 'assets/icons/home/ic_drop_pin.svg',
//                     title: 'Drop location',
//                     address: order!.endAddress,
//                   ),
//                   largeVerticalSpacing(),
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: yellowF9EACC,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "${DateFormat.yMMMd().format((DateFormat("yyyy-MM-dd HH:mm:ss").parse(order!.orderTime.toString(), true)).toLocal())} ${DateFormat.jm().format((DateFormat("yyyy-MM-dd HH:mm:ss").parse(order!.orderTime.toString(), true)).toLocal())}",
//                           // '${DateFormat.yMMMd().format(order!.orderTime!)}, ${DateFormat.jm().format(order!.orderTime!)}',
//                           textAlign: TextAlign.center,
//                           style: titleStyle
//                               .copyWith(
//                                 fontSize: 14,
//                               )
//                               .usePoppinsW5Font(),
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                               width: 6,
//                               height: 6,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: getStatusColor(
//                                   order!.status,
//                                 ),
//                               ),
//                             ),
//                             smallHorizontalSpacing(),
//                             Text(
//                               getOrderStatus(order!.status),
//                               textAlign: TextAlign.center,
//                               style: titleStyle
//                                   .copyWith(
//                                     fontSize: 14,
//                                     color: getStatusColor(
//                                       order!.status,
//                                     ),
//                                   )
//                                   .usePoppinsW5Font(),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                   largeVerticalSpacing(),

//                   getOrderStatus(order!.status) != appLoc.cancelled
//                       ? Container(
//                           child: Column(children: [
//                             Container(
//                               padding: const EdgeInsets.all(20),
//                               decoration: BoxDecoration(
//                                 color: whiteAccentColor,
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   // Container(
//                                   //   width: 6,
//                                   //   height: 6,
//                                   //   decoration: BoxDecoration(
//                                   //     shape: BoxShape.circle,
//                                   //     color: getStatusColor(
//                                   //       order!.status,
//                                   //     ),
//                                   //   ),
//                                   // ),

//                                   const Text(
//                                     "Payment Status",
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                   // smallHorizontalSpacing(),
//                                   Text(
//                                     order!.paymentStatus == "no"
//                                         ? "Pending"
//                                         : "Paid",
//                                     textAlign: TextAlign.center,
//                                     style: titleStyle
//                                         .copyWith(
//                                             fontSize: 14,
//                                             color: order!.paymentStatus == "no"
//                                                 ? redf52d56Color
//                                                 : green2DAA5FColor)
//                                         .usePoppinsW5Font(),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             PriceTile(
//                               title: 'Distance',
//                               value: '${order!.distance} KM',
//                             ),
//                             PriceTile(
//                               title: 'Cab Type',
//                               value:
//                                   '${order!.vehicleCategory.category}( ${order!.vehicleCategory.seat} Persons)',
//                             ),
//                             // PriceTile(
//                             //   title: 'Price',
//                             //   value: 'CA\$ ${order!.total}',
//                             // ),
//                             PriceTile(
//                               title: 'Current Ride Payment',
//                               // value: 'CA\$ ${(order!.grandTotal).toStringAsFixed(2)}',
//                               value: 'CA\$ ${(order!.grandTotal)}',
//                             ),
//                             PriceTile(
//                               title: 'Pending Ride Payment',
//                               value: 'CA\$ ${order!.pendingAmount}',
//                             ),
//                             PriceTile(
//                               title: 'Extra Time Taken',
//                               value: ((order!.extraTimeTaken != '') ||
//                                       (order!.extraTimeTaken != null))
//                                   ? '${(int.parse(order!.extraTimeTaken)) / 60} Min'
//                                   : '0 Min',
//                             ),
//                             PriceTile(
//                               title: 'Extra Time Price',
//                               // value: 'CA\$ ${(order!.grandTotal).toStringAsFixed(2)}',
//                               value: 'CA\$ ${(order!.extraTimePrice)}',
//                             ),

//                             PriceTile(
//                               title: 'Extra Distance',
//                               // value: 'CA\$ ${(order!.grandTotal).toStringAsFixed(2)}',
//                               value: '${(order!.extraDistance)} Km',
//                             ),
//                             PriceTile(
//                               title: 'Extra Distance Price',
//                               // value: 'CA\$ ${(order!.grandTotal).toStringAsFixed(2)}',
//                               value: 'CA\$ ${(order!.extraDistancePrice)}',
//                             ),

//                             PriceTile(
//                               title: 'Tip',
//                               value: 'CA\$ ${order!.tip}',
//                             ),
//                             const Padding(
//                               padding: EdgeInsets.only(top: 16.0),
//                               child: Divider(
//                                 color: grey9c9c9c,
//                               ),
//                             ),
//                             PriceTile(
//                               title: 'Total',
//                               value:
//                                   // 'CA\$ ${(double.parse(order!.newTotal)).toStringAsFixed(2)}',
//                                   'CA\$ ${(double.parse(order!.newTotal))}',

//                               // value: order!.tip == '0'
//                               //     ? 'CA\$ ${order!.total.toStringAsFixed(2)}'
//                               //     : 'CA\$ ${order!.grandTotal.toStringAsFixed(2)}',
//                               fontSize: 18,
//                             ),
//                           ]),
//                         )
//                       : const SizedBox()
//                   // PriceTile(
//                   //   title: 'Distance',
//                   //   value: '${order!.distance} KM',
//                   // ),
//                   // PriceTile(
//                   //   title: 'Cab Type',
//                   //   value:
//                   //       '${order!.vehicleCategory.category}( ${order!.vehicleCategory.seat} Persons)',
//                   // ),
//                   // // PriceTile(
//                   // //   title: 'Price',
//                   // //   value: 'CA\$ ${order!.total}',
//                   // // ),
//                   // PriceTile(
//                   //   title: 'Current Ride Payment',
//                   //   // value: 'CA\$ ${(order!.grandTotal).toStringAsFixed(2)}',
//                   //   value: 'CA\$ ${(order!.grandTotal)}',
//                   // ),
//                   // PriceTile(
//                   //   title: 'Pending Ride Payment',
//                   //   value: 'CA\$ ${order!.pendingAmount}',
//                   // ),
//                   // PriceTile(
//                   //   title: 'Tip',
//                   //   value: 'CA\$ ${order!.tip}',
//                   // ),
//                   // const Padding(
//                   //   padding: EdgeInsets.only(top: 16.0),
//                   //   child: Divider(
//                   //     color: grey9c9c9c,
//                   //   ),
//                   // ),
//                   // PriceTile(
//                   //   title: 'Total',
//                   //   value:
//                   //       // 'CA\$ ${(double.parse(order!.newTotal)).toStringAsFixed(2)}',
//                   //       'CA\$ ${(double.parse(order!.newTotal))}',

//                   //   // value: order!.tip == '0'
//                   //   //     ? 'CA\$ ${order!.total.toStringAsFixed(2)}'
//                   //   //     : 'CA\$ ${order!.grandTotal.toStringAsFixed(2)}',
//                   //   fontSize: 18,
//                   // ),
//                   ,
//                   largeVerticalSpacing(),

//                   ...List.generate(
//                     order!.ratingList.length,
//                     (index) {
//                       if (order!.ratingList[index].type == 2) {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'Rating Given',
//                               textAlign: TextAlign.center,
//                               style: titleStyle
//                                   .copyWith(
//                                     fontSize: 16,
//                                     color: grey7D7979,
//                                   )
//                                   .usePoppinsW5Font(),
//                             ),
//                             mediumVerticalSpacing(),
//                             RatingTile(
//                               rating: order!.ratingList[index],
//                             ),
//                           ],
//                         );
//                       } else {
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             largeVerticalSpacing(),
//                             Text(
//                               'Rating Received',
//                               textAlign: TextAlign.center,
//                               style: titleStyle
//                                   .copyWith(
//                                     fontSize: 16,
//                                     color: grey7D7979,
//                                   )
//                                   .usePoppinsW5Font(),
//                             ),
//                             mediumVerticalSpacing(),
//                             RatingTile(
//                               rating: order!.ratingList[index],
//                             ),
//                           ],
//                         );
//                       }
//                     },
//                   ),

//                   // Text(
//                   //   'Rating Given',
//                   //   textAlign: TextAlign.center,
//                   //   style: titleStyle
//                   //       .copyWith(
//                   //         fontSize: 16,
//                   //         color: grey7D7979,
//                   //       )
//                   //       .usePoppinsW5Font(),
//                   // ),
//                   // mediumVerticalSpacing(),
//                   // const RatingTile(),
//                   // largeVerticalSpacing(),
//                   // Text(
//                   //   'Rating Received',
//                   //   textAlign: TextAlign.center,
//                   //   style: titleStyle
//                   //       .copyWith(
//                   //         fontSize: 16,
//                   //         color: grey7D7979,
//                   //       )
//                   //       .usePoppinsW5Font(),
//                   // ),
//                   // mediumVerticalSpacing(),
//                   // const RatingTile(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
