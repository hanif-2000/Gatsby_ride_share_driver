import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:appkey_taxiapp_driver/core/presentation/pages/history_list_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/pages/menu_page.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/fcm_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_app_bar.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/dimens.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/pages/new_order_page.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/customer_detail_state.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/order_detail_state.dart';
import 'package:appkey_taxiapp_driver/features/receipt/data/model/new_receipt_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/rating/presentation/page/give_rating_screen.dart';
import '../../../../features/receipt/persentation/pages/new_receipt_page.dart';
import '../../../utility/helper.dart';
import '../../../utility/injection.dart';
import '../../providers/home_provider.dart';
import '../new_request_list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final FcmProvider _fcmProvider = locator<FcmProvider>();

  // var provider = locator<HomeProvider>();
  var socketProvider = locator<LatestSocketProvider>();
  // var homeProvider = locator<HomeProvider>();

  var session = locator<Session>();

  Future<void> retrieveOrderReceiptFromLocal() async {
    // Retrieve the JSON string from local storage
    String? jsonData = session.orderReceipt;
    // ReceiptData dataMap = json.decode(jsonData);
    Map<String, dynamic> jsonMap = json.decode(jsonData);
    // Map the data to your ReceiptResponseModel
    ReceiptData receiptData = ReceiptData.fromJson(jsonMap);
    log("new ----${receiptData.newTotal}");

    socketProvider.updateReceiptData(data: receiptData).then((value) {
      logMe("RECEIPT DATA UPDATED SUCCESS");
      log("order receipt data from session :-->> ${socketProvider.receiptData}");
      print(
          "order receipt data from session :-->> ${socketProvider.receiptData!.newTotal}");
    });
  }

  @override
  void initState() {
    super.initState();
    socketProvider.connectToSocket(context);
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);

    // var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    print(
        "********************* ------->>>>>. IS ORDER RUNNING :: ${session.isOrderRunning} <<<<<<<----------*****");
    print(
        "********************* ------->>>>>. IS ORDER RUNNING STATUS:: ${session.runningOrderStatus} <<<<<<<----------*****");
/*    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        socketProvider.disconnectSocket();
      } else {
        //socketProvider.disconnectSocket();
        socketProvider.connectToSocket(context);
      }
      // Got a new connectivity status!
    });*/

    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeProvider.changeStatus = session.isOnline;
      if (session.isOrderRunning) {
        log("----order running called--- ${session.runningOrderStatus}");
        log("----order running called---");

        showLoading();

        if (session.runningOrderStatus == 7) {
          log("----order running called runningOrderStatus 7---");
          log("----order running called isPaymentDone ${session.isPaymentDone}");
          log("----order running called israting done ${session.isRatingGiven}");

          if (!session.isPaymentDone) {
            log("----order running called isPaymentDone ${session.isPaymentDone}");
            /*** Payment confirmation pending */

            retrieveOrderReceiptFromLocal().then((value) {
              log("----order running called retreve order receipt from local storage ---");

              homeProvider
                  .fetchOrderDetail(session.runningOrderId.toString())
                  .listen((event) {
                if (event is OrderDetailLoaded) {
                  log("order details in home page checking is :--> ${event.data}");
                  print(
                      "order details in home page checking is :--> ${event.data}");

                  socketProvider.updateOrderData(data: event.data);
                  socketProvider.setNewChangeOrderStatus =
                      event.data.orderStatus.toString();
                  session.setRunningOrderStatus =
                      int.parse(event.data.orderStatus.toString());
                  socketProvider.updateCurrentStatus(
                      status: int.parse(event.data.orderStatus.toString()));
                  homeProvider
                      .fetchCustomerDetail(event.data.userId.toString())
                      .listen((event2) async {
                    if (event2 is CustomerDetailLoaded) {
                      log("customer details in home page checking is :--> ${event2.data}");
                      print(
                          "customer details in home page checking is :--> ${event2.data}");

                      socketProvider
                          .updateCustomerData(data: event2.data.data)
                          .then((value) {
                        dismissLoading();
                        /**   Navigate to receipt screen */
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          ReceiptPage.routeName,
                          (route) => false,
                          arguments: RatingPageArguments(
                            customerDataModel: socketProvider.customerDetail!,
                            customerId: socketProvider.orderDetail!.userId,
                          ),
                        );
                      });
                    }
                  });
                }
              });

              print(
                  "home provider ordetails are:==>> ${homeProvider.orderDetail}");
              print(
                  "home provider ordetails are:==>> ${homeProvider.orderDetail}");
              log("session order STATUS IS :==>> ${session.runningOrderStatus}");
              log("session order STATUS RUUNING IS :==>> ${session.runningOrderStatus}");
            });
          } else if (!session.isRatingGiven) {
            homeProvider
                .fetchCustomerDetail(session.customerId.toString())
                .listen((event2) async {
              if (event2 is CustomerDetailLoaded) {
                log("customer details in home page checking is :--> ${event2.data}");
                print(
                    "customer details in home page checking is :--> ${event2.data}");

                socketProvider
                    .updateCustomerData(data: event2.data.data)
                    .then((value) {
                  dismissLoading();

                  Navigator.pushNamedAndRemoveUntil(
                    locator<GlobalKey<NavigatorState>>().currentContext!,
                    GiveRatingScreen.routeName,
                    (route) => false,
                    arguments: RatingPageArguments(
                      customerDataModel: socketProvider.customerDetail!,
                      customerId: socketProvider.customerDetail!.id,
                    ),
                  );
                });
              }
            });
          } else {
            dismissLoading();
          }
        } else {
          // var id = _fcmProvider.incomingOrderDetail!.orderId;
          log("session order id is:-------->>>>>>.. ${session.runningOrderId}");
          log("session customer id is:-------->>>>>>.. ${session.customerId}");

          homeProvider
              .fetchOrderDetail(session.runningOrderId.toString())
              .listen((event) {
            if (event is OrderDetailLoaded) {
              log("order details in home page checking is :--> ${event.data}");
              socketProvider.updateOrderData(data: event.data);
              socketProvider.setNewChangeOrderStatus =
                  event.data.orderStatus.toString();
              session.setRunningOrderStatus =
                  int.parse(event.data.orderStatus.toString());
              socketProvider.updateCurrentStatus(
                  status: int.parse(event.data.orderStatus.toString()));
              homeProvider
                  .fetchCustomerDetail(session.customerId.toString())
                  .listen((event2) async {
                if (event2 is CustomerDetailLoaded) {
                  log("customer details in home page checking is :--> ${event2.data}");
                  socketProvider
                      .updateCustomerData(data: event2.data.data)
                      .then((value) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      homeProvider.changeStatus = session.isOnline;
                      dismissLoading();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        NewOrderPage.routeName,
                        (route) => false,
                        arguments: NewOrderPageArguments(
                          orderDetail: socketProvider.orderDetail!,
                          customerDetailModel: socketProvider.customerDetail!,
                          orderStatus: session.runningOrderStatus,
                        ),
                      );
                    });
                  });
                }
              });
            }
          });

          // print("home provider ordetails are:==>> ${homeProvider.orderDetail}");
          print("home provider ordetails are:==>> ${homeProvider.orderDetail}");
          log("session order STATUS IS :==>> ${session.runningOrderStatus}");
          log("session order STATUS RUUNING IS :==>> ${session.runningOrderStatus}");
        }
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          homeProvider.changeStatus = session.isOnline;
        });
      }
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   super.didChangeAppLifecycleState(state);

  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       socketProvider.connectToSocket(context);
  //       break;
  //     case AppLifecycleState.paused:
  //       socketProvider.disconnectSocket();
  //       // The app is now in the background
  //       print('App paused');
  //       break;
  //     case AppLifecycleState.inactive:
  //       socketProvider.disconnectSocket();
  //       // The app is in an inactive state (e.g., during a phone call)
  //       print('App inactive');
  //       break;
  //     case AppLifecycleState.detached:
  //       socketProvider.disconnectSocket();
  //       // The app is detached (e.g., terminated)
  //       print('App detached');
  //       break;
  //     case AppLifecycleState.hidden:
  //       socketProvider.disconnectSocket();

  //       break;
  //   }
  // }

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
    return PopScope(
      canPop: false,
      child: Consumer<HomeProvider>(builder: (context, provider, _) {
        return Scaffold(
            // key: provider.globalKey,
            resizeToAvoidBottomInset: false,
            appBar: const CustomAppBar(
              centerTitle: true,
            ),
            drawer: const HomeDrawerPage(),
            // body: Consumer<HomeProvider>(
            //   builder: (context, provider, _) {
            body: ListView(
              children: <Widget>[
                Container(
                  // height: 50,
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
              ],
            )

            //   },
            // ),
            );
      }),
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
