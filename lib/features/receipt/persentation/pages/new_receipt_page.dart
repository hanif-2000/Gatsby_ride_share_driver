import 'dart:developer';
import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/cache_network_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_driver/core/utility/convert_decimal_helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/duration_helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/static/dimens.dart';
import '../../../../../../core/static/styles.dart';
import '../../../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';
import '../../../order/presentation/pages/new_order_page.dart';
import '../../../rating/presentation/page/give_rating_screen.dart';
import 'new_detailed_payment_screen.dart';

class ReceiptPage extends StatelessWidget {
  ReceiptPage(
      {Key? key,
      this.id,
      // required this.customerDataModel,
      required this.customerId})
      : super(key: key);
  static const routeName = '/ReceiptPage';
  final String? id;
  // final CustomerDataModel customerDataModel;
  final int customerId;
  String actualTimeTaken = "0 Min";
  var socketProvider = Provider.of<LatestSocketProvider>(
      locator<GlobalKey<NavigatorState>>().currentContext!);

  @override
  Widget build(BuildContext context) {
    var session = locator<Session>();

    // String actualTime =
    // formatDuration(int.parse(socketProvider.receiptData!.actualTime));
    // var _deviceSize = MediaQuery.of(context).size;
    // return
    //  ChangeNotifierProvider(
    //   create: (context) => locator<ReceiptProvider>(),
    return Scaffold(
      body: Consumer<LatestSocketProvider>(
        builder: (context, provider, _) {
          // if (provider.receiptData != null) {
          //   convertSecondsToMinutes(time: 100).then((value) {
          //     setState() {
          //       actualTimeTaken = value;
          //     }
          //   });
          // }
          //         return StreamBuilder<ReceiptState>(
          //           stream: provider.getReceiptAPI(),
          //           builder: (context, state) {
          //             print('$state');
          //             switch (state.data.runtimeType) {
          //               case ReceiptLoading:
          //                 return const Center(child: CircularProgressIndicator());
          //               case ReceiptFailure:
          //                 final failure = (state.data as ReceiptFailure).failure;
          //                 showToast(message: failure);
          //                 return const SizedBox.shrink();
          //               case ReceiptSuccess:
          //                 final data0 = (state.data as ReceiptSuccess).data;
          //                 if (data0 == null) {
          //                   return Center(
          //                     child: Text(
          //                       appLoc.therearenopastorders,
          //                       style: formLabelHeaderStyle,
          //                     ),
          //                   );
          //                 }

          //                 session.setCurrentOrderState = 100;
          //                 session.setIsOrderRunning = false;
          //                 OrderReceipt order = data0.orderReceipt.first;

          //                 int time = (order.endTime!
          //                             .difference(order.startTime!)
          //                             .inMinutes) !=
          //                         (-330)
          //                     ? (order.endTime!
          //                         .difference(order.startTime!)
          //                         .inMinutes)
          //                     : 0;!

          return provider.receiptData != null
              ? SingleChildScrollView(
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
                                    img: provider.receiptData!.image ?? '',
                                    size: 50),
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
                                      provider.receiptData!.name! ?? '',
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

                                /**rating */
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/icons/home/ic_start.svg'),
                                    smallHorizontalSpacing(),
                                    Text(
                                      convertToTwoDecimal(provider
                                          .receiptData!.customerRating
                                          .toString()),
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
                              padding: const EdgeInsets.symmetric(vertical: 15),
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

                                  /**date  */
                                  Text(
                                    DateFormat.yMMMd().format(
                                        (DateFormat("yyyy-MM-dd HH:mm:ss")
                                                .parse(
                                                    provider
                                                        .receiptData!.createdAt
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
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
                                    DateFormat.jm().format((DateFormat(
                                                "yyyy-MM-dd HH:mm:ss")
                                            .parse(
                                                provider.receiptData!.createdAt
                                                        .toString() ??
                                                    DateTime.now().toString(),
                                                true))
                                        .toLocal()),

                                    // DateFormat.jm().format(
                                    //     (DateFormat("yyyy-MM-dd HH:mm:ss")
                                    //             .parse(
                                    //                 provider
                                    //                     .receiptData!.orderTime
                                    //                     .toString(),
                                    //                 true))
                                    //         .toLocal()),
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
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
                                    '${double.parse(provider.receiptData!.distance1??"0").toStringAsFixed(2)} Km',
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
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Time Taken',
                                    textAlign: TextAlign.center,
                                    style: titleStyle
                                        .copyWith(
                                          fontSize: 16,
                                          color: grey7c7c7c,
                                        )
                                        .usePoppinsW6Font(),
                                  ),
                                  Text(
                                    // actualTime,
                                    formatDuration(double.parse(
                                            provider.receiptData!.actualTime)
                                        .toInt()),
                                    // "${provider.receiptData!.actualTime} Min",
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
                                        _showPaymentInfo(
                                          context: context,
                                          child: PaymentScreen(
                                            actualDistance:
                                                provider.receiptData!.distance1,
                                            totalTime: provider.receiptData!.actualTime.toString() == "0.0" ? "0"
                                                : provider
                                                    .receiptData!.actualTime,
                                            minimumFare:provider.receiptData!.minPrice !=""? provider.receiptData!.minPrice:"0.0",
                                            baseFare:
                                                provider.receiptData!.baseFare,
                                            techFee: provider.receiptData!.techFee,
                                            newTotal: provider.receiptData!.newTotal !=
                                                    ""
                                                ? convertToTwoDecimal(provider
                                                    .receiptData!.newTotal
                                                    .toString())
                                                : convertToTwoDecimal(provider
                                                    .receiptData!.newTotal
                                                    .toString()),
                                            pendingAmount: provider.receiptData!
                                                        .pendingAmount ==
                                                    ''
                                                ? '0'
                                                : provider
                                                    .receiptData!.pendingAmount,
                                            totalPrice:
                                                provider.receiptData!.newTotal,
                                            extraDistance: provider.receiptData!
                                                        .extraDistance ==
                                                    ''
                                                ? '0'
                                                : provider
                                                    .receiptData!.extraDistance,
                                            extraTime: provider
                                                        .receiptData!.extraTime
                                                        .toString() ==
                                                    ''
                                                ? '0'
                                                : provider
                                                    .receiptData!.extraTime
                                                    .toString(),
                                            extraDistancePrice: provider
                                                        .receiptData!
                                                        .extraDistancePrice ==
                                                    ""
                                                ? "0"
                                                : provider.receiptData!
                                                    .extraDistancePrice,
                                            extraTimePrice: provider
                                                        .receiptData!
                                                        .extraTimePrice ==
                                                    ''
                                                ? "0"
                                                : provider.receiptData!
                                                    .extraTimePrice,
                                            grandTotal:
                                                provider.receiptData!.newTotal,
                                            distance: provider
                                                .receiptData!.distance
                                                .toString(),
                                          ),
                                        );
                                        /*    showModalBottomSheet(
                                          context: context,
                                          enableDrag: true,

                                          builder: (context) {
                                            return PaymentScreen(
                                                newTotal: provider
                                                    .receiptData!.newTotal
                                                    .toString(),
                                                pendingAmount:
                                                    provider.receiptData!.pendingAmount == ''
                                                        ? '0'
                                                        : provider.receiptData!
                                                            .pendingAmount,
                                                totalPrice:
                                                    provider.receiptData!.total,
                                                extraDistance:
                                                    provider.receiptData!.extraDistance == ''
                                                        ? '0'
                                                        : provider.receiptData!
                                                            .extraDistance,
                                                extraTime: provider.receiptData!.extraTime == ''
                                                    ? '0'
                                                    : provider
                                                        .receiptData!.extraTime,
                                                extraDistancePrice:
                                                    provider.receiptData!.extraDistancePrice == ""
                                                        ? "0"
                                                        : provider.receiptData!
                                                            .extraDistancePrice,
                                                extraTimePrice:
                                                    provider.receiptData!.extraTimePrice == ''
                                                        ? "0"
                                                        : provider.receiptData!
                                                            .extraTimePrice,
                                                grandTotal: provider.receiptData!.newTotal.toString(),
                                                distance: provider.receiptData!.distance.toString());
                                          },
                                        );*/
                                      },
                                      icon: const Icon(
                                          Icons.arrow_circle_right_outlined))

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
                              padding: const EdgeInsets.symmetric(vertical: 15),
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
                                        getPaymentType(int.parse(provider
                                            .receiptData!.paymentMethod)),
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                                fontSize: 16, color: grey7D7979)
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
                                        provider.receiptData!.newTotal != ""
                                            ? "CA\$ ${convertToTwoDecimal(provider.receiptData!.newTotal.toString())}"
                                            : "CA\$ ${convertToTwoDecimal(provider.receiptData!.total)}"
                                        // 'CA\$ ${order.total}',
                                        // 'CA\$ ${provider.receiptData!.newTotal.toString()}'
                                        // : 'CA\$ ${provider.receiptData!.total.toString()}',

                                        // '\$${order.total - ((order.total * 5) / 100)}',
                                        ,
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

                            // Visibility(
                            //   visible: provider.receiptData!.tip != 0,
                            //   child: Container(
                            //     padding: const EdgeInsets.all(14),
                            //     decoration: BoxDecoration(
                            //       color: greyB6B6B6.withOpacity(.3),
                            //       borderRadius: BorderRadius.circular(10),
                            //     ),
                            //     child: Column(
                            //       children: [
                            //         smallVerticalSpacing(),
                            //         Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             Text(
                            //               'Tip',
                            //               textAlign: TextAlign.center,
                            //               style: titleStyle
                            //                   .copyWith(
                            //                     fontSize: 16,
                            //                     color: grey7c7c7c,
                            //                   )
                            //                   .usePoppinsW6Font(),
                            //             ),
                            //             Text(
                            //               'CA\$ ${provider.receiptData!.tip}',
                            //               // '\$${order.total - ((order.total * 5) / 100)}',
                            //               textAlign: TextAlign.center,
                            //               style: titleStyle
                            //                   .copyWith(
                            //                     fontSize: 16,
                            //                   )
                            //                   .usePoppinsW5Font(),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),

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
                                      title:
                                          const Text("Please Confirm Payment"),
                                      content: const Text(
                                          "Did you receive the payment from customer?"),
                                      actions: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            // width: _deviceSize.width * 3,
                                            child: CustomButton(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0))),
                                                text: "Yes",
                                                event: () async {
                                                  Navigator.pop(context);
                                                  showLoading();
                                                  var dio = Dio();

                                                  FormData data =
                                                      FormData.fromMap({
                                                    'payment_status': 'yes',
                                                    'order_id': provider
                                                        .session.runningOrderId,
                                                  });
                                                  // var body = {
                                                  //   'payment_status': paymentStatus,
                                                  //   'order_id': session.runningOrderId,
                                                  // };

                                                  log(data.fields.toString());
                                                  log("session token :${provider.session.sessionToken}");

                                                  try {
                                                    var response =
                                                        await dio.request(
                                                      '${BASE_URL}api/webservice/driver/payment/confirmation',
                                                      data: data,
                                                      options: Options(
                                                          method: 'POST',
                                                          headers: {
                                                            "Authorization":
                                                                "Bearer ${provider.session.sessionToken}"
                                                          }),
                                                    );

                                                    log("res is:${response.data}");

                                                    if (response.statusCode ==
                                                        200) {
                                                      dismissLoading();

                                                      session.setIsPaymentDone =
                                                          true;

                                                      // if (!context.mounted) {
                                                      Navigator
                                                          .pushNamedAndRemoveUntil(
                                                        locator<
                                                                GlobalKey<
                                                                    NavigatorState>>()
                                                            .currentContext!,
                                                        GiveRatingScreen
                                                            .routeName,
                                                        (route) => false,
                                                        arguments:
                                                            RatingPageArguments(
                                                          customerDataModel:
                                                              provider
                                                                  .customerDetail!,
                                                          customerId: provider
                                                              .customerDetail!
                                                              .id,
                                                        ),
                                                      );
                                                      // } else {
                                                      //   return;
                                                      // }

                                                      // Navigator
                                                      // .pushNamedAndRemoveUntil(
                                                      //     context,
                                                      //     HomePage
                                                      //         .routeName,
                                                      //     (route) =>
                                                      //         false);
                                                    } else {
                                                      dismissLoading();

                                                      showToast(
                                                          message:
                                                              "Something went wrong ,Please try again");
                                                    }
                                                  } catch (e) {
                                                    dismissLoading();

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
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                            // width: _deviceSize.width * 3,
                                            child: CustomButton(
                                                shape:
                                                    const RoundedRectangleBorder(
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
                                                        .session.runningOrderId,
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
                                                      '${BASE_URL}api/webservice/driver/payment/confirmation',
                                                      data: data,
                                                      options: Options(
                                                          // method: 'POST',
                                                          headers: {
                                                            "Authorization":
                                                                "Bearer ${provider.session.sessionToken}"
                                                          }),
                                                    );

                                                    log("res is:${response.data}");

                                                    if (response.statusCode ==
                                                        200) {
                                                      session.setIsPaymentDone =
                                                          true;

                                                      Navigator
                                                          .pushNamedAndRemoveUntil(
                                                        locator<
                                                                GlobalKey<
                                                                    NavigatorState>>()
                                                            .currentContext!,
                                                        GiveRatingScreen
                                                            .routeName,
                                                        (route) => false,
                                                        arguments:
                                                            RatingPageArguments(
                                                          customerDataModel:
                                                              provider
                                                                  .customerDetail!,
                                                          customerId: provider
                                                              .customerDetail!
                                                              .id,
                                                        ),
                                                      );
                                                      // Navigators
                                                      //     .pushNamedAndRemoveUntil(
                                                      //   context,
                                                      //   GiveRatingScreen
                                                      //       .routeName,
                                                      //   (route) => false,
                                                      //   arguments:
                                                      //       RatingPageArguments(
                                                      //     customerDataModel:
                                                      //         customerDataModel,
                                                      //     customerId:
                                                      //         customerId,
                                                      //   ),
                                                      // );
                                                      // Navigator
                                                      //     .pushNamedAndRemoveUntil(
                                                      //         context,
                                                      //         HomePage
                                                      //             .routeName,
                                                      //         (route) =>
                                                      //             false);
                                                    } else {
                                                      dismissLoading();

                                                      showToast(
                                                          message:
                                                              "Something went wrong ,Please try again");
                                                    }
                                                  } catch (e) {
                                                    dismissLoading();

                                                    showToast(
                                                        message: e.toString());

                                                    log(e.toString());
                                                  }

                                                  // Navigator
                                                  //     .pushNamedAndRemoveUntil(
                                                  //   context,
                                                  //   GiveRatingScreen
                                                  //       .routeName,
                                                  //   (route) => false,
                                                  //   arguments:
                                                  //       RatingPageArguments(
                                                  //     customerDataModel:
                                                  //         customerDataModel,
                                                  //     customerId:
                                                  //         customerId,
                                                  //   ),
                                                  // );

                                                  // provider
                                                  //     .paymentConfirmation(
                                                  //         paymentStatus:
                                                  //             'no',
                                                  //         context: context);
                                                  // Navigator
                                                  //     .pushNamedAndRemoveUntil(
                                                  //         context,
                                                  //         HomePage
                                                  //             .routeName,
                                                  //         (route) => false);
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
                )
              : const Center(child: CircularProgressIndicator());

          // }
          // return const SizedBox.shrink();
          // },
          // );
          // },
          // ),
          // ),
          // );
        },
      ),
    );
  }

  void _showPaymentInfo(
      {required BuildContext context, required Widget child}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => SingleChildScrollView(
              child: Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: Wrap(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        /*  IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_rounded)),*/
                          const SizedBox(height: 20,width: 20,),
                          Container(
                            width: 50,
                            height: 4,
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                            width: 20,
                          )
                        ],
                      ),
                      child,
                    ],
                  ),
                ),
              ),
            ));
    // context: context,
    // isScrollControlled: true,
    // useSafeArea: false,
    // builder: (BuildContext context) {
    //   return Column(
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           IconButton(
    //               onPressed: () {
    //                 Navigator.pop(context);
    //               },
    //               icon: const Icon(Icons.arrow_back_rounded)),
    //           Container(
    //             width: 50,
    //             height: 4,
    //             margin: const EdgeInsets.symmetric(vertical: 10),
    //             decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(20),
    //               color: Colors.grey,
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 10,
    //             width: 20,
    //           )
    //         ],
    //       ),
    //       Expanded(
    //         child: SingleChildScrollView(child: child),
    //       ),
    //     ],
    //   );

    // DraggableScrollableSheet(
    //   // maxChildSize: 0.9,
    //   expand: false,
    //   builder: (context, scrollController) {
    //     return

    // },
    // );
    // },
    // );
  }
}
