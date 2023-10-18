import 'dart:async';
import 'dart:developer';
import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/reject_request_state.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/request_list_state.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/no_projects.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/reject_reason_bottom_sheet.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/request_tile.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/show_bottom_sheet.dart';
import 'package:appkey_taxiapp_driver/core/static/order_status.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/order/presentation/pages/order_page.dart';
import '../../../features/order/presentation/providers/update_status_order_state.dart';
import '../../../features/profile/presentation/providers/customer_detail_state.dart';
import '../../../features/profile/presentation/providers/order_detail_state.dart';
import '../../utility/session_helper.dart';
import '../widgets/common_dialog.dart';

class RequestListWidget extends StatefulWidget {
  const RequestListWidget({Key? key}) : super(key: key);

  @override
  State<RequestListWidget> createState() => _RequestListWidgetState();
}

class _RequestListWidgetState extends State<RequestListWidget> {
  Timer? timer;

  // StreamController<List<RequestListState>> controller =
  // StreamController << CurrencyModel > [];

  @override
  void initState() {
    super.initState();

    //   timer = Timer.periodic(
    //       const Duration(seconds: 10),
    //       (Timer t) => Provider.of<HomeProvider>(context, listen: false)
    //           .getRequestListData());
    // }

    // Stream<RequestListState> getRequestListStream() {
    //   return Provider.of<HomeProvider>(context, listen: false)
    //       .getRequestListData();
  }

  @override
  void dispose() {
    // timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("request list build widget called");
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        return StreamBuilder<RequestListState>(
          stream: context.read<HomeProvider>().getRequestListData(),
          builder: (context, state) {
            log("this called again and again");
            switch (state.data.runtimeType) {
              case RequestListLoading:
                return const Center(child: CircularProgressIndicator());
              case RequestListFailure:
                final failure = (state.data as RequestListFailure).failure;
                showToast(message: failure.message);
                return const SizedBox.shrink();
              case RequestListLoaded:
                final data = (state.data as RequestListLoaded).data;
                final _data = data.isEmpty ? [] : data.reversed.toList();
                var session = locator<Session>();
                return !session.isOnline
                    ? Center(child: NoProjects(isOffline: !session.isOnline))
                    : _data.isEmpty
                        ? const Center(child: NoProjects())
                        : Column(
                            children: List.generate(
                              _data.length,
                              (index) => RequestTile(
                                request: _data[index],
                                onAccept: () {
                                  final session = locator<Session>();
                                  homeProvider
                                      .fetchOrderDetail(
                                          _data[index].id.toString())
                                      .listen(
                                    (event1) {
                                      if (event1 is OrderDetailLoaded) {
                                        // var _deviceSize = MediaQuery.of(context).size;
                                        session.setRunningOrderId =
                                            _data[index].id;
                                        session.setOrderId =
                                            _data[index].id.toString();
                                        homeProvider
                                            .fetchCustomerDetail(
                                                event1.data.userId.toString())
                                            .listen(
                                          (event) async {
                                            if (event is CustomerDetailLoaded) {
                                              session.setOrderUserId =
                                                  event1.data.userId;
                                              print(
                                                  'RUNNING order id --> ${_data[index].id}');
                                              homeProvider
                                                  .submitStatusOrder(
                                                      Order.driverAccept)
                                                  .listen(
                                                (event) async {
                                                  if (event
                                                      is UpdateStatusOrderLoaded) {
                                                    if (event.data.success ==
                                                        1) {
                                                      // var session =
                                                      //     locator<Session>();
                                                      session.setIsOrderRunning =
                                                          true;
                                                      var socketProvider =
                                                          locator<
                                                              SocketProvider>();
                                                      socketProvider
                                                          .acceptRequestSocket();
                                                      Navigator
                                                          .pushNamedAndRemoveUntil(
                                                        context,
                                                        OrderPage.routeName,
                                                        (route) => false,
                                                        arguments:
                                                            OrderPageArguments(
                                                          orderDetail:
                                                              homeProvider
                                                                  .orderDetail!,
                                                          customerDetailModel:
                                                              homeProvider
                                                                  .customerDetailModel!,
                                                          orderStatus: event1
                                                              .data.orderStatus,
                                                        ),
                                                      );
                                                    } else if (event
                                                            .data.message ==
                                                        5) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            CommonDialog(
                                                          title: appLoc.sorry,
                                                          msg: appLoc
                                                              .orderacceptedotherdriver,
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      );
                                                    } else if (event
                                                            .data.message ==
                                                        6) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            CommonDialog(
                                                          title: appLoc.sorry,
                                                          msg: appLoc
                                                              .ordernotfound,
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      );
                                                    } else if (event
                                                            .data.message ==
                                                        7) {
                                                      Navigator.of(context)
                                                          .pop();
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            CommonDialog(
                                                          title: appLoc.sorry,
                                                          msg: appLoc
                                                              .orderhascancelled,
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  );
                                },
                                onReject: () {
                                  CustomBottomSheet.showBottomSheet(
                                    context,
                                    RejectReasonBottomSheet(
                                      reject: (reason) {
                                        ///send reason to the server
                                        homeProvider
                                            .rejectRequest(
                                                _data[index].id.toString(),
                                                reason)
                                            .listen((event) {
                                          if (event is RejectRequestLoaded) {
                                            final data = event.data;
                                            var socketProvider =
                                                locator<SocketProvider>();
                                            Navigator.pop(context);
                                            socketProvider
                                                .rejectRequestSocket();
                                            showToast(message: data.message);
                                          }
                                        });

                                        ///
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
              default:
                return const NoProjects();
            }
          },
        );
        // }
        // );

        // return
        //     //     !session.isOnline
        //     // ? Center(child: NoProjects(isOffline: !session.isOnline))
        //     // : _data.isEmpty
        //     //     ?
        //     const Center(child: NoProjects());
        // : Column(
        //     children: List.generate(
        //       _data.length,
        //       (index) => RequestTile(
        //         request: _data[index],
        //         onAccept: () {
        //           final session = locator<Session>();
        //           homeProvider
        //               .fetchOrderDetail(
        //                   _data[index].id.toString())
        //               .listen(
        //             (event1) {
        //               if (event1 is OrderDetailLoaded) {
        //                 // var _deviceSize = MediaQuery.of(context).size;
        //                 session.setRunningOrderId =
        //                     _data[index].id;
        //                 session.setOrderId =
        //                     _data[index].id.toString();
        //                 homeProvider
        //                     .fetchCustomerDetail(
        //                         event1.data.userId.toString())
        //                     .listen(
        //                   (event) async {
        //                     if (event
        //                         is CustomerDetailLoaded) {
        //                       session.setOrderUserId =
        //                           event1.data.userId;
        //                       print(
        //                           'RUNNING order id --> ${_data[index].id}');
        //                       homeProvider
        //                           .submitStatusOrder(
        //                               Order.driverAccept)
        //                           .listen(
        //                         (event) async {
        //                           if (event
        //                               is UpdateStatusOrderLoaded) {
        //                             if (event.data.success ==
        //                                 1) {
        //                               // var session =
        //                               //     locator<Session>();
        //                               session.setIsOrderRunning =
        //                                   true;
        //                               var socketProvider =
        //                                   locator<
        //                                       SocketProvider>();
        //                               socketProvider
        //                                   .acceptRequestSocket();
        //                               Navigator
        //                                   .pushNamedAndRemoveUntil(
        //                                 context,
        //                                 OrderPage.routeName,
        //                                 (route) => false,
        //                                 arguments:
        //                                     OrderPageArguments(
        //                                   orderDetail:
        //                                       homeProvider
        //                                           .orderDetail!,
        //                                   customerDetailModel:
        //                                       homeProvider
        //                                           .customerDetailModel!,
        //                                   orderStatus: event1
        //                                       .data
        //                                       .orderStatus,
        //                                 ),
        //                               );
        //                             } else if (event
        //                                     .data.message ==
        //                                 5) {
        //                               Navigator.of(context)
        //                                   .pop();
        //                               showDialog(
        //                                 context: context,
        //                                 builder: (context) =>
        //                                     CommonDialog(
        //                                   title: appLoc.sorry,
        //                                   msg: appLoc
        //                                       .orderacceptedotherdriver,
        //                                   onTap: () {
        //                                     Navigator.of(
        //                                             context)
        //                                         .pop();
        //                                   },
        //                                 ),
        //                               );
        //                             } else if (event
        //                                     .data.message ==
        //                                 6) {
        //                               Navigator.of(context)
        //                                   .pop();
        //                               showDialog(
        //                                 context: context,
        //                                 builder: (context) =>
        //                                     CommonDialog(
        //                                   title: appLoc.sorry,
        //                                   msg: appLoc
        //                                       .ordernotfound,
        //                                   onTap: () {
        //                                     Navigator.of(
        //                                             context)
        //                                         .pop();
        //                                   },
        //                                 ),
        //                               );
        //                             } else if (event
        //                                     .data.message ==
        //                                 7) {
        //                               Navigator.of(context)
        //                                   .pop();
        //                               showDialog(
        //                                 context: context,
        //                                 builder: (context) =>
        //                                     CommonDialog(
        //                                   title: appLoc.sorry,
        //                                   msg: appLoc
        //                                       .orderhascancelled,
        //                                   onTap: () {
        //                                     Navigator.of(
        //                                             context)
        //                                         .pop();
        //                                   },
        //                                 ),
        //                               );
        //                             }
        //                           }
        //                         },
        //                       );
        //                     }
        //                   },
        //                 );
        //               }
        //             },
        //           );
        //         },
        //         onReject: () {
        //           CustomBottomSheet.showBottomSheet(
        //             context,
        //             RejectReasonBottomSheet(
        //               reject: (reason) {
        //                 ///send reason to the server
        //                 homeProvider
        //                     .rejectRequest(
        //                         _data[index].id.toString(),
        //                         reason)
        //                     .listen((event) {
        //                   if (event is RejectRequestLoaded) {
        //                     final data = event.data;
        //                     var socketProvider =
        //                         locator<SocketProvider>();
        //                     Navigator.pop(context);
        //                     socketProvider
        //                         .rejectRequestSocket();
        //                     showToast(message: data.message);
        //                   }
        //                 });

        //                 ///
        //               },
        //             ),
        //           );
        //         },
        //       ),
        //     ),
        //   );
      },
    );
  }
}
