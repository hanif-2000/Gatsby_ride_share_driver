import 'package:appkey_taxiapp_driver/core/data/models/request_list_model.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/common_dialog.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/order_status.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/pages/order_page.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/update_status_order_state.dart';
import 'package:appkey_taxiapp_driver/features/order_detail/presentation/widget/user_profile_tile.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/customer_detail_state.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/order_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class RequestDetailPage extends StatelessWidget {
  const RequestDetailPage({Key? key, this.requestListModel}) : super(key: key);
  final RequestListModel? requestListModel;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          // appBar: const CustomAppBar(
          //   centerTitle: false,
          // ),
          body: Stack(
            children: <Widget>[
              GoogleMap(
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                initialCameraPosition: homeProvider.kJapanCoordinate,
                onMapCreated: (GoogleMapController controller) async {
                  homeProvider.googleMapController = controller;
                },
                polylines: homeProvider.polylines,
                markers: Set<Marker>.of(homeProvider.markers.values),
              ),
              SafeArea(
                child: Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                            horizontal: 8,
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              // height: 60,
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 13,
                                ),
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.my_location,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'PICK UP',
                                              softWrap: false,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: greyC8C7CC,
                                              ),
                                            ),
                                            Text(
                                              requestListModel!.startAddress,
                                              softWrap: false,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  // color: const Color.fromRGBO(0, 0, 0, 0.2),
                                  color: whiteColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // provider.orderDetail != null
                                    //     ? Padding(
                                    //         padding: const EdgeInsets.symmetric(
                                    //           vertical: 8.0,
                                    //           horizontal: 8.0,
                                    //         ),
                                    //         child: Card(
                                    //           child: Padding(
                                    //             padding: const EdgeInsets.symmetric(
                                    //               vertical: 8.0,
                                    //               horizontal: 20.0,
                                    //             ),
                                    //             child: SizedBox(
                                    //               height: 50,
                                    //               child: Row(
                                    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    //                 children: <Widget>[
                                    //                   Expanded(
                                    //                     flex: 5,
                                    //                     child: Row(
                                    //                       children: [
                                    //                         Expanded(
                                    //                           child: AutoSizeText(
                                    //                             appLoc.distance,
                                    //                             style: const TextStyle(
                                    //                               fontWeight: FontWeight.normal,
                                    //                             ),
                                    //                             minFontSize: 15,
                                    //                             maxFontSize: 18,
                                    //                             maxLines: 1,
                                    //                             overflow: TextOverflow.ellipsis,
                                    //                           ),
                                    //                         ),
                                    //                         Expanded(
                                    //                           child: AutoSizeText(
                                    //                             mergeDistanceTxt(
                                    //                                 provider.orderDetail!.distance),
                                    //                             style: const TextStyle(
                                    //                               fontWeight: FontWeight.bold,
                                    //                               color: primaryColor,
                                    //                             ),
                                    //                             minFontSize: 16,
                                    //                             maxFontSize: 20,
                                    //                             maxLines: 1,
                                    //                             overflow: TextOverflow.ellipsis,
                                    //                           ),
                                    //                         )
                                    //                       ],
                                    //                     ),
                                    //                   ),
                                    //                   Padding(
                                    //                     padding:
                                    //                         const EdgeInsets.symmetric(horizontal: 5),
                                    //                     child: SizedBox(
                                    //                       width: 1,
                                    //                       child: Container(
                                    //                         color: Colors.grey[350],
                                    //                       ),
                                    //                     ),
                                    //                   ),
                                    //                   const SizedBox(
                                    //                     width: 8,
                                    //                   ),
                                    //                   Expanded(
                                    //                     flex: 5,
                                    //                     child: Container(
                                    //                       child: Align(
                                    //                         alignment: Alignment.centerLeft,
                                    //                         child: Row(
                                    //                           children: [
                                    //                             Expanded(
                                    //                               child: AutoSizeText(
                                    //                                 appLoc.price,
                                    //                                 style: const TextStyle(
                                    //                                   fontWeight: FontWeight.normal,
                                    //                                 ),
                                    //                                 minFontSize: 15,
                                    //                                 maxFontSize: 18,
                                    //                                 maxLines: 1,
                                    //                                 overflow: TextOverflow.ellipsis,
                                    //                               ),
                                    //                             ),
                                    //                             Expanded(
                                    //                               child: AutoSizeText(
                                    //                                 mergePriceTxt(provider
                                    //                                     .orderDetail!.totalPrice
                                    //                                     .toString()),
                                    //                                 style: const TextStyle(
                                    //                                   fontWeight: FontWeight.bold,
                                    //                                   color: primaryColor,
                                    //                                 ),
                                    //                                 minFontSize: 16,
                                    //                                 maxFontSize: 20,
                                    //                                 maxLines: 1,
                                    //                                 overflow: TextOverflow.ellipsis,
                                    //                               ),
                                    //                             )
                                    //                           ],
                                    //                         ),
                                    //                       ),
                                    //                     ),
                                    //                   )
                                    //                 ],
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       )
                                    //     : const SizedBox(),
                                    const UserProfileTile(),
                                    mediumVerticalSpacing(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            image:
                                                'assets/icons/order/ic_call.svg',
                                            text: Text(
                                              'Reject',
                                              style: txtButtonStyle,
                                            ),
                                            event: () {
                                              ///Reject the request
                                            },
                                            buttonHeight: 48,
                                            isRounded: true,
                                            bgColor: redD03B3B,
                                          ),
                                        ),
                                        smallHorizontalSpacing(),
                                        Expanded(
                                          child: CustomButton(
                                            text: Text(
                                              'Accept',
                                              style: txtButtonStyle,
                                            ),
                                            event: () {
                                              final session =
                                                  locator<Session>();
                                              homeProvider
                                                  .fetchOrderDetail(
                                                      requestListModel!.id
                                                          .toString())
                                                  .listen(
                                                (event1) {
                                                  if (event1
                                                      is OrderDetailLoaded) {
                                                    // var _deviceSize = MediaQuery.of(context).size;
                                                    session.setRunningOrderId =
                                                        requestListModel!.id;
                                                    session.setOrderId =
                                                        requestListModel!.id
                                                            .toString();
                                                    homeProvider
                                                        .fetchCustomerDetail(
                                                            event1.data.userId
                                                                .toString())
                                                        .listen(
                                                      (event) async {
                                                        if (event
                                                            is CustomerDetailLoaded) {
                                                          session.setOrderUserId =
                                                              event1
                                                                  .data.userId;
                                                          print(
                                                              'RUNNING order id --> ${requestListModel!.id}');
                                                          homeProvider
                                                              .submitStatusOrder(
                                                                  Order
                                                                      .driverAccept)
                                                              .listen(
                                                            (event) async {
                                                              if (event
                                                                  is UpdateStatusOrderLoaded) {
                                                                if (event.data
                                                                        .success ==
                                                                    1) {
                                                                  // var session =
                                                                  //     locator<Session>();
                                                                  session.setIsOrderRunning =
                                                                      true;
                                                                  Navigator
                                                                      .pushNamedAndRemoveUntil(
                                                                    context,
                                                                    OrderPage
                                                                        .routeName,
                                                                    (route) =>
                                                                        false,
                                                                    arguments:
                                                                        OrderPageArguments(
                                                                      orderDetail:
                                                                          homeProvider
                                                                              .orderDetail!,
                                                                      customerDetailModel:
                                                                          homeProvider
                                                                              .customerDetailModel!,
                                                                    ),
                                                                  );
                                                                } else if (event
                                                                        .data
                                                                        .message ==
                                                                    5) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            CommonDialog(
                                                                      title: appLoc
                                                                          .sorry,
                                                                      msg: appLoc
                                                                          .orderacceptedotherdriver,
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  );
                                                                } else if (event
                                                                        .data
                                                                        .message ==
                                                                    6) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            CommonDialog(
                                                                      title: appLoc
                                                                          .sorry,
                                                                      msg: appLoc
                                                                          .ordernotfound,
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  );
                                                                } else if (event
                                                                        .data
                                                                        .message ==
                                                                    7) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            CommonDialog(
                                                                      title: appLoc
                                                                          .sorry,
                                                                      msg: appLoc
                                                                          .orderhascancelled,
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  );
                                                                }
                                                              }
                                                            },
                                                          );

                                                          // await showDialog(
                                                          //   barrierDismissible: false,
                                                          //   context: context,
                                                          //   builder: (_) => WillPopScope(
                                                          //     onWillPop: () async => false,
                                                          //     child: MainDialog(
                                                          //       customerDetailModel: homeProvider.customerDetailModel,
                                                          //       orderDetail: homeProvider.orderDetail,
                                                          //       deviceSize: _deviceSize,
                                                          //       onDecline: () async {
                                                          //         await showDialog(
                                                          //           barrierDismissible: false,
                                                          //           context: context,
                                                          //           builder: (_) => WillPopScope(
                                                          //             onWillPop: () async => false,
                                                          //             child: CustomDeclineDialog(
                                                          //               positiveAction: () {
                                                          //                 homeProvider.changeStatus = false;
                                                          //                 homeProvider.updateStatus().listen(
                                                          //                       (event) async {
                                                          //                     if (event is ChangeStatusLoaded) {
                                                          //                       Navigator.pop(context);
                                                          //                       Navigator.pop(context);
                                                          //                     }
                                                          //                   },
                                                          //                 );
                                                          //               },
                                                          //             ),
                                                          //           ),
                                                          //         );
                                                          //       },
                                                          //       onAccept: () {
                                                          //         session.setOrderId = _data[index].id.toString();
                                                          //         homeProvider
                                                          //             .submitStatusOrder(Order.driverAccept)
                                                          //             .listen(
                                                          //               (event) async {
                                                          //             if (event is UpdateStatusOrderLoaded) {
                                                          //               if (event.data.success == 1) {
                                                          //                 Navigator.pushNamedAndRemoveUntil(
                                                          //                   context,
                                                          //                   OrderPage.routeName,
                                                          //                       (route) => false,
                                                          //                   arguments: OrderPageArguments(
                                                          //                     orderDetail: homeProvider.orderDetail!,
                                                          //                     customerDetailModel:
                                                          //                     homeProvider.customerDetailModel!,
                                                          //                   ),
                                                          //                 );
                                                          //               } else if (event.data.message == 5) {
                                                          //                 Navigator.of(context).pop();
                                                          //                 showDialog(
                                                          //                   context: context,
                                                          //                   builder: (context) => CommonDialog(
                                                          //                     title: appLoc.sorry,
                                                          //                     msg: appLoc.orderacceptedotherdriver,
                                                          //                     onTap: () {
                                                          //                       Navigator.of(context).pop();
                                                          //                     },
                                                          //                   ),
                                                          //                 );
                                                          //               } else if (event.data.message == 6) {
                                                          //                 Navigator.of(context).pop();
                                                          //                 showDialog(
                                                          //                   context: context,
                                                          //                   builder: (context) => CommonDialog(
                                                          //                     title: appLoc.sorry,
                                                          //                     msg: appLoc.ordernotfound,
                                                          //                     onTap: () {
                                                          //                       Navigator.of(context).pop();
                                                          //                     },
                                                          //                   ),
                                                          //                 );
                                                          //               } else if (event.data.message == 7) {
                                                          //                 Navigator.of(context).pop();
                                                          //                 showDialog(
                                                          //                   context: context,
                                                          //                   builder: (context) => CommonDialog(
                                                          //                     title: appLoc.sorry,
                                                          //                     msg: appLoc.orderhascancelled,
                                                          //                     onTap: () {
                                                          //                       Navigator.of(context).pop();
                                                          //                     },
                                                          //                   ),
                                                          //                 );
                                                          //               }
                                                          //             }
                                                          //           },
                                                          //         );
                                                          //       },
                                                          //     ),
                                                          //   ),
                                                          // );
                                                        }
                                                      },
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                            buttonHeight: 48,
                                            isRounded: true,
                                            bgColor: green2DAA5F,
                                          ),
                                        ),
                                      ],
                                    ),
                                    mediumVerticalSpacing(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
