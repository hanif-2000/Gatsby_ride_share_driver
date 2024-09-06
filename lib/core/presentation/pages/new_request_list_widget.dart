import 'dart:async';
import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/data/models/customer_detail_model.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/new_request_tile.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/entities/order_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/order/presentation/pages/new_order_page.dart';
import '../../utility/session_helper.dart';
import '../widgets/no_projects.dart';

class RequestListWidget extends StatefulWidget {
  const RequestListWidget({super.key});

  @override
  State<RequestListWidget> createState() => _RequestListWidgetState();
}

class _RequestListWidgetState extends State<RequestListWidget>
    with WidgetsBindingObserver {
  Timer? timer;

  Session session = locator<Session>();

  String myText = '';

  var dio = Dio();
  // var latestSocketProvider = Provider.of<LatestSocketProvider>(
  //     locator<GlobalKey<NavigatorState>>().currentContext!,
  //     listen: false);

  // StreamController<List<RequestListState>> controller =
  // StreamController << CurrencyModel > [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }

  @override
  void dispose() {
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
      case AppLifecycleState.detached:
        print("detached:");
        break;
      case AppLifecycleState.hidden:
        print("hidden:");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LatestSocketProvider>(
      builder: (context, LatestSocketProvider socketProvider, _) {
        return Consumer<HomeProvider>(
            builder: (context, HomeProvider homeProvider, _) {
          return !session.isOnline
              ? Center(
                  child: NoProjects(isOffline: !session.isOnline, text: myText),
                )
              : socketProvider.bookingList.isEmpty
                  ? Center(
                      child: NoProjects(
                      text: myText,
                    ))
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * .82,
                      child: ListView.builder(
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: socketProvider.bookingList.length,
                        itemBuilder: (context, index) {
                          return NewRequestTile(
                            onAccept: () {
                              // Accept the Ride
                              socketProvider.acceptRideRequest(orderId: socketProvider.bookingList[index].id).then((value) {
                                print(
                                    "estimated time is :-->> ${socketProvider.bookingList[index].estimatedTime}");
                                print(
                                    "estimated distance is :-->> ${socketProvider.bookingList[index].distance}");

                                print(
                                    "customer id is:-> ${socketProvider.bookingList[index].customerId}");
                                var session = locator<Session>();
                                session.setIsOrderRunning = true;
                                session.setEstimatedTime = socketProvider.bookingList[index].estimatedTime;
                                session.setEstimatedDistance = socketProvider.bookingList[index].distance.toString();
                                session.setRunningOrderId = int.parse(socketProvider.bookingList[index].id.toString());
                                session.setCustomerId = int.parse(socketProvider.bookingList[index].customerId.toString());

                                /*** ORDER DETAILS  */

                                print("order id:-->>${socketProvider.bookingList[index].id}");
                                print("total order id:-->>${socketProvider.bookingList[index].newTotal}");
                                print("customerId order id:-->>${socketProvider.bookingList[index].customerId}");
                                print("order id:-->>${socketProvider.bookingList[index].id}");
                                print("distance order id:-->>${socketProvider.bookingList[index].distance}");
                                print("start coordinate order id:-->>${socketProvider.bookingList[index].startCoordinate}");
                                print("endCoordinate order id:-->>${socketProvider.bookingList[index].endCoordinate}");
                                print("startAddress order id:-->>${socketProvider.bookingList[index].startAddress}");
                                print("end address order id:-->>${socketProvider.bookingList[index].id}");
                                logMe("customer id from session id:-->> ${session.customerId}");

                                homeProvider.setOrderDetails = OrderDetail(
                                  orderId: int.parse(socketProvider.bookingList[index].id.toString()),
                                  totalPrice: socketProvider.bookingList[index].total,
                                  userId: int.parse(socketProvider.bookingList[index].customerId.toString()),
                                  driverId: int.parse(session.userId),
                                  distance: socketProvider.bookingList[index].distance.toString(),
                                  orderStatus: 0,
                                  startCoordinate: socketProvider.bookingList[index].startCoordinate??"0.0",
                                  endCoordinate: socketProvider.bookingList[index].endCoordinate??"0.0",
                                  startAddress: socketProvider.bookingList[index].startAddress??"",
                                  endAddress: socketProvider.bookingList[index].endAddress??"",
                                  pendingAmount: socketProvider.bookingList[index].pendingAmount.toString(),
                                  newTotal: socketProvider.bookingList[index].newTotal,
                                );
                                homeProvider.setCustomerDetails = CustomerDataModel(
                                  name: socketProvider.bookingList[index].name??"",
                                  phoneNumber: socketProvider.bookingList[index].phone,
                                  photo: socketProvider.bookingList[index].image,
                                  id: int.parse(socketProvider.bookingList[index].customerId.toString()),
                                  rating: socketProvider.bookingList[index].customerRating,

                                );

                                print("=========\nOrder details  home provider are:-->. ${homeProvider.orderDetail!}");
                                print("=========\nCustomer details are:-->. ${homeProvider.customerDetailModel!}");

                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  NewOrderPage.routeName,
                                  (route) => false,
                                  arguments: NewOrderPageArguments(
                                    // orderTotal: socketProvider
                                    //     .bookingList[index].newTotal,
                                    orderDetail: homeProvider.orderDetail!,
                                    customerDetailModel: homeProvider.customerDetailModel!,
                                    orderStatus: 0,
                                  ),
                                );
                              });
                            },
                            onReject: () {
                              // Reject the ride
                              socketProvider.rejectRideRequest(orderId: socketProvider.bookingList[index].id)
                                  .then((value) {
                                print("reject order successfully");
                              });
                            },
                            request: socketProvider.bookingList,
                            index: index,
                          );
                        },
                      ),
                    );
        });
      },
    );
  }

}
