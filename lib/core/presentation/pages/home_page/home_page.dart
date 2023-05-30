import 'dart:async';
import 'package:appkey_taxiapp_driver/core/presentation/pages/menu_page.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_app_bar.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_decline_dialog.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/no_projects.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/dimens.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/customer_detail_state.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/order_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../features/order/presentation/pages/order_page.dart';
import '../../../../features/order/presentation/providers/update_status_order_state.dart';
import '../../../static/order_status.dart';
import '../../../utility/helper.dart';
import '../../../utility/injection.dart';
import '../../../utility/session_helper.dart';
import '../../providers/change_status_state.dart';
import '../../providers/fcm_provider.dart';
import '../../providers/home_provider.dart';
import '../../widgets/common_dialog.dart';
import '../../widgets/main_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final FcmProvider _fcmProvider = locator<FcmProvider>();

  // var homeProvider = Provider.of<HomeProvider>(context, listen: false);
  var homeProvider = locator<HomeProvider>();

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


    homeProvider
        .fetchOrderDetail(_fcmProvider.incomingOrderDetail!.orderId)
        .listen(
          (event) {
        if (event is OrderDetailLoaded) {
          var _deviceSize = MediaQuery
              .of(context)
              .size;
          homeProvider.fetchCustomerDetail(event.data.userId.toString()).listen(
                (event) async {
              if (event is CustomerDetailLoaded) {
                await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) =>
                      WillPopScope(
                        onWillPop: () async => false,
                        child: MainDialog(
                          customerDetailModel: homeProvider.customerDetailModel,
                          orderDetail: homeProvider.orderDetail,
                          deviceSize: _deviceSize,
                          onDecline: () async {
                            await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) =>
                                  WillPopScope(
                                    onWillPop: () async => false,
                                    child: CustomDeclineDialog(
                                      positiveAction: () {
                                        homeProvider.changeStatus = false;
                                        homeProvider.updateStatus().listen(
                                              (event) async {
                                            if (event is ChangeStatusLoaded) {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                            );
                          },
                          onAccept: () {
                            session.setOrderId =
                                _fcmProvider.incomingOrderDetail!.orderId;
                            homeProvider
                                .submitStatusOrder(Order.driverAccept)
                                .listen(
                                  (event) async {
                                if (event is UpdateStatusOrderLoaded) {
                                  if (event.data.success == 1) {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      OrderPage.routeName,
                                          (route) => false,
                                      arguments: OrderPageArguments(
                                        orderDetail: homeProvider.orderDetail!,
                                        customerDetailModel:
                                        homeProvider.customerDetailModel!,
                                      ),
                                    );
                                  } else if (event.data.message == 5) {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          CommonDialog(
                                            title: appLoc.sorry,
                                            msg: appLoc
                                                .orderacceptedotherdriver,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                    );
                                  } else if (event.data.message == 6) {
                                    Navigator.of(context).pop();
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          CommonDialog(
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
                                      builder: (context) =>
                                          CommonDialog(
                                            title: appLoc.sorry,
                                            msg: appLoc.orderhascancelled,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                    );
                                  }
                                }
                              },
                            );
                          },
                        ),
                      ),
                );
              }
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false); // if true allow back else block it
      },
      child: Scaffold(
        key: homeProvider.globalKey,
        resizeToAvoidBottomInset: false,
        appBar: const CustomAppBar(
          centerTitle: true,
        ),
        drawer: const HomeDrawerPage(),
        body: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            return Column(
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

                const NoProjects(),

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
