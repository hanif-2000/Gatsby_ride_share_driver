import 'dart:async';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_app_bar.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/destination_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/origin_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/get_status_order_state.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/order_provider.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/widgets/bottom_container_order.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../core/data/models/customer_detail_model.dart';
import '../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../core/presentation/widgets/main_dialog.dart';
import '../../../../core/static/order_status.dart';
import '../../domain/entities/order_detail.dart';
import '../widgets/current_location_order.dart';

class OrderPageArguments {
  final OrderDetail orderDetail;
  final CustomerDetailModel customerDetailModel;

  OrderPageArguments({
    required this.orderDetail,
    required this.customerDetailModel,
  });
}

class OrderPage extends StatefulWidget {
  final OrderDetail orderDetail;
  final CustomerDetailModel customerDetail;

  const OrderPage(
      {Key? key, required this.orderDetail, required this.customerDetail})
      : super(key: key);
  static const routeName = '/OrderPage';

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with WidgetsBindingObserver {
  Timer? checkOrderStatusTimer, trackingTimer, updateLocationTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    checkOrderStatusTimer?.cancel();
    trackingTimer?.cancel();
    WidgetsBinding.instance!.removeObserver(this);
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

            trackingTimer =
                Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
              provider.trackingDriver();
            });

            checkOrderStatusTimer = Timer.periodic(
              const Duration(seconds: 3),
              (Timer timer) async {
                provider.fetchOrderStatus().listen(
                  (state) async {
                    if (state is GetStatusOrderLoaded) {
                      if (state.data.status ==
                          Order.customerConfirmation.toString()) {
                        provider.changeOrderStatus =
                            OrderStatus.customerConfirmation;
                      }

                      if (state.data.status == Order.complete.toString()) {
                        dismissLoading();
                        trackingTimer!.cancel();
                        timer.cancel();
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => WillPopScope(
                            onWillPop: () async => false,
                            child: MainDialog(
                              isOrderDialog: false,
                              customerDetailModel: provider.customerDetail,
                              orderDetail: provider.orderDetail,
                              deviceSize: _deviceSize,
                              onEnd: () async {
                                await provider.clearState();
                                Navigator.pushNamedAndRemoveUntil(context,
                                    HomePage.routeName, (route) => false);
                              },
                            ),
                          ),
                        );
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
                        widget.orderDetail, widget.customerDetail);
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
                                // CurrentLocationOrderWidget(),
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
