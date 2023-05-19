import 'dart:async';

import 'package:appkey_taxiapp_driver/core/data/models/customer_detail_model.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/bottom_container_home.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/current_location_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_app_bar.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_decline_dialog.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/destination_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/origin_widget.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/entities/order_detail.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/customer_detail_state.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/order_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../features/order/presentation/pages/order_page.dart';
import '../../../../features/order/presentation/providers/update_status_order_state.dart';
import '../../../static/order_status.dart';
import '../../../utility/firebase_helper.dart';
import '../../../utility/helper.dart';
import '../../../utility/injection.dart';
import '../../../utility/session_helper.dart';
import '../../providers/change_status_state.dart';
import '../../providers/fcm_provider.dart';
import '../../providers/home_provider.dart';
import '../../widgets/common_dialog.dart';
import '../../widgets/main_dialog.dart';
import '../../widgets/refused_order_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final FcmProvider _fcmProvider = locator<FcmProvider>();

  @override
  void initState() {
    super.initState();
    _fcmProvider.addListener(() async => await fcmListener());
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  fcmListener() async {
    final session = locator<Session>();
    logMe("incoming action: ${_fcmProvider.incomingOrderDetail}");
    var homeProvider = Provider.of<HomeProvider>(context, listen: false);

    homeProvider
        .fetchOrderDetail(_fcmProvider.incomingOrderDetail!.orderId)
        .listen((event) {
      if (event is OrderDetailLoaded) {
        var _deviceSize = MediaQuery.of(context).size;
        homeProvider
            .fetchCustomerDetail(event.data.userId.toString())
            .listen((event) async {
          if (event is CustomerDetailLoaded) {
            await showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => WillPopScope(
                      onWillPop: () async => false,
                      child: MainDialog(
                        customerDetailModel: homeProvider.customerDetailModel,
                        orderDetail: homeProvider.orderDetail,
                        deviceSize: _deviceSize,
                        onDecline: () async {
                          await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) => WillPopScope(
                                  onWillPop: () async => false,
                                  child:
                                      CustomDeclineDialog(positiveAction: () {
                                    homeProvider.changeStatus = false;
                                    homeProvider
                                        .updateStatus()
                                        .listen((event) async {
                                      if (event is ChangeStatusLoaded) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      }
                                    });
                                  })));
                        },
                        onAccept: () {
                          session.setOrderId =
                              _fcmProvider.incomingOrderDetail!.orderId;
                          homeProvider
                              .submitStatusOrder(Order.driverAccept)
                              .listen((event) async {
                            if (event is UpdateStatusOrderLoaded) {
                              if (event.data.success == 1) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    OrderPage.routeName, (route) => false,
                                    arguments: OrderPageArguments(
                                        orderDetail: homeProvider.orderDetail!,
                                        customerDetailModel:
                                            homeProvider.customerDetailModel!));
                              } else if (event.data.message == 5) {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (context) => CommonDialog(
                                    title: appLoc.sorry,
                                    msg: appLoc.orderacceptedotherdriver,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              } else if (event.data.message == 6) {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (context) => CommonDialog(
                                    title: appLoc.sorry,
                                    msg: appLoc.ordernotfound,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              } else if (event.data.message == 7) {
                                Navigator.of(context).pop();
                                showDialog(
                                  context: context,
                                  builder: (context) => CommonDialog(
                                    title: appLoc.sorry,
                                    msg: appLoc.orderhascancelled,
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              }
                            }
                          });
                        },
                      ),
                    ));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(false); // if true allow back else block it
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const CustomAppBar(
            centerTitle: false,
          ),
          body: Consumer<HomeProvider>(builder: (context, map, _) {
            return Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: map.kJapanCoordinate,
                  onMapCreated: (GoogleMapController controller) async {
                    map.googleMapController = controller;
                    await map.setCurrentLocation();
                    // }
                  },
                  polylines: map.polylines,
                  markers: Set<Marker>.of(map.markers.values),
                ),
                SafeArea(
                    child: Stack(children: [
                  Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                              CurrentLocationWidget(),
                              BottomContainerHome()
                            ]))
                      ])
                ]))
              ],
            );
          }),
        ));
  }
}
