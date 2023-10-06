import 'dart:async';
import 'package:appkey_taxiapp_driver/core/presentation/pages/home_page/home_page.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/page/give_rating_screen.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/destination_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/origin_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/get_status_order_state.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/order_provider.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/widgets/bottom_container_order.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../../../../core/data/models/customer_detail_model.dart';
import '../../../../core/static/order_status.dart';
import '../../domain/entities/order_detail.dart';
import '../widgets/current_location_order.dart';

class OrderPageArguments {
  final OrderDetail orderDetail;
  final CustomerDetailModel customerDetailModel;
  final int orderStatus;

  OrderPageArguments({
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

class OrderPage extends StatefulWidget {
  final OrderDetail orderDetail;
  final CustomerDetailModel customerDetail;
  final int orderStatus;

  const OrderPage(
      {Key? key,
      required this.orderDetail,
      required this.customerDetail,
      required this.orderStatus})
      : super(key: key);
  static const routeName = '/OrderPage';

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with WidgetsBindingObserver {
  Timer? checkOrderStatusTimer, trackingTimer, updateLocationTimer;
  var orderPProvider = locator<OrderProvider>();
  late StreamSubscription<LocationData> locationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // setDefaultStatus(widget.orderStatus);
  }

  setDefaultStatus(int orderStatus) {
    logMe('Order already running -----> ${widget.orderStatus}');
    switch (orderStatus) {
      case Order.driverAccept:
        orderPProvider.changeOrderStatus = OrderStatus.driverAccept;
        return;
      case Order.departureToCustomerPlace:
        orderPProvider.changeOrderStatus = OrderStatus.departureToCustomerplace;
        return;
      case Order.arriveAtCustomerPlace:
        orderPProvider.changeOrderStatus = OrderStatus.arriveAtCustomerPlace;
        return;
      case Order.customerConfirmation:
        orderPProvider.changeOrderStatus = OrderStatus.customerConfirmation;
        return;
      case Order.departureToDestination:
        orderPProvider.changeOrderStatus = OrderStatus.departureToDestination;
        return;
      case Order.arriveAtDestination:
        orderPProvider.changeOrderStatus = OrderStatus.arriveAtDestination;
        return;
      case Order.complete:
        orderPProvider.changeOrderStatus = OrderStatus.complete;
        return;
      default:
        orderPProvider.changeOrderStatus = OrderStatus.driverAccept;
        return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    checkOrderStatusTimer?.cancel();
    trackingTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () {
        return Future.value(false); // if true allow back else block it
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: const CustomAppBar(
        //   centerTitle: false,
        // ),
        body: Consumer<OrderProvider>(
          builder: (context, provider, _) {
            if (checkOrderStatusTimer != null) {
              checkOrderStatusTimer!.cancel();
            }
            if (trackingTimer != null) {
              trackingTimer!.cancel();
            }

            trackingTimer = Timer.periodic(const Duration(seconds: 10),
                (Timer timer) async {
              provider.trackingDriver();
            });

            checkOrderStatusTimer = Timer.periodic(
              const Duration(seconds: 10),
              (Timer timer) async {
                provider.fetchOrderStatus().listen(
                  (state) async {
                    if (state is GetStatusOrderLoaded) {
                      var session = locator<Session>();
                      session.setCurrentOrderState =
                          int.parse(state.data.status);

                      // if (true) {
                      //   setDefaultStatus(int.parse(state.data.status));
                      // }

                      if (state.data.status ==
                          Order.customerConfirmation.toString()) {
                        provider.changeOrderStatus =
                            OrderStatus.customerConfirmation;
                      }
                      if (state.data.status ==
                          Order.arriveAtCustomerPlace.toString()) {
                        provider.changeOrderStatus =
                            OrderStatus.departureToDestination;
                      }
                      if (state.data.status ==
                          Order.arriveAtDestination.toString()) {
                        dismissLoading();
                      }
                      if (state.data.status == Order.cancel.toString()) {
                        showToast(message: "Order cancelled by the user");
                        await provider.clearState();
                        var session = locator<Session>();
                        session.setIsOrderRunning = false;
                        session.setOrderUserId = 0;
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          HomePage.routeName,
                          (route) => false,
                        );
                      }

                      if (state.data.status == Order.complete.toString()) {
                        dismissLoading();
                        trackingTimer!.cancel();
                        timer.cancel();

                        ///Clear the state and navigate driver to the rating screen
                        await provider.clearState();
                        var session = locator<Session>();
                        session.setIsOrderRunning = false;
                        session.setOrderUserId = 0;

                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          GiveRatingScreen.routeName,
                          (route) => false,
                          arguments: RatingPageArguments(
                            customerDataModel: provider.customerDetail!.data,
                            customerId: provider.orderDetail!.userId,
                          ),
                        );
                        // showDialog(
                        //   barrierDismissible: false,
                        //   context: context,
                        //   builder: (_) => WillPopScope(
                        //     onWillPop: () async => false,
                        //     child: MainDialog(
                        //       isOrderDialog: false,
                        //       customerDetailModel: provider.customerDetail,
                        //       orderDetail: provider.orderDetail,
                        //       deviceSize: _deviceSize,
                        //       onEnd: () async {
                        //         await provider.clearState();
                        //         Navigator.pushNamedAndRemoveUntil(context,
                        //             HomePage.routeName, (route) => false);
                        //       },
                        //     ),
                        //   ),
                        // );
                      }
                    }
                  },
                );
              },
            );
            return Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: provider.kJapanCoordinate,
                  onMapCreated: (GoogleMapController controller) async {
                    provider.googleMapController = controller;
                    await provider.setCurrentLocation(
                      widget.orderDetail,
                      widget.customerDetail,
                    );
                  },
                  polylines: provider.polylines,
                  markers: Set<Marker>.of(provider.markers.values),
                ),
                SafeArea(
                  child: Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          getStatus(provider.orderStatus)
                              ? OriginWidget(
                                  deviceWidth: _deviceSize.width,
                                )
                              : DestinationWidget(
                                  deviceWidth: _deviceSize.width,
                                ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                CurrentLocationOrderWidget(),
                                BottomContainerOrder()
                              ],
                            ),
                          ),
                        ],
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
