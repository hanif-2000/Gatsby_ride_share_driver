import 'dart:convert';
import 'dart:developer';
import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../core/data/models/customer_detail_model.dart';
import '../../../../core/presentation/widgets/button_order.dart';
import '../../../../core/presentation/widgets/destination_widget.dart';
import '../../../../core/presentation/widgets/origin_widget.dart';
import '../../domain/entities/order_detail.dart';
import '../widgets/current_location_order.dart';

class NewOrderPageArguments {
  final OrderDetail orderDetail;
  final CustomerDataModel customerDetailModel;
  final int orderStatus;
  // final dynamic orderTotal;

  NewOrderPageArguments({
    required this.orderDetail,
    required this.customerDetailModel,
    required this.orderStatus,
    // required this.orderTotal,
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
  final dynamic orderTotal;

  const NewOrderPage(
      {Key? key,
      required this.orderDetail,
      required this.customerDetail,
      required this.orderTotal,
      required this.orderStatus})
      : super(key: key);
  static const routeName = '/OrderPage';

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage>
    with WidgetsBindingObserver {
  var socketProvider = Provider.of<LatestSocketProvider>(
      locator<GlobalKey<NavigatorState>>().currentContext!);
  var session = locator<Session>();

  checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      log("==============$connectivityResult");
      // I am connected to a mobile network.
    } else if (connectivityResult == ConnectivityResult.wifi) {
      log("==============$connectivityResult");

      // I am connected to a wifi network.
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      log("==============$connectivityResult");

      // I am connected to a ethernet network.
    } else if (connectivityResult == ConnectivityResult.vpn) {
      log("==============$connectivityResult");

      // I am connected to a vpn network.
      // Note for iOS and macOS:
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      log("==============$connectivityResult");

      // I am connected to a bluetooth.
    } else if (connectivityResult == ConnectivityResult.other) {
      log("==============$connectivityResult");

      // I am connected to a network which is not in the above mentioned networks.
    } else if (connectivityResult == ConnectivityResult.none) {
      log("==============$connectivityResult");

      // I am not connected to any network.
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // socketProvider.listenRequests();
    socketProvider.updateGetBytes();
    socketProvider.getTotalUnreadCount(session.customerId);
    var subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      log("-----------------------RESULT IS :----$result");
      // Got a new connectivity status!
    }); // socketProvider.getTotalUnreadCount(widget.customerDetail.id);

    // showLoading();
    // session.setOrderId = widget.orderDetail.orderId.toString();

    log("new order page order details:->> ${widget.orderDetail}");
    log("new order page customer details:->> ${widget.customerDetail}");

    // orderProvider.setOrderDetails = widget.orderDetail;

    socketProvider.getCurrentLocation();
    log("current order status is :-->> ${widget.orderStatus}");
    log("current order status is on order page init :-->> ${widget.orderStatus}");
    log("order details :-->> ${(widget.orderDetail)}");
    log("order details encode:-->> ${json.encode(widget.orderDetail)}");

    log("customer detals :-->> ${widget.customerDetail}");
    log("customer detals encode :-->> ${json.encode(widget.customerDetail)}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      socketProvider.updateOrderData(data: widget.orderDetail);

      socketProvider.updateCurrentStatus(status: session.runningOrderStatus);
      socketProvider.updateOrderData(data: widget.orderDetail);
      // session.setOrderDetails = json.encode(widget.orderDetail);

      session.setCustomerName = widget.customerDetail.name;
      session.setCustomerImg = widget.customerDetail.photo ?? '';
      session.setCustomerRating = widget.customerDetail.rating.toString();
      session.setCustomerPhn = widget.customerDetail.phoneNumber;
      session.setStartAdd = widget.orderDetail.startAddress;
      session.setEndAdd = widget.orderDetail.endAddress;
      session.setStartCo = widget.orderDetail.startCoordinate;
      session.setEndCo = widget.orderDetail.endCoordinate;

      // session.setCustomerDetails = json.encode(widget.customerDetail);

      socketProvider.updateCustomerAndRideDetails(
        name: widget.customerDetail.name,
        rating: widget.customerDetail.rating.toString(),
        newTotal: widget.orderDetail.newTotal.toString(),
        profilePic: widget.customerDetail.photo!,
        distance: widget.orderDetail.distance.toString(),
      );

      socketProvider
          .updateCustomerData(
              data: CustomerDataModel(
                  name: widget.customerDetail.name,
                  phoneNumber: widget.customerDetail.phoneNumber,
                  photo: widget.customerDetail.photo,
                  id: widget.customerDetail.id,
                  rating: widget.customerDetail.rating))
          .then((value) {
        if (value) {
          if ((session.runningOrderStatus == 0) ||
              (session.runningOrderStatus == 1) ||
              (session.runningOrderStatus == 2)) {
            socketProvider.setNewPolylineDirection(false);
          } else {
            socketProvider.setNewPolylineDirection(true);
          }

          /** update ride text */

          if ((session.runningOrderStatus == 1) ||
              session.runningOrderStatus == 0) {
            socketProvider.updateRideText(txt: "Start Ride to Customer Place");
          } else if (session.runningOrderStatus == 2) {
            socketProvider.updateRideText(txt: "Reached to Customer Place");
          } else if (session.runningOrderStatus == 3) {
            socketProvider.updateRideText(txt: "Start Trip");
          } else if (session.runningOrderStatus == 5) {
            socketProvider.updateRideText(txt: "End Trip");
          } else {
            log("*---************--------*********** RUNNING ORDER STATUS IS :-->> ${session.runningOrderStatus} *******------------->>>>>");
            socketProvider.updateRideText(txt: "Go to Receipt Screen");
          }
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // checkOrderStatusTimer?.cancel();
    // trackingTimer?.cancel();
    // WidgetsBinding.instance.removeObserver(this);
    socketProvider.removeOrderFromList(orderId: widget.orderDetail.orderId);
  }

  @override
  Widget build(BuildContext context) {
    log("order page build widget called");

    log("session order status ${session.currentOrderState}");

    var deviceSize = MediaQuery.of(context).size;
    return PopScope(
        canPop: false,
        child: Consumer<LatestSocketProvider>(
          builder: (context, LatestSocketProvider socketProvider, _) {
            return Scaffold(
                resizeToAvoidBottomInset: false,
                body: Stack(
                  children: <Widget>[
                    GoogleMap(
                      mapType: MapType.normal,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: true,
                      initialCameraPosition: socketProvider.kJapanCoordinate,
                      onMapCreated: (GoogleMapController controller) async {
                        socketProvider.googleMapController = controller;
                        await socketProvider.setCurrentLocation(
                          widget.orderDetail,
                          widget.customerDetail,
                        );
                      },
                      polylines: socketProvider.newPolylines,
                      markers: Set<Marker>.of(socketProvider.markers.values),
                    ),
                    SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          ((session.orderStatus == 0) ||
                                  (session.orderStatus == 1) ||
                                  (session.orderStatus == 2))
                              ? OriginWidget(
                                  deviceWidth: deviceSize.width,
                                  originAddress:
                                      widget.orderDetail.startAddress,
                                )
                              : DestinationWidget(
                                  deviceWidth: deviceSize.width,
                                  endAddress: widget.orderDetail.endAddress,
                                ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const CurrentLocationOrderWidget(),
                                ButtonOrder(
                                    currentOrderStatus:
                                        socketProvider.currentOrderStatus,
                                    newMessgeCount:
                                        socketProvider.unreadMessageCount),
                                // BottomContainerOrder(
                                //   newMessgeCount:
                                //       socketProvider.unreadMessageCount,
                                //   currentOrderStatus: session.currentOrderState,
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));
          },
        ));
  }
}
