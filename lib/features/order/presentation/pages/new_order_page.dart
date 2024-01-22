import 'dart:developer';
import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../core/data/models/customer_detail_model.dart';
import '../../../../core/presentation/widgets/destination_widget.dart';
import '../../../../core/presentation/widgets/origin_widget.dart';
import '../../domain/entities/order_detail.dart';
import '../providers/new_order_provider.dart';
import '../widgets/bottom_container_order.dart';

class NewOrderPageArguments {
  final OrderDetail orderDetail;
  final CustomerDataModel customerDetailModel;
  final int orderStatus;

  NewOrderPageArguments({
    required this.orderDetail,
    required this.customerDetailModel,
    required this.orderStatus,
  });
}

class RatingPageArguments {
  final CustomerDataModel customerDataModel;
  final int? customerId;

  RatingPageArguments({
    required this.customerDataModel,
    required this.customerId,
  });
}

class NewOrderPage extends StatefulWidget {
  final OrderDetail orderDetail;
  final CustomerDataModel customerDetail;
  final int orderStatus;

  const NewOrderPage(
      {Key? key,
      required this.orderDetail,
      required this.customerDetail,
      required this.orderStatus})
      : super(key: key);
  static const routeName = '/OrderPage';

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage>
    with WidgetsBindingObserver {
  // Timer? checkOrderStatusTimer, trackingTimer, updateLocationTimer;
  // var orderPProvider = locator<OrderProvider>();
  var socketProvider = locator<LatestSocketProvider>();
  var orderProvider = locator<OrderProvider>();

  var session = locator<Session>();

  // late StreamSubscription<LocationData> locationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // socketProvider.listenRequests();

    // socketProvider.getTotalUnreadCount(widget.customerDetail.id);

    // showLoading();
    socketProvider.removeOrderFromList(orderId: widget.orderDetail.orderId);
    session.setOrderId = widget.orderDetail.orderId.toString();
    socketProvider.updateCustomerData(
        data: CustomerDataModel(
            name: widget.customerDetail.name,
            phoneNumber: widget.customerDetail.phoneNumber,
            photo: widget.customerDetail.photo,
            id: widget.customerDetail.id,
            rating: widget.customerDetail.rating));
    orderProvider.setOrderDetails = widget.orderDetail;

    socketProvider.updateOrderData(data: widget.orderDetail);
    orderProvider.setNewPolylineDirection(false);

    log("current order status is :-->> ${widget.orderStatus}");
    log("current order status is on order page init :-->> ${widget.orderStatus}");
  }

  @override
  void dispose() {
    super.dispose();
    // checkOrderStatusTimer?.cancel();
    // trackingTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    log("order page build widget called");
    var session = locator<Session>();
    var orderProvider = locator<OrderProvider>();

    log("session order status ${session.currentOrderState}");

    var deviceSize = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: const CustomAppBar(
        //   centerTitle: false,
        // ),
        body: Consumer2(
          builder: (context, OrderProvider orderProvider,
              LatestSocketProvider socketProvider, _) {
            // if (checkOrderStatusTimer != null) {
            //   checkOrderStatusTimer!.cancel();
            // }
            // if (trackingTimer != null) {
            //   trackingTimer!.cancel();
            // }
            // trackingTimer =
            //     Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
            //   await provider.trackingDriver();
            // });

            // checkOrderStatusTimer = Timer.periodic(
            //   const Duration(seconds: 5),
            //   (Timer timer) async {
            //     log("------>>>>>  this will called every 3 seconds  <<<<<--------");
            //     provider.fetchOrderStatus().listen(
            //       (state) async {
            //         if (state is GetStatusOrderLoaded) {
            //           session.setCurrentOrderState =
            //               int.parse(state.data.status);

            //           // provider.updateOrderStatusAfterAppRestart(
            //           //     orderStatus: int.parse(state.data.status));

            //           log("curent SAVED order Status is::-->>  ${session.currentOrderState}");

            //           log("current order state is::==>> ${state.data.status}");

            //           log("current order state is check order value string or int is-->>  ${Order.departureToCustomerPlace}");
            //           if (state.data.status == Order.driverAccept.toString()) {
            //             log("current status is DRIVER ACCEPT ");
            //           }

            //           if (state.data.status ==
            //               Order.departureToCustomerPlace.toString()) {
            //             log("current status is DEPARTURE TO CUSTOMER");
            //           } else if (state.data.status ==
            //               OrderStatus.arriveAtCustomerPlace.toString()) {
            //             log("current status is ARRIVE AT CUSTOMER PLACE");
            //           } else if (state.data.status ==
            //               OrderStatus.departureToDestination.toString()) {
            //             log("current status is DEPARTURE TO DESTINATION");
            //           } else if (state.data.status ==
            //               OrderStatus.arriveAtDestination.toString()) {
            //             log("current status is ARRIVE AT DESTINATION");
            //           }

            //           // if (state.data.status ==
            //           //     Order.departureToCustomerPlace.toString()) {
            //           //   provider.changeOrderStatus =
            //           //       OrderStatus.departureToDestination;
            //           // }

            //           // if (true) {
            //           //   setDefaultStatus(int.parse(state.data.status));
            //           // }

            //           // if (state.data.status ==
            //           //     Order.customerConfirmation.toString()) {
            //           //   provider.changeOrderStatus =
            //           //       OrderStatus.customerConfirmation;
            //           // }

            //           // if (state.data.status ==
            //           //     Order.departureToCustomerPlace.toString()) {
            //           //   provider.changeOrderStatus =
            //           //       OrderStatus.departureToCustomerplace;
            //           // }
            //           // if (state.data.status ==
            //           //     Order.arriveAtCustomerPlace.toString()) {
            //           //   provider.changeOrderStatus =
            //           //       OrderStatus.arriveAtCustomerPlace;
            //           // }

            //           if (state.data.status ==
            //               Order.departureToDestination.toString()) {
            //             provider.changeOrderStatus =
            //                 OrderStatus.departureToDestination;
            //           }
            //           if (state.data.status ==
            //               Order.arriveAtDestination.toString()) {
            //             dismissLoading();
            //           }
            //           if (state.data.status == Order.cancel.toString()) {
            //             // showToast(message: "Order cancelled by the user");
            //             await provider.clearState();
            //             var session = locator<Session>();
            //             session.setIsOrderRunning = false;
            //             session.setOrderUserId = 0;
            //             Navigator.pushNamedAndRemoveUntil(
            //               context,
            //               HomePage.routeName,
            //               (route) => false,
            //             );
            //           }

            //           if (state.data.status == Order.complete.toString()) {
            //             log("order complete called");
            //             trackingTimer!.cancel();
            //             timer.cancel();

            //             ///Clear the state and navigate driver to the rating screen
            //             await provider.clearState();
            //             var session = locator<Session>();
            //             session.setIsOrderRunning = false;
            //             session.setOrderUserId = 0;
            //             // Provider.of<ReceiptProvider>(context, listen: false)
            //             //     .getReceiptAPI();
            //             dismissLoading();
            //             Navigator.pushNamedAndRemoveUntil(
            //               context,
            //               ReceiptPage.routeName,
            //               (route) => false,
            //               arguments: RatingPageArguments(
            //                 customerDataModel: provider.customerDetail!.data,
            //                 customerId: provider.orderDetail!.userId,
            //               ),
            //             );

            //             // Navigator.pushNamedAndRemoveUntil(
            //             //   context,
            //             //   GiveRatingScreen.routeName,dsfgdfg
            //             //   (route) => false,
            //             //   arguments: RatingPageArguments(
            //             //     customerDataModel: provider.customerDetail!.data,
            //             //     customerId: provider.orderDetail!.userId,
            //             //   ),
            //             // );

            //             // showDialog(
            //             //   barrierDismissible: false,
            //             //   context: context,
            //             //   builder: (_) => WillPopScope(
            //             //     onWillPop: () async => false,
            //             //     child: MainDialog(
            //             //       isOrderDialog: false,
            //             //       customerDetailModel: provider.customerDetail,
            //             //       orderDetail: provider.orderDetail,
            //             //       deviceSize: _deviceSize,
            //             //       onEnd: () async {
            //             //         await provider.clearState();
            //             //         Navigator.pushNamedAndRemoveUntil(context,
            //             //             HomePage.routeName, (route) => false);
            //             //       },
            //             //     ),
            //             //   ),
            //             // );
            //           }
            //         }
            //       },
            //     );
            //   },
            // );

            return Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: orderProvider.kJapanCoordinate,
                  onMapCreated: (GoogleMapController controller) async {
                    orderProvider.googleMapController = controller;
                    await orderProvider.setCurrentLocation(
                      widget.orderDetail,
                      widget.customerDetail,
                    );
                  },
                  polylines: orderProvider.polylines,
                  markers: Set<Marker>.of(orderProvider.markers.values),
                ),
                SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ((session.orderStatus == 1) || (session.orderStatus == 2))
                          ? OriginWidget(
                              deviceWidth: deviceSize.width,
                              originAddress: widget.orderDetail.startAddress,
                            )
                          : DestinationWidget(
                              deviceWidth: deviceSize.width,
                              endAddress: widget.orderDetail.endAddress,
                            ),
                      // Column(
                      //   children: [
                      //     Text(
                      //         "Driver latlong realtime: ${provider.driverUpdatedLatLong}"),
                      //     // Text(
                      //     //     "Polyline is: ${provider.polylineCoordinates}"),
                      //   ],
                      // ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // const CurrentLocationOrderWidget(),
                            BottomContainerOrder(
                              newMessgeCount: socketProvider.unreadMessageCount,
                              currentOrderStatus: session.currentOrderState,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
