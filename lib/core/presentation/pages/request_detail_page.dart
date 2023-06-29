import 'package:appkey_taxiapp_driver/core/data/models/request_list_model.dart';
import 'package:appkey_taxiapp_driver/core/presentation/pages/other_user_profile.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/reject_request_state.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/common_dialog.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/reject_reason_bottom_sheet.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/show_bottom_sheet.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/order_status.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/pages/order_page.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/update_status_order_state.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/customer_detail_state.dart';
import 'package:appkey_taxiapp_driver/features/profile/presentation/providers/order_detail_state.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/page/rating_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class RequestDetailPage extends StatefulWidget {
  const RequestDetailPage({Key? key, this.requestListModel}) : super(key: key);
  final RequestListModel? requestListModel;

  @override
  State<RequestDetailPage> createState() => _RequestDetailPageState();
}

class _RequestDetailPageState extends State<RequestDetailPage> {
  // final provider = locator<HomeProvider>();

  @override
  void initState() {
    super.initState();
  }

  loadPolyline() async {
    logMe('Start ---> ${widget.requestListModel!.startCoordinate}');
    logMe('end ---> ${widget.requestListModel!.endCoordinate}');

    // final pickup = LatLng(
    //     double.tryParse(
    //         widget.requestListModel!.startCoordinate.split(',').first)!,
    //     double.tryParse(
    //         widget.requestListModel!.startCoordinate.split(',').last)!);
    // final drop = LatLng(
    //     double.tryParse(
    //         widget.requestListModel!.endCoordinate.split(',').first)!,
    //     double.tryParse(
    //         widget.requestListModel!.endCoordinate.split(',').last)!);
    //
    // await provider.createPickupAndDropMarker(pickup, drop);
    // await provider.setPolylineDirection(pickup, drop);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          // appBar: const CustomAppBar(
          //   centerTitle: false,
          // ),
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  // myLocationEnabled: true,
                  mapType: MapType.normal,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: homeProvider.kJapanCoordinate,
                  onMapCreated: (GoogleMapController controller) async {
                    homeProvider.googleMapController = controller;
                    final pickup = LatLng(
                        double.tryParse(widget.requestListModel!.startCoordinate
                            .split(',')
                            .first)!,
                        double.tryParse(widget.requestListModel!.startCoordinate
                            .split(',')
                            .last)!);
                    final drop = LatLng(
                        double.tryParse(widget.requestListModel!.endCoordinate
                            .split(',')
                            .first)!,
                        double.tryParse(widget.requestListModel!.endCoordinate
                            .split(',')
                            .last)!);

                    await homeProvider.createPickupAndDropMarker(pickup, drop);
                    await homeProvider.setPolylineDirection(pickup, drop);
                  },
                  polylines: homeProvider.polylines,
                  markers: Set<Marker>.of(homeProvider.markers.values),
                ),
                Stack(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 0,
                          ),
                          child: GestureDetector(
                            onTap: () {},
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              // height: 60,
                              child: Container(
                                margin: const EdgeInsets.all(0),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 13,
                                ),
                                decoration: const BoxDecoration(
                                  color: whiteColor,
                                  // borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(Icons.arrow_back),
                                          )),
                                      mediumHorizontalSpacing(),
                                      Column(
                                        children: [
                                          const Icon(
                                            Icons.my_location,
                                            color: Colors.black,
                                            size: 30,
                                          ),
                                          Image.asset(
                                            'assets/icons/home/ic_line.png',
                                            height: 60,
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(0, 5),
                                                  blurRadius: 12,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.16),
                                                )
                                              ],
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/icons/order/ic_location.svg',
                                              height: 30,
                                              width: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'PICK UP',
                                                        softWrap: false,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: greyC8C7CC,
                                                        ),
                                                      ),
                                                      Text(
                                                        widget.requestListModel!
                                                            .startAddress,
                                                        softWrap: false,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                            largeVerticalSpacing(),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'DROP-OFF',
                                                        softWrap: false,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          color: greyC8C7CC,
                                                        ),
                                                      ),
                                                      Text(
                                                        widget.requestListModel!
                                                            .endAddress,
                                                        softWrap: false,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  // color: const Color.fromRGBO(0, 0, 0, 0.2),
                                  color: whiteColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                OtherUserProfile.routeName);
                                          },
                                          child: Container(
                                            height: 45,
                                            width: 45,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: redD03B3B,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    '$BASE_URL${widget.requestListModel!.image}',
                                                  ),
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                        ),
                                        mediumHorizontalSpacing(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${widget.requestListModel!.firstName} ${widget.requestListModel!.lastName}',
                                              textAlign: TextAlign.center,
                                              style: titleStyle
                                                  .copyWith(
                                                    fontSize: 16,
                                                  )
                                                  .usePoppinsW5Font(),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                    RatingListPage.routeName,
                                                    arguments: widget
                                                        .requestListModel!
                                                        .customerId);
                                                // context,
                                                // GiveRatingScreen.routeName);
                                              },
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/home/ic_start.svg'),
                                                  smallHorizontalSpacing(),
                                                  Text(
                                                    '${widget.requestListModel!.rating}',
                                                    textAlign: TextAlign.center,
                                                    style: titleStyle
                                                        .copyWith(
                                                          fontSize: 14,
                                                        )
                                                        .usePoppinsW6Font(),
                                                  ),
                                                  smallHorizontalSpacing(),
                                                  Text(
                                                    'Reviews',
                                                    textAlign: TextAlign.center,
                                                    style: titleStyle
                                                        .copyWith(
                                                          fontSize: 14,
                                                          color: yellowE5A829,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                        )
                                                        .usePoppinsW5Font(),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        Column(
                                          children: [
                                            Text(
                                              '\$${widget.requestListModel!.total.toStringAsFixed(0)}',
                                              textAlign: TextAlign.center,
                                              style: titleStyle
                                                  .copyWith(
                                                    fontSize: 16,
                                                  )
                                                  .usePoppinsW6Font(),
                                            ),
                                            Text(
                                              '${widget.requestListModel!.distance} Km',
                                              textAlign: TextAlign.center,
                                              style: titleStyle
                                                  .copyWith(
                                                    fontSize: 14,
                                                    color: greyB6B6B6,
                                                  )
                                                  .usePoppinsW5Font(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    largeVerticalSpacing(),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            text: Text(
                                              'Reject',
                                              style: txtButtonStyle,
                                            ),
                                            event: () {
                                              ///Reject the request
                                              CustomBottomSheet.showBottomSheet(
                                                context,
                                                RejectReasonBottomSheet(
                                                  reject: (reason) {
                                                    ///send reason to the server
                                                    homeProvider
                                                        .rejectRequest(
                                                            widget
                                                                .requestListModel!
                                                                .id
                                                                .toString(),
                                                            reason)
                                                        .listen(
                                                      (event) {
                                                        if (event
                                                            is RejectRequestLoaded) {
                                                          final data =
                                                              event.data;
                                                          var socketProvider =
                                                              locator<
                                                                  SocketProvider>();
                                                          socketProvider
                                                              .rejectRequestSocket();
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.pop(
                                                              context);
                                                          showToast(
                                                            message:
                                                                data.message,
                                                          );
                                                        }
                                                      },
                                                    );

                                                    ///
                                                  },
                                                ),
                                              );
                                            },
                                            buttonHeight: 48,
                                            isRounded: true,
                                            bgColor: redD03B3B,
                                          ),
                                        ),
                                        smallHorizontalSpacing(),
                                        Expanded(
                                          child: CustomButton(
                                            text: Text(
                                              'Accept',
                                              style: txtButtonStyle,
                                            ),
                                            event: () {
                                              final session =
                                                  locator<Session>();
                                              homeProvider
                                                  .fetchOrderDetail(widget
                                                      .requestListModel!.id
                                                      .toString())
                                                  .listen(
                                                (event1) {
                                                  if (event1
                                                      is OrderDetailLoaded) {
                                                    // var _deviceSize = MediaQuery.of(context).size;
                                                    session.setRunningOrderId =
                                                        widget.requestListModel!
                                                            .id;
                                                    session.setOrderId = widget
                                                        .requestListModel!.id
                                                        .toString();
                                                    homeProvider
                                                        .fetchCustomerDetail(
                                                            event1.data.userId
                                                                .toString())
                                                        .listen(
                                                      (event) async {
                                                        if (event
                                                            is CustomerDetailLoaded) {
                                                          session.setOrderUserId =
                                                              event1
                                                                  .data.userId;
                                                          print(
                                                              'RUNNING order id --> ${widget.requestListModel!.id}');
                                                          homeProvider
                                                              .submitStatusOrder(
                                                                  Order
                                                                      .driverAccept)
                                                              .listen(
                                                            (event) async {
                                                              if (event
                                                                  is UpdateStatusOrderLoaded) {
                                                                if (event.data
                                                                        .success ==
                                                                    1) {
                                                                  // var session =
                                                                  //     locator<Session>();
                                                                  session.setIsOrderRunning =
                                                                      true;
                                                                  var socketProvider =
                                                                      locator<
                                                                          SocketProvider>();
                                                                  socketProvider
                                                                      .acceptRequestSocket();
                                                                  Navigator
                                                                      .pushNamedAndRemoveUntil(
                                                                    context,
                                                                    OrderPage
                                                                        .routeName,
                                                                    (route) =>
                                                                        false,
                                                                    arguments: OrderPageArguments(
                                                                        orderDetail:
                                                                            homeProvider
                                                                                .orderDetail!,
                                                                        customerDetailModel:
                                                                            homeProvider
                                                                                .customerDetailModel!,
                                                                        orderStatus: event1
                                                                            .data
                                                                            .orderStatus),
                                                                  );
                                                                } else if (event
                                                                        .data
                                                                        .message ==
                                                                    5) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            CommonDialog(
                                                                      title: appLoc
                                                                          .sorry,
                                                                      msg: appLoc
                                                                          .orderacceptedotherdriver,
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  );
                                                                } else if (event
                                                                        .data
                                                                        .message ==
                                                                    6) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            CommonDialog(
                                                                      title: appLoc
                                                                          .sorry,
                                                                      msg: appLoc
                                                                          .ordernotfound,
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  );
                                                                } else if (event
                                                                        .data
                                                                        .message ==
                                                                    7) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) =>
                                                                            CommonDialog(
                                                                      title: appLoc
                                                                          .sorry,
                                                                      msg: appLoc
                                                                          .orderhascancelled,
                                                                      onTap:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                    ),
                                                                  );
                                                                }
                                                              }
                                                            },
                                                          );
                                                        }
                                                      },
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                            buttonHeight: 48,
                                            isRounded: true,
                                            bgColor: green2DAA5F,
                                          ),
                                        ),
                                      ],
                                    ),
                                    smallVerticalSpacing(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
