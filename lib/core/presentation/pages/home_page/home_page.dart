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
  const HomePage({super.key});
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final FcmProvider _fcmProvider = locator<FcmProvider>();

  // var provider = locator<HomeProvider>();
  // var socketProvider = locator<LatestSocketProvider>();
  // var homeProvider = locator<HomeProvider>();

  var session = locator<Session>();

  Future<void> retrieveOrderReceiptFromLocal() async {
    final socketProvider = context.read<LatestSocketProvider>();
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
    final socketProvider = context.read<LatestSocketProvider>();
    socketProvider.onInit();
    socketProvider.resetAfterRideEnd();
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);
    print(
        "********************* ------->>>>>. IS ORDER RUNNING :: ${session.isOrderRunning} <<<<<<<----------*****");
    print(
        "********************* ------->>>>>. IS ORDER RUNNING STATUS:: ${session.runningOrderStatus} <<<<<<<----------*****");
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeProvider.changeStatus = session.isOnline;
      if (session.isOrderRunning) {
        log("----order running called--- ${session.runningOrderStatus}");
        showLoading();

        if (session.runningOrderStatus == 7) {
          log("----order running called runningOrderStatus 7---");
          log("----order running called isPaymentDone ${session.isPaymentDone}");
          log("----order running called is rating done ${session.isRatingGiven}");

          if (!session.isPaymentDone) {
            log("----order running called isPaymentDone ${session.isPaymentDone}");
            /*** Payment confirmation pending */

            retrieveOrderReceiptFromLocal().then((value) {
              log("----order running called retreve order receipt from local storage ---");

              homeProvider
                  .fetchOrderDetail(session.runningOrderId.toString())
                  .listen((event) {
                if (event is OrderDetailLoaded) {
                  print(
                      "order details in home page checking is :--> ${event.data}");
                  socketProvider.updateOrderData(data: event.data);
                  socketProvider.setNewChangeOrderStatus =
                      event.data.orderStatus.toString();
                  session.setRunningOrderStatus =
                      int.parse(event.data.orderStatus.toString());
                  socketProvider.updateCurrentStatus(
                    status: int.parse(
                      event.data.orderStatus.toString(),
                    ),
                  );
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
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

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
