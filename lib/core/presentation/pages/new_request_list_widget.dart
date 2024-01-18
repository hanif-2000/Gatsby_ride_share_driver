import 'dart:async';
import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/new_request_tile.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utility/session_helper.dart';

class RequestListWidget extends StatefulWidget {
  const RequestListWidget({Key? key}) : super(key: key);

  @override
  State<RequestListWidget> createState() => _RequestListWidgetState();
}

class _RequestListWidgetState extends State<RequestListWidget>
    with WidgetsBindingObserver {
  Timer? timer;

  Session session = locator<Session>();

  String myText = '';

  var dio = Dio();
  var socketProvider = locator<LatestSocketProvider>();

  // StreamController<List<RequestListState>> controller =
  // StreamController << CurrencyModel > [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

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
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print("Inactive");
        break;
      case AppLifecycleState.paused:
        print("Paused");
        break;
      case AppLifecycleState.resumed:
        setState(() {
          myText = '';
        });
        print("Resumed");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LatestSocketProvider>(
      builder: (context, value, child) {
        return value.bookingList.isEmpty
            ? const Center(
                child: Text("Please wait for Ride"),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height * .82,
                child: ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: value.bookingList.length,
                  itemBuilder: (context, index) {
                    return NewRequestTile(
                      onAccept: () {
                        // Accept the Ride
                        value.acceptRideRequest(
                            orderId: value.bookingList[index].id);
                      },
                      onReject: () {
                        // Reject the ride
                        value.rejectRideRequest(
                            orderId: value.bookingList[index].id);
                      },
                      request: value.bookingList,
                      index: index,
                    );
                  },
                ),
              );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   log("request list build widget called");
  //   return session.isOrderRunning
  //       ? const Center(child: CircularProgressIndicator())
  //       : Consumer<HomeProvider>(
  //           builder: (context, homeProvider, _) {
  //             return StreamBuilder<RequestListState>(
  //               stream: context.read<HomeProvider>().getRequestListData(),
  //               builder: (context, state) {
  //                 log("this called again and again");
  //                 switch (state.data.runtimeType) {
  //                   case RequestListLoading:
  //                     return const Center(
  //                         child: CircularProgressIndicator(
  //                       color: blackColor,
  //                     ));
  //                   case RequestListFailure:
  //                     final failure =
  //                         (state.data as RequestListFailure).failure;
  //                     // showToast(message: failure.message);
  //                     showToast(
  //                         message: "Network slow Please Wait or try again");
  //                     return const SizedBox.shrink();
  //                   case RequestListLoaded:
  //                     final data = (state.data as RequestListLoaded).data;
  //                     final data0 = data.isEmpty ? [] : data.reversed.toList();
  //                     var session = locator<Session>();
  //                     return !session.isOnline
  //                         ? Center(
  //                             child: NoProjects(
  //                                 isOffline: !session.isOnline, text: myText),
  //                           )
  //                         : data0.isEmpty
  //                             ? Center(
  //                                 child: NoProjects(
  //                                 text: myText,
  //                               ))
  //                             : Column(
  //                                 children: List.generate(
  //                                   data0.length,
  //                                   (index) => RequestTile(
  //                                     request: data0[index],
  //                                     onAccept: () async {
  //                                       log("_data[index].id : ${data0[index].id}");
  //                                       var response = await dio.get(
  //                                         'https://php.parastechnologies.in/taxi/public/api/webservice/getOrder?id=${data0[index].id}',
  //                                         options: Options(headers: {
  //                                           "Authorization":
  //                                               "Bearer ${session.sessionToken}"
  //                                         }),
  //                                       );

  //                                       log("my response data is:  ${response.data}");

  //                                       if (response.data["order"]
  //                                               ["driver_id"] ==
  //                                           null) {
  //                                         final session = locator<Session>();
  //                                         homeProvider
  //                                             .fetchOrderDetail(
  //                                                 data0[index].id.toString())
  //                                             .listen(
  //                                           (event1) {
  //                                             log("fetch order details called on request list widget in home page");
  //                                             if (event1 is OrderDetailLoaded) {
  //                                               // var _deviceSize = MediaQuery.of(context).size;
  //                                               session.setRunningOrderId =
  //                                                   data0[index].id;
  //                                               session.setOrderId =
  //                                                   data0[index].id.toString();
  //                                               homeProvider
  //                                                   .fetchCustomerDetail(event1
  //                                                       .data.userId
  //                                                       .toString())
  //                                                   .listen(
  //                                                 (event) async {
  //                                                   if (event
  //                                                       is CustomerDetailLoaded) {
  //                                                     session.setOrderUserId =
  //                                                         event1.data.userId;
  //                                                     print(
  //                                                         'RUNNING order id --> ${data0[index].id}');
  //                                                     homeProvider
  //                                                         .submitStatusOrder(
  //                                                             Order
  //                                                                 .driverAccept)
  //                                                         .listen(
  //                                                       (event) async {
  //                                                         if (event
  //                                                             is UpdateStatusOrderLoaded) {
  //                                                           if (event.data
  //                                                                   .success ==
  //                                                               1) {
  //                                                             // var session =
  //                                                             //     locator<Session>();
  //                                                             session.setIsOrderRunning =
  //                                                                 true;
  //                                                             var socketProvider =
  //                                                                 locator<
  //                                                                     LatestSocketProvider>();
  //                                                             socketProvider
  //                                                                 .acceptRequestSocket();
  //                                                             Navigator
  //                                                                 .pushNamedAndRemoveUntil(
  //                                                               context,
  //                                                               OrderPage
  //                                                                   .routeName,
  //                                                               (route) =>
  //                                                                   false,
  //                                                               arguments:
  //                                                                   OrderPageArguments(
  //                                                                 orderDetail:
  //                                                                     homeProvider
  //                                                                         .orderDetail!,
  //                                                                 customerDetailModel:
  //                                                                     homeProvider
  //                                                                         .customerDetailModel!,
  //                                                                 orderStatus:
  //                                                                     event1
  //                                                                         .data
  //                                                                         .orderStatus,
  //                                                               ),
  //                                                             );
  //                                                           } else if (event
  //                                                                   .data
  //                                                                   .message ==
  //                                                               5) {
  //                                                             Navigator.of(
  //                                                                     context)
  //                                                                 .pop();
  //                                                             showDialog(
  //                                                               context:
  //                                                                   context,
  //                                                               builder:
  //                                                                   (context) =>
  //                                                                       CommonDialog(
  //                                                                 title: appLoc
  //                                                                     .sorry,
  //                                                                 msg: appLoc
  //                                                                     .orderacceptedotherdriver,
  //                                                                 onTap: () {
  //                                                                   Navigator.of(
  //                                                                           context)
  //                                                                       .pop();
  //                                                                 },
  //                                                               ),
  //                                                             );
  //                                                           } else if (event
  //                                                                   .data
  //                                                                   .message ==
  //                                                               6) {
  //                                                             Navigator.of(
  //                                                                     context)
  //                                                                 .pop();
  //                                                             showDialog(
  //                                                               context:
  //                                                                   context,
  //                                                               builder:
  //                                                                   (context) =>
  //                                                                       CommonDialog(
  //                                                                 title: appLoc
  //                                                                     .sorry,
  //                                                                 msg: appLoc
  //                                                                     .ordernotfound,
  //                                                                 onTap: () {
  //                                                                   Navigator.of(
  //                                                                           context)
  //                                                                       .pop();
  //                                                                 },
  //                                                               ),
  //                                                             );
  //                                                           } else if (event
  //                                                                   .data
  //                                                                   .message ==
  //                                                               7) {
  //                                                             Navigator.of(
  //                                                                     context)
  //                                                                 .pop();
  //                                                             showDialog(
  //                                                               context:
  //                                                                   context,
  //                                                               builder:
  //                                                                   (context) =>
  //                                                                       CommonDialog(
  //                                                                 title: appLoc
  //                                                                     .sorry,
  //                                                                 msg: appLoc
  //                                                                     .orderhascancelled,
  //                                                                 onTap: () {
  //                                                                   Navigator.of(
  //                                                                           context)
  //                                                                       .pop();
  //                                                                 },
  //                                                               ),
  //                                                             );
  //                                                           }
  //                                                         }
  //                                                       },
  //                                                     );
  //                                                   }
  //                                                 },
  //                                               );
  //                                             }
  //                                           },
  //                                         );
  //                                       } else {
  //                                         showToast(
  //                                             message:
  //                                                 "Order is Already Accepted by Other Driver");
  //                                         // showDialog(
  //                                         //   context: context,
  //                                         //   builder: (context) {
  //                                         //     return const Text(
  //                                         //         "Order is Already Accepted by Other Driver");
  //                                         //   },
  //                                         // );
  //                                         setState(() {
  //                                           myText = '';
  //                                         });
  //                                       }
  //                                     },
  //                                     onReject: () {
  //                                       CustomBottomSheet.showBottomSheet(
  //                                         context,
  //                                         RejectReasonBottomSheet(
  //                                           reject: (reason) {
  //                                             ///send reason to the server
  //                                             homeProvider
  //                                                 .rejectRequest(
  //                                                     data0[index]
  //                                                         .id
  //                                                         .toString(),
  //                                                     reason)
  //                                                 .listen((event) {
  //                                               if (event
  //                                                   is RejectRequestLoaded) {
  //                                                 final data = event.data;
  //                                                 var socketProvider = locator<
  //                                                     LatestSocketProvider>();
  //                                                 Navigator.pop(context);

  //                                                 Navigator
  //                                                     .pushNamedAndRemoveUntil(
  //                                                   context,
  //                                                   HomePage.routeName,
  //                                                   (route) => false,
  //                                                 );
  //                                                 socketProvider
  //                                                     .rejectRequestSocket();
  //                                                 showToast(
  //                                                     message: data.message);
  //                                               }
  //                                             });

  //                                             ///
  //                                           },
  //                                         ),
  //                                       );
  //                                     },
  //                                   ),
  //                                 ),
  //                               );
  //                   default:
  //                     return NoProjects(text: myText);
  //                 }
  //               },
  //             );
  //             // }
  //             // );

  //             // return
  //             //     //     !session.isOnline
  //             //     // ? Center(child: NoProjects(isOffline: !session.isOnline))
  //             //     // : _data.isEmpty
  //             //     //     ?
  //             //     const Center(child: NoProjects());
  //             // : Column(
  //             //     children: List.generate(
  //             //       _data.length,
  //             //       (index) => RequestTile(
  //             //         request: _data[index],
  //             //         onAccept: () {
  //             //           final session = locator<Session>();
  //             //           homeProvider
  //             //               .fetchOrderDetail(
  //             //                   _data[index].id.toString())
  //             //               .listen(
  //             //             (event1) {
  //             //               if (event1 is OrderDetailLoaded) {
  //             //                 // var _deviceSize = MediaQuery.of(context).size;
  //             //                 session.setRunningOrderId =
  //             //                     _data[index].id;
  //             //                 session.setOrderId =
  //             //                     _data[index].id.toString();
  //             //                 homeProvider
  //             //                     .fetchCustomerDetail(
  //             //                         event1.data.userId.toString())
  //             //                     .listen(
  //             //                   (event) async {
  //             //                     if (event
  //             //                         is CustomerDetailLoaded) {
  //             //                       session.setOrderUserId =
  //             //                           event1.data.userId;
  //             //                       print(
  //             //                           'RUNNING order id --> ${_data[index].id}');
  //             //                       homeProvider
  //             //                           .submitStatusOrder(
  //             //                               Order.driverAccept)
  //             //                           .listen(
  //             //                         (event) async {
  //             //                           if (event
  //             //                               is UpdateStatusOrderLoaded) {
  //             //                             if (event.data.success ==
  //             //                                 1) {
  //             //                               // var session =
  //             //                               //     locator<Session>();
  //             //                               session.setIsOrderRunning =
  //             //                                   true;
  //             //                               var socketProvider =
  //             //                                   locator<
  //             //                                       SocketProvider>();
  //             //                               socketProvider
  //             //                                   .acceptRequestSocket();
  //             //                               Navigator
  //             //                                   .pushNamedAndRemoveUntil(
  //             //                                 context,
  //             //                                 OrderPage.routeName,
  //             //                                 (route) => false,
  //             //                                 arguments:
  //             //                                     OrderPageArguments(
  //             //                                   orderDetail:
  //             //                                       homeProvider
  //             //                                           .orderDetail!,
  //             //                                   customerDetailModel:
  //             //                                       homeProvider
  //             //                                           .customerDetailModel!,
  //             //                                   orderStatus: event1
  //             //                                       .data
  //             //                                       .orderStatus,
  //             //                                 ),
  //             //                               );
  //             //                             } else if (event
  //             //                                     .data.message ==
  //             //                                 5) {
  //             //                               Navigator.of(context)
  //             //                                   .pop();
  //             //                               showDialog(
  //             //                                 context: context,
  //             //                                 builder: (context) =>
  //             //                                     CommonDialog(
  //             //                                   title: appLoc.sorry,
  //             //                                   msg: appLoc
  //             //                                       .orderacceptedotherdriver,
  //             //                                   onTap: () {
  //             //                                     Navigator.of(
  //             //                                             context)
  //             //                                         .pop();
  //             //                                   },
  //             //                                 ),
  //             //                               );
  //             //                             } else if (event
  //             //                                     .data.message ==
  //             //                                 6) {
  //             //                               Navigator.of(context)
  //             //                                   .pop();
  //             //                               showDialog(
  //             //                                 context: context,
  //             //                                 builder: (context) =>
  //             //                                     CommonDialog(
  //             //                                   title: appLoc.sorry,
  //             //                                   msg: appLoc
  //             //                                       .ordernotfound,
  //             //                                   onTap: () {
  //             //                                     Navigator.of(
  //             //                                             context)
  //             //                                         .pop();
  //             //                                   },
  //             //                                 ),
  //             //                               );
  //             //                             } else if (event
  //             //                                     .data.message ==
  //             //                                 7) {
  //             //                               Navigator.of(context)
  //             //                                   .pop();
  //             //                               showDialog(
  //             //                                 context: context,
  //             //                                 builder: (context) =>
  //             //                                     CommonDialog(
  //             //                                   title: appLoc.sorry,
  //             //                                   msg: appLoc
  //             //                                       .orderhascancelled,
  //             //                                   onTap: () {
  //             //                                     Navigator.of(
  //             //                                             context)
  //             //                                         .pop();
  //             //                                   },
  //             //                                 ),
  //             //                               );
  //             //                             }
  //             //                           }
  //             //                         },
  //             //                       );
  //             //                     }
  //             //                   },
  //             //                 );
  //             //               }
  //             //             },
  //             //           );
  //             //         },
  //             //         onReject: () {
  //             //           CustomBottomSheet.showBottomSheet(
  //             //             context,
  //             //             RejectReasonBottomSheet(
  //             //               reject: (reason) {
  //             //                 ///send reason to the server
  //             //                 homeProvider
  //             //                     .rejectRequest(
  //             //                         _data[index].id.toString(),
  //             //                         reason)
  //             //                     .listen((event) {
  //             //                   if (event is RejectRequestLoaded) {
  //             //                     final data = event.data;
  //             //                     var socketProvider =
  //             //                         locator<SocketProvider>();
  //             //                     Navigator.pop(context);
  //             //                     socketProvider
  //             //                         .rejectRequestSocket();
  //             //                     showToast(message: data.message);
  //             //                   }
  //             //                 });

  //             //                 ///
  //             //               },
  //             //             ),
  //             //           );
  //             //         },
  //             //       ),
  //             //     ),
  //             //   );
  //           },
  //         );
  // }
}
