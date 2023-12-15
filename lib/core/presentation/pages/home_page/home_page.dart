import 'dart:async';
import 'dart:developer';
import 'package:appkey_taxiapp_driver/core/presentation/pages/history_list_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/pages/menu_page.dart';
import 'package:appkey_taxiapp_driver/core/presentation/pages/request_list_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_app_bar.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/dimens.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/pages/order_page.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/order_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/profile/presentation/providers/customer_detail_state.dart';
import '../../../utility/helper.dart';
import '../../../utility/injection.dart';
import '../../providers/home_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  // final FcmProvider _fcmProvider = locator<FcmProvider>();

  // var provider = locator<HomeProvider>();
  var socketProvider = locator<SocketProvider>();

  @override
  void initState() {
    super.initState();
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    var session = locator<Session>();

    // homeProvider.getDriverStatus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeProvider.changeStatus = session.isOnline;
    });

    // _fcmProvider.addListener(() async => await fcmListener());
    WidgetsBinding.instance.addObserver(this);
    // connectToSocket();

    // !session.isOrderRunning
    //     ? homeProvider.getRequestListData().listen((event) {
    //         if (event is RequestListLoaded) {
    //           logMe(
    //               'Request list data loaded success----------> ${event.data.length}');
    //         }
    //       })
    //     : null;
  }

  // connectToSocket() {
  //   socketProvider.connectToSocket();
  // }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // fcmListener() async {
  //   final session = locator<Session>();
  //   logMe("incoming action: ${_fcmProvider.incomingOrderDetail}");
  //
  //   provider
  //       .fetchOrderDetail(_fcmProvider.incomingOrderDetail!.orderId)
  //       .listen(
  //     (event) {
  //       if (event is OrderDetailLoaded) {
  //         var _deviceSize = MediaQuery.of(context).size;
  //         provider.fetchCustomerDetail(event.data.userId.toString()).listen(
  //           (event) async {
  //             if (event is CustomerDetailLoaded) {
  //               await showDialog(
  //                 barrierDismissible: false,
  //                 context: context,
  //                 builder: (_) => WillPopScope(
  //                   onWillPop: () async => false,
  //                   child: MainDialog(
  //                     customerDetailModel: provider.customerDetailModel,
  //                     orderDetail: provider.orderDetail,
  //                     deviceSize: _deviceSize,
  //                     onDecline: () async {
  //                       await showDialog(
  //                         barrierDismissible: false,
  //                         context: context,
  //                         builder: (_) => WillPopScope(
  //                           onWillPop: () async => false,
  //                           child: CustomDeclineDialog(
  //                             positiveAction: () {
  //                               provider.changeStatus = false;
  //                               provider.updateStatus().listen(
  //                                 (event) async {
  //                                   if (event is ChangeStatusLoaded) {
  //                                     Navigator.pop(context);
  //                                     Navigator.pop(context);
  //                                   }
  //                                 },
  //                               );
  //                             },
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                     onAccept: () {
  //                       session.setOrderId =
  //                           _fcmProvider.incomingOrderDetail!.orderId;
  //                       provider
  //                           .submitStatusOrder(Order.driverAccept)
  //                           .listen(
  //                         (event) async {
  //                           if (event is UpdateStatusOrderLoaded) {
  //                             if (event.data.success == 1) {
  //                               Navigator.pushNamedAndRemoveUntil(
  //                                 context,
  //                                 OrderPage.routeName,
  //                                 (route) => false,
  //                                 arguments: OrderPageArguments(
  //                                   orderDetail: provider.orderDetail!,
  //                                   customerDetailModel:
  //                                       provider.customerDetailModel!,
  //                                 ),
  //                               );
  //                             } else if (event.data.message == 5) {
  //                               Navigator.of(context).pop();
  //                               showDialog(
  //                                 context: context,
  //                                 builder: (context) => CommonDialog(
  //                                   title: appLoc.sorry,
  //                                   msg: appLoc.orderacceptedotherdriver,
  //                                   onTap: () {
  //                                     Navigator.of(context).pop();
  //                                   },
  //                                 ),
  //                               );
  //                             } else if (event.data.message == 6) {
  //                               Navigator.of(context).pop();
  //                               showDialog(
  //                                 context: context,
  //                                 builder: (context) => CommonDialog(
  //                                   title: appLoc.sorry,
  //                                   msg: appLoc.ordernotfound,
  //                                   onTap: () {
  //                                     Navigator.of(context).pop();
  //                                   },
  //                                 ),
  //                               );
  //                             } else if (event.data.message == 7) {
  //                               Navigator.of(context).pop();
  //                               showDialog(
  //                                 context: context,
  //                                 builder: (context) => CommonDialog(
  //                                   title: appLoc.sorry,
  //                                   msg: appLoc.orderhascancelled,
  //                                   onTap: () {
  //                                     Navigator.of(context).pop();
  //                                   },
  //                                 ),
  //                               );
  //                             }
  //                           }
  //                         },
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               );
  //             }
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    log("home page build called ");
    return WillPopScope(
      onWillPop: () {
        return Future.value(false); // if true allow back else block it
      },
      child: Scaffold(
        // key: provider.globalKey,
        resizeToAvoidBottomInset: false,
        appBar: const CustomAppBar(
          centerTitle: true,
        ),
        drawer: const HomeDrawerPage(),
        body: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            var session = locator<Session>();

            log("is ORDER RUNNIG :--->>  ${session.isOrderRunning}");
            log("Order status is :--->>  ${session.orderStatus}");

            log('RUNNING order id --> ${session.runningOrderId}');
            if (session.isOrderRunning) {
              provider
                  .fetchOrderDetail(session.runningOrderId.toString())
                  .listen(
                (event1) {
                  if (event1 is OrderDetailLoaded) {
                    log("home page build called : order details loaded");
                    // var _deviceSize = MediaQuery.of(context).size;

                    bool isOrderLoaded = true;

                    event1.data.userId != null
                        ? provider
                            .fetchCustomerDetail(event1.data.userId.toString())
                            .listen(
                            (event) async {
                              if (event is CustomerDetailLoaded) {
                                log("home page build called : Customer details loaded");

                                bool isCustomerLoaded = true;

                                if (isCustomerLoaded && isOrderLoaded) {
                                  Navigator.pushAndRemoveUntil<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          OrderPage(
                                              customerDetail:
                                                  provider.customerDetailModel!,
                                              orderDetail:
                                                  provider.orderDetail!,
                                              orderStatus:
                                                  event1.data.orderStatus),
                                    ),
                                    (route) =>
                                        false, //if you want to disable back feature set to false
                                  );

                                  // Navigator.pushNamed(
                                  //   context,
                                  //   OrderPage.routeName,
                                  //   // (route) => false,
                                  //   arguments: OrderPageArguments(
                                  //     orderDetail: provider.orderDetail!,
                                  //     customerDetailModel:
                                  //         provider.customerDetailModel!,
                                  //     orderStatus: event1.data.orderStatus,
                                  //   ),
                                  // );
                                }

                                // provider
                                //     .submitStatusOrder(Order.driverAccept)
                                //     .listen(
                                //   (event) async {
                                //     if (event is UpdateStatusOrderLoaded) {
                                //       if (event.data.success == 1) {
                                //         Navigator.pushNamed(
                                //           context,
                                //           OrderPage.routeName,
                                //           // (route) => false,
                                //           arguments: OrderPageArguments(
                                //             orderDetail: provider.orderDetail!,
                                //             customerDetailModel:
                                //                 provider.customerDetailModel!,
                                //           ),
                                //         );
                                //       } else if (event.data.message == 5) {
                                //         // Navigator.of(context).pop();
                                //         showDialog(
                                //           context: context,
                                //           builder: (context) => CommonDialog(
                                //             title: appLoc.sorry,
                                //             msg: appLoc.orderacceptedotherdriver,
                                //             onTap: () {
                                //               Navigator.of(context).pop();
                                //             },
                                //           ),
                                //         );
                                //       } else if (event.data.message == 6) {
                                //         // Navigator.of(context).pop();
                                //         showDialog(
                                //           context: context,
                                //           builder: (context) => CommonDialog(
                                //             title: appLoc.sorry,
                                //             msg: appLoc.ordernotfound,
                                //             onTap: () {
                                //               Navigator.of(context).pop();
                                //             },
                                //           ),
                                //         );
                                //       } else if (event.data.message == 7) {
                                //         // Navigator.of(context).pop();
                                //         showDialog(
                                //           context: context,
                                //           builder: (context) => CommonDialog(
                                //             title: appLoc.sorry,
                                //             msg: appLoc.orderhascancelled,
                                //             onTap: () {
                                //               Navigator.of(context).pop();
                                //             },
                                //           ),
                                //         );
                                //       }
                                //     }
                                //   },
                                // );
                              }
                            },
                          )
                        : const SizedBox();
                  }
                },
              );
            }
            return ListView(
              children: <Widget>[
                Container(
                  height: 50,
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.all(sizeMedium),
                  decoration: BoxDecoration(
                    color: greyF4F4F4,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: optionTile(
                          title: 'Requests',
                          isSelected:
                              provider.projectType == ProjectType.requests,
                          onChange: () {
                            provider.projectType = ProjectType.requests;
                          },
                        ),
                      ),
                      smallHorizontalSpacing(),
                      Expanded(
                        child: optionTile(
                          title: 'History',
                          isSelected:
                              provider.projectType == ProjectType.history,
                          onChange: () {
                            provider.projectType = ProjectType.history;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                provider.projectType == ProjectType.requests
                    ? const RequestListWidget()
                    : const HistoryListWidget(),
                // const NoProjects(),

                // GoogleMap(
                //   mapType: MapType.normal,
                //   myLocationButtonEnabled: false,
                //   zoomControlsEnabled: false,
                //   initialCameraPosition: map.kJapanCoordinate,
                //   onMapCreated: (GoogleMapController controller) async {
                //     map.googleMapController = controller;
                //     await map.setCurrentLocation();
                //     // }
                //   },
                //   polylines: map.polylines,
                //   markers: Set<Marker>.of(map.markers.values),
                // ),
                // SafeArea(
                //   child: Stack(
                //     children: [
                //       Column(
                //         mainAxisSize: MainAxisSize.max,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: <Widget>[
                //           Expanded(
                //             child: Column(
                //               crossAxisAlignment: CrossAxisAlignment.end,
                //               mainAxisAlignment: MainAxisAlignment.end,
                //               children: const [
                //                 // CurrentLocationWidget(),
                //                 // BottomContainerHome()
                //               ],
                //             ),
                //           )
                //         ],
                //       ),
                //     ],
                //   ),
                // )
              ],
            );
          },
        ),
      ),
    );
  }

  optionTile({title, onChange, isSelected}) {
    return InkWell(
      onTap: onChange,
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : greyF4F4F4,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          title,
          style: versionAppTextStyle.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.white : greyBlackColor,
          ),
        ),
      ),
    );
  }
}
