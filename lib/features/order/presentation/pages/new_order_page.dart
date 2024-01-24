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
import '../widgets/bottom_container_order.dart';

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
  // Timer? checkOrderStatusTimer, trackingTimer, updateLocationTimer;
  // var orderPProvider = locator<OrderProvider>();
  var socketProvider = locator<LatestSocketProvider>();
  // var orderProvider = locator<OrderProvider>();

  var session = locator<Session>();

  // late StreamSubscription<LocationData> locationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // socketProvider.listenRequests();
    socketProvider.updateGetBytes();

    // socketProvider.getTotalUnreadCount(widget.customerDetail.id);

    // showLoading();
    session.setOrderId = widget.orderDetail.orderId.toString();
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
        socketProvider.setNewPolylineDirection(false);
      }
    });
    // orderProvider.setOrderDetails = widget.orderDetail;

    socketProvider.updateOrderData(data: widget.orderDetail);
    socketProvider.removeOrderFromList(orderId: widget.orderDetail.orderId);
    socketProvider.getCurrentLocation();
    log("current order status is :-->> ${widget.orderStatus}");
    log("current order status is on order page init :-->> ${widget.orderStatus}");
    log("order details :-->> ${widget.orderDetail}");
    log("customer detals :-->> ${widget.customerDetail}");
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
                          ((session.orderStatus == 1) ||
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
                                BottomContainerOrder(
                                  newMessgeCount:
                                      socketProvider.unreadMessageCount,
                                  currentOrderStatus: session.currentOrderState,
                                ),
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
