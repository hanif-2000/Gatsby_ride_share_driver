import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/presentation/widgets/cache_network_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/features/receipt/data/model/receipt_model.dart';
import 'package:appkey_taxiapp_driver/features/receipt/persentation/provider/receipt_provider.dart';
import 'package:appkey_taxiapp_driver/features/receipt/persentation/provider/receipt_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

import 'detailed_payment_screen.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({Key? key, this.id}) : super(key: key);
  static const routeName = '/ReceiptPage';
  final String? id;

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (context) => locator<ReceiptProvider>(),
      child: Scaffold(
        body: Consumer<ReceiptProvider>(
          builder: (context, provider, _) {
            return StreamBuilder<ReceiptState>(
              stream: provider.getReceiptAPI(),
              builder: (context, state) {
                print('$state');
                switch (state.data.runtimeType) {
                  case ReceiptLoading:
                    return const Center(child: CircularProgressIndicator());
                  case ReceiptFailure:
                    final failure = (state.data as ReceiptFailure).failure;
                    showToast(message: failure);
                    return const SizedBox.shrink();
                  case ReceiptSuccess:
                    final _data = (state.data as ReceiptSuccess).data;
                    if (_data == null) {
                      return Center(
                        child: Text(
                          appLoc.therearenopastorders,
                          style: formLabelHeaderStyle,
                        ),
                      );
                    }
                    OrderReceipt order = _data.orderReceipt.first;

                    int time = (order.endTime!
                                .difference(order.startTime!)
                                .inMinutes) !=
                            (-330)
                        ? (order.endTime!
                            .difference(order.startTime!)
                            .inMinutes)
                        : 0;

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 60, bottom: 16),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Color.fromRGBO(0, 0, 0, 0.16),
                                  )
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  appLoc.tripDetail,
                                  textAlign: TextAlign.center,
                                  style: titleStyle.copyWith(
                                    fontSize: fontLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Customer details section
                                Row(
                                  children: [
                                    CustomCacheNetworkImage(
                                        img: order.image!, size: 50),
                                    // Container(
                                    //   height: 50,
                                    //   width: 50,
                                    //   decoration: BoxDecoration(
                                    //     shape: BoxShape.circle,
                                    //     color: redD03B3B,
                                    //     image: DecorationImage(
                                    //       image: NetworkImage(
                                    //         '$BASE_URL${order.image}',
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    mediumHorizontalSpacing(),
                                    Column(
                                      children: [
                                        Text(
                                          order.userName,
                                          textAlign: TextAlign.center,
                                          style: titleStyle
                                              .copyWith(
                                                fontSize: 16,
                                              )
                                              .usePoppinsW5Font(),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/home/ic_start.svg'),
                                        smallHorizontalSpacing(),
                                        Text(
                                          order.rating!.toStringAsFixed(1),
                                          textAlign: TextAlign.center,
                                          style: titleStyle
                                              .copyWith(
                                                fontSize: 14,
                                              )
                                              .usePoppinsW6Font(),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                largeVerticalSpacing(),

                                //Fare breakdown section
                                Text(
                                  'Fare Breakdown ',
                                  textAlign: TextAlign.start,
                                  style: titleStyle
                                      .copyWith(
                                        fontSize: 16,
                                      )
                                      .usePoppinsW6Font(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Date',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                              color: grey7c7c7c,
                                            )
                                            .usePoppinsW6Font(),
                                      ),
                                      Text(
                                        DateFormat.yMMMd().format(
                                            (DateFormat("yyyy-MM-dd HH:mm:ss")
                                                    .parse(
                                                        order.orderTime
                                                            .toString(),
                                                        true))
                                                .toLocal()),
                                        // DateFormat.yMMMd()
                                        // .format(order.orderTime),
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                            )
                                            .usePoppinsW5Font(),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Time',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                              color: grey7c7c7c,
                                            )
                                            .usePoppinsW6Font(),
                                      ),
                                      Text(
                                        DateFormat.jm().format(
                                            (DateFormat("yyyy-MM-dd HH:mm:ss")
                                                    .parse(
                                                        order.orderTime
                                                            .toString(),
                                                        true))
                                                .toLocal()),
                                        // DateFormat.jm().format(order.orderTime),
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                            )
                                            .usePoppinsW5Font(),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Distance',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                              color: grey7c7c7c,
                                            )
                                            .usePoppinsW6Font(),
                                      ),
                                      Text(
                                        order.distance + ' Km',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                            )
                                            .usePoppinsW5Font(),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Time taken',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                              color: grey7c7c7c,
                                            )
                                            .usePoppinsW6Font(),
                                      ),
                                      Text(
                                        '${time ?? 0} min',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                            )
                                            .usePoppinsW5Font(),
                                      ),
                                    ],
                                  ),
                                ),
                                largeVerticalSpacing(),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: SizedBox(
                                //     width:
                                //         MediaQuery.of(context).size.width / 2,
                                //     height: 40,
                                //     child: CustomButton(
                                //         isRounded: true,
                                //         text: "Payment Details",
                                //         event: () {
                                //           showModalBottomSheet(
                                //             context: context,
                                //             builder: (context) {
                                //               return PaymentScreen(
                                //                   totalPrice: order.total,
                                //                   extraDistance:
                                //                       order.extraDistance,
                                //                   extraTime: order.extraTime,
                                //                   extraDistancePrice:
                                //                       order.extraDistancePrice,
                                //                   extraMinPrice:
                                //                       order.extraKmPrice,
                                //                   grandTotal: order.total,
                                //                   distance: order.distance);
                                //             },
                                //           );

                                //           // Navigator.push(
                                //           //     context,
                                //           //     MaterialPageRoute(
                                //           //       builder: (context) =>
                                //           //           PaymentScreen(
                                //           //               totalPrice:
                                //           //                   order.grandTotal,
                                //           //               extraDistance:
                                //           //                   order.extraDistance,
                                //           //               extraTime:
                                //           //                   order.extraTime,
                                //           //               extraDistancePrice: order
                                //           //                   .extraDistancePrice,
                                //           //               extraMinPrice:
                                //           //                   order.extraKmPrice,
                                //           //               grandTotal:
                                //           //                   order.grandTotal,
                                //           //               distance: order.distance),
                                //           //     ));
                                //         },
                                //         bgColor: black030303),
                                //   ),
                                // ),

                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Row(
                                    children: [
                                      Text(
                                        'Payment Information',
                                        textAlign: TextAlign.start,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                            )
                                            .usePoppinsW6Font(),
                                      ),

                                      IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return PaymentScreen(
                                                    totalPrice: order.total,
                                                    extraDistance:
                                                        order.extraDistance,
                                                    extraTime: order.extraTime,
                                                    extraDistancePrice: order
                                                        .extraDistancePrice,
                                                    extraMinPrice:
                                                        order.extraKmPrice,
                                                    grandTotal: order.total,
                                                    distance: order.distance);
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons
                                              .arrow_circle_right_outlined))

                                      // SizedBox(
                                      //   width: 100,
                                      //   child: CustomButton(
                                      //       text: "Payment Details",
                                      //       event: () {
                                      //         Navigator.push(
                                      //             context,
                                      //             MaterialPageRoute(
                                      //               builder: (context) =>
                                      //                   PaymentScreen(
                                      //                       totalPrice: order
                                      //                           .grandTotal,
                                      //                       extraDistance: order
                                      //                           .extraDistance,
                                      //                       extraTime: order
                                      //                           .extraTime,
                                      //                       extraDistancePrice:
                                      //                           order
                                      //                               .extraDistancePrice,
                                      //                       extraMinPrice: order
                                      //                           .extraKmPrice,
                                      //                       grandTotal: order
                                      //                           .grandTotal,
                                      //                       distance:
                                      //                           order.distance),
                                      //             ));
                                      //       },
                                      //       bgColor: black030303),
                                      // )
                                    ],
                                  ),
                                ),
                                smallVerticalSpacing(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Payment Through',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 13,
                                              color: grey7D7979,
                                            )
                                            .usePoppinsW6Font(),
                                      ),
                                      Row(
                                        children: [
                                          // SvgPicture.asset(
                                          //     'assets/icons/home/ic_card_master.svg'),
                                          smallHorizontalSpacing(),
                                          Text(
                                            getPaymentType(order.paymentMethod),
                                            textAlign: TextAlign.center,
                                            style: titleStyle
                                                .copyWith(
                                                    fontSize: 16,
                                                    color: grey7D7979)
                                                .usePoppinsW5Font(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                mediumVerticalSpacing(),
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: greyB6B6B6.withOpacity(.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      smallVerticalSpacing(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total Fare',
                                            textAlign: TextAlign.center,
                                            style: titleStyle
                                                .copyWith(
                                                  fontSize: 16,
                                                  color: grey7c7c7c,
                                                )
                                                .usePoppinsW6Font(),
                                          ),
                                          Text(
                                            'CA\$ ${order.total}',
                                            // '\$${order.total - ((order.total * 5) / 100)}',
                                            textAlign: TextAlign.center,
                                            style: titleStyle
                                                .copyWith(
                                                  fontSize: 16,
                                                )
                                                .usePoppinsW5Font(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                mediumVerticalSpacing(),

                                Visibility(
                                  visible: order.tip != 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: greyB6B6B6.withOpacity(.3),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        smallVerticalSpacing(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Tip',
                                              textAlign: TextAlign.center,
                                              style: titleStyle
                                                  .copyWith(
                                                    fontSize: 16,
                                                    color: grey7c7c7c,
                                                  )
                                                  .usePoppinsW6Font(),
                                            ),
                                            Text(
                                              'CA\$ ${order.tip}',
                                              // '\$${order.total - ((order.total * 5) / 100)}',
                                              textAlign: TextAlign.center,
                                              style: titleStyle
                                                  .copyWith(
                                                    fontSize: 16,
                                                  )
                                                  .usePoppinsW5Font(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                largeVerticalSpacing(),
                                CustomButton(
                                  text: Text(
                                    "Continue",
                                    // appLoc.continuee,
                                    style: txtButtonStyle,
                                  ),
                                  event: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32.0))),
                                          elevation: 15.0,
                                          actionsAlignment:
                                              MainAxisAlignment.spaceAround,
                                          title: const Text(
                                              "Please Confirm Payment"),
                                          content: const Text(
                                              "Did you receive the payment from customer?"),
                                          actions: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                // width: _deviceSize.width * 3,
                                                child: CustomButton(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0))),
                                                    text: "Yes",
                                                    event: () async {
                                                      var dio = Dio();

                                                      FormData data =
                                                          FormData.fromMap({
                                                        'payment_status': 'yes',
                                                        'order_id': provider
                                                            .session
                                                            .runningOrderId,
                                                      });
                                                      // var body = {
                                                      //   'payment_status': paymentStatus,
                                                      //   'order_id': session.runningOrderId,
                                                      // };

                                                      log(data.toString());
                                                      log("session token :${provider.session.sessionToken}");

                                                      try {
                                                        var response =
                                                            await dio.request(
                                                          'https://php.parastechnologies.in/taxi/public/api/webservice/driver/payment/confirmation',
                                                          data: data,
                                                          options: Options(
                                                              method: 'POST',
                                                              headers: {
                                                                "Authorization":
                                                                    "Bearer ${provider.session.sessionToken}"
                                                              }),
                                                        );

                                                        log("res is:${response.data}");

                                                        if (response
                                                                .statusCode ==
                                                            200) {
                                                          Navigator
                                                              .pushNamedAndRemoveUntil(
                                                                  context,
                                                                  HomePage
                                                                      .routeName,
                                                                  (route) =>
                                                                      false);
                                                        } else {
                                                          dismissLoading();

                                                          showToast(
                                                              message:
                                                                  "Something went wrong ,Please try again");
                                                        }
                                                      } catch (e) {
                                                        dismissLoading();

                                                        showToast(
                                                            message:
                                                                e.toString());

                                                        log(e.toString());
                                                      }

                                                      // provider
                                                      //     .paymentConfirmation(
                                                      //         paymentStatus:
                                                      //             'yes',
                                                      //         context: context);

                                                      // Navigator
                                                      //     .pushNamedAndRemoveUntil(
                                                      //         context,
                                                      //         HomePage
                                                      //             .routeName,
                                                      //         (route) => false);
                                                    },
                                                    bgColor: black030303),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                // width: _deviceSize.width * 3,
                                                child: CustomButton(
                                                    shape: const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0))),
                                                    text: "No",
                                                    event: () async {
                                                      var dio = Dio();

                                                      FormData data =
                                                          FormData.fromMap({
                                                        'payment_status': 'no',
                                                        'order_id': provider
                                                            .session
                                                            .runningOrderId,
                                                      });

                                                      log("id: ${provider.session.runningOrderId}");
                                                      // var body = {
                                                      //   'payment_status': paymentStatus,
                                                      //   'order_id': session.runningOrderId,
                                                      // };

                                                      log(data.toString());
                                                      log("session token :${provider.session.sessionToken}");

                                                      try {
                                                        var response =
                                                            await dio.post(
                                                          'https://php.parastechnologies.in/taxi/public/api/webservice/driver/payment/confirmation',
                                                          data: data,
                                                          options: Options(
                                                              // method: 'POST',
                                                              headers: {
                                                                "Authorization":
                                                                    "Bearer ${provider.session.sessionToken}"
                                                              }),
                                                        );

                                                        log("res is:${response.data}");

                                                        if (response
                                                                .statusCode ==
                                                            200) {
                                                          Navigator
                                                              .pushNamedAndRemoveUntil(
                                                                  context,
                                                                  HomePage
                                                                      .routeName,
                                                                  (route) =>
                                                                      false);
                                                        } else {
                                                          dismissLoading();

                                                          showToast(
                                                              message:
                                                                  "Something went wrong ,Please try again");
                                                        }
                                                      } catch (e) {
                                                        dismissLoading();

                                                        showToast(
                                                            message:
                                                                e.toString());

                                                        log(e.toString());
                                                      }

                                                      // provider
                                                      //     .paymentConfirmation(
                                                      //         paymentStatus:
                                                      //             'no',
                                                      //         context: context);
                                                      Navigator
                                                          .pushNamedAndRemoveUntil(
                                                              context,
                                                              HomePage
                                                                  .routeName,
                                                              (route) => false);
                                                    },
                                                    bgColor: redD03B3B),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    // Navigator.pushNamedAndRemoveUntil(context,
                                    //     HomePage.routeName, (route) => false);
                                  },
                                  buttonHeight: 48,
                                  isRounded: true,
                                  bgColor: blackColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
