// import 'dart:async';
// import 'dart:developer';
// import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
// import 'package:appkey_taxiapp_driver/core/presentation/widgets/destination_widget.dart';
// import 'package:appkey_taxiapp_driver/core/presentation/widgets/origin_widget.dart';
// import 'package:appkey_taxiapp_driver/core/static/enums.dart';
// import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
// import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
// import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
// import 'package:appkey_taxiapp_driver/features/order/presentation/providers/get_status_order_state.dart';
// import 'package:appkey_taxiapp_driver/features/order/presentation/providers/order_provider.dart';
// import 'package:appkey_taxiapp_driver/features/order/presentation/widgets/bottom_container_order.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'package:provider/provider.dart';
// import '../../../../core/data/models/customer_detail_model.dart';
// import '../../../../core/presentation/pages/home_page/home_page.dart';
// import '../../../../core/static/order_status.dart';
// import '../../../receipt/persentation/pages/receipt_page.dart';
// import '../../domain/entities/order_detail.dart';
// import '../widgets/current_location_order.dart';

// class OrderPageArguments {
//   final OrderDetail orderDetail;
//   final CustomerDetailModel customerDetailModel;
//   final int orderStatus;

//   OrderPageArguments({
//     required this.orderDetail,
//     required this.customerDetailModel,
//     required this.orderStatus,
//   });
// }

// class RatingPageArguments {
//   final CustomerDataModel customerDataModel;
//   final int? customerId;

//   RatingPageArguments({
//     required this.customerDataModel,
//     required this.customerId,
//   });
// }

// class OrderPage extends StatefulWidget {
//   final OrderDetail orderDetail;
//   final CustomerDetailModel customerDetail;
//   final int orderStatus;

//   const OrderPage(
//       {Key? key,
//       required this.orderDetail,
//       required this.customerDetail,
//       required this.orderStatus})
//       : super(key: key);
//   static const routeName = '/OrderPage';

//   @override
//   State<OrderPage> createState() => _OrderPageState();
// }

// class _OrderPageState extends State<OrderPage> with WidgetsBindingObserver {
//   Timer? checkOrderStatusTimer, trackingTimer, updateLocationTimer;
//   var orderPProvider = locator<OrderProvider>();
//   var socketProvider = locator<LatestSocketProvider>();

//   late StreamSubscription<LocationData> locationSubscription;

//   @override
//   void initState() {
//     // socketProvider.connectToSocket();
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     // socketProvider.listenRequests();

//     socketProvider.getTotalUnreadCount(widget.customerDetail.data.id);

//     showLoading();

//     log("current order status is :-->> ${widget.orderStatus}");
//     log("current order status is on order page init :-->> ${widget.orderStatus}");

//     // WidgetsBinding.instance.addPostFrameCallback((_) {
//     //   if (widget.orderStatus == 1) {
//     //     orderPProvider.changeOrderStatus = OrderStatus.driverAccept;
//     //     log("current status is DEPARTURE TO CUSTOMER");
//     //   }
//     //   if (widget.orderStatus == 2) {
//     //     orderPProvider.changeOrderStatus = OrderStatus.departureToCustomerplace;

//     //     log("current status is ARRIVE AT CUSTOMER PLACE");
//     //   }
//     //   if (widget.orderStatus == 3) {
//     //     orderPProvider.changeOrderStatus = OrderStatus.arriveAtCustomerPlace;

//     //     log("current status is DEPARTURE TO DESTINATION");
//     //   }
//     //   if (widget.orderStatus == 5) {
//     //     orderPProvider.changeOrderStatus = OrderStatus.departureToDestination;

//     //     log("current status is ARRIVE AT DESTINATION");
//     //   }

//     //   dismissLoading();

//     //   // setDefaultStatus(widget.orderStatus);
//     // });

//     // setDefaultStatus(int orderStatus) {
//     //   logMe('Order already running -----> ${widget.orderStatus}');
//     //   switch (orderStatus) {
//     //     case Order.driverAccept:
//     //       orderPProvider.changeOrderStatus = OrderStatus.driverAccept;
//     //       return;
//     //     case Order.departureToCustomerPlace:
//     //       orderPProvider.changeOrderStatus = OrderStatus.departureToCustomerplace;
//     //       return;
//     //     case Order.arriveAtCustomerPlace:
//     //       orderPProvider.changeOrderStatus = OrderStatus.arriveAtCustomerPlace;
//     //       return;
//     //     // case Order.customerConfirmation:
//     //     //   orderPProvider.changeOrderStatus = OrderStatus.customerConfirmation;
//     //     //   return;
//     //     case Order.departureToDestination:
//     //       orderPProvider.changeOrderStatus = OrderStatus.departureToDestination;
//     //       return;
//     //     case Order.arriveAtDestination:
//     //       orderPProvider.changeOrderStatus = OrderStatus.arriveAtDestination;
//     //       return;
//     //     case Order.complete:
//     //       orderPProvider.changeOrderStatus = OrderStatus.complete;
//     //       return;
//     //     default:
//     //       // orderPProvider.changeOrderStatus = OrderStatus.driverAccept;
//     //       return;
//     //   }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     checkOrderStatusTimer?.cancel();
//     trackingTimer?.cancel();
//     WidgetsBinding.instance.removeObserver(this);
//   }

//   @override
//   Widget build(BuildContext context) {
//     log("order page build widget called");
//     var session = locator<Session>();
//     var orderProvider = locator<OrderProvider>();

//     log("session order status ${session.currentOrderState}");
//     // orderPProvider.updateOrderStatusAfterAppRestart(
//     //     orderStatus: session.currentOrderState);

//     //   if(session.orderStatus==1){
//     //  orderProvider. changeOrderStatus=OrderStatus.}

//     // orderProvider.updateOrderStatusAfterAppRestart(
//     //     orderStatus: session.currentOrderState);

//     var deviceSize = MediaQuery.of(context).size;
//     return WillPopScope(
//       onWillPop: () {
//         return Future.value(false); // if true allow back else block it
//       },
//       child: Scaffold(
//         resizeToAvoidBottomInset: false,
//         // appBar: const CustomAppBar(
//         //   centerTitle: false,
//         // ),
//         body: Consumer<OrderProvider>(
//           builder: (context, provider, _) {
//             if (checkOrderStatusTimer != null) {
//               checkOrderStatusTimer!.cancel();
//             }
//             if (trackingTimer != null) {
//               trackingTimer!.cancel();
//             }
//             trackingTimer =
//                 Timer.periodic(const Duration(seconds: 5), (Timer timer) async {
//               await provider.trackingDriver();
//             });

//             checkOrderStatusTimer = Timer.periodic(
//               const Duration(seconds: 5),
//               (Timer timer) async {
//                 log("------>>>>>  this will called every 3 seconds  <<<<<--------");
//                 provider.fetchOrderStatus().listen(
//                   (state) async {
//                     if (state is GetStatusOrderLoaded) {
//                       session.setCurrentOrderState =
//                           int.parse(state.data.status);

//                       // provider.updateOrderStatusAfterAppRestart(
//                       //     orderStatus: int.parse(state.data.status));

//                       log("curent SAVED order Status is::-->>  ${session.currentOrderState}");

//                       log("current order state is::==>> ${state.data.status}");

//                       log("current order state is check order value string or int is-->>  ${Order.departureToCustomerPlace}");
//                       if (state.data.status == Order.driverAccept.toString()) {
//                         log("current status is DRIVER ACCEPT ");
//                       }

//                       if (state.data.status ==
//                           Order.departureToCustomerPlace.toString()) {
//                         log("current status is DEPARTURE TO CUSTOMER");
//                       } else if (state.data.status ==
//                           OrderStatus.arriveAtCustomerPlace.toString()) {
//                         log("current status is ARRIVE AT CUSTOMER PLACE");
//                       } else if (state.data.status ==
//                           OrderStatus.departureToDestination.toString()) {
//                         log("current status is DEPARTURE TO DESTINATION");
//                       } else if (state.data.status ==
//                           OrderStatus.arriveAtDestination.toString()) {
//                         log("current status is ARRIVE AT DESTINATION");
//                       }

//                       // if (state.data.status ==
//                       //     Order.departureToCustomerPlace.toString()) {
//                       //   provider.changeOrderStatus =
//                       //       OrderStatus.departureToDestination;
//                       // }

//                       // if (true) {
//                       //   setDefaultStatus(int.parse(state.data.status));
//                       // }

//                       // if (state.data.status ==
//                       //     Order.customerConfirmation.toString()) {
//                       //   provider.changeOrderStatus =
//                       //       OrderStatus.customerConfirmation;
//                       // }

//                       // if (state.data.status ==
//                       //     Order.departureToCustomerPlace.toString()) {
//                       //   provider.changeOrderStatus =
//                       //       OrderStatus.departureToCustomerplace;
//                       // }
//                       // if (state.data.status ==
//                       //     Order.arriveAtCustomerPlace.toString()) {
//                       //   provider.changeOrderStatus =
//                       //       OrderStatus.arriveAtCustomerPlace;
//                       // }

//                       if (state.data.status ==
//                           Order.departureToDestination.toString()) {
//                         provider.changeOrderStatus =
//                             OrderStatus.departureToDestination;
//                       }
//                       if (state.data.status ==
//                           Order.arriveAtDestination.toString()) {
//                         dismissLoading();
//                       }
//                       if (state.data.status == Order.cancel.toString()) {
//                         // showToast(message: "Order cancelled by the user");
//                         await provider.clearState();
//                         var session = locator<Session>();
//                         session.setIsOrderRunning = false;
//                         session.setOrderUserId = 0;
//                         Navigator.pushNamedAndRemoveUntil(
//                           context,
//                           HomePage.routeName,
//                           (route) => false,
//                         );
//                       }

//                       if (state.data.status == Order.complete.toString()) {
//                         log("order complete called");
//                         trackingTimer!.cancel();
//                         timer.cancel();

//                         ///Clear the state and navigate driver to the rating screen
//                         await provider.clearState();
//                         var session = locator<Session>();
//                         session.setIsOrderRunning = false;
//                         session.setOrderUserId = 0;
//                         // Provider.of<ReceiptProvider>(context, listen: false)
//                         //     .getReceiptAPI();
//                         dismissLoading();
//                         Navigator.pushNamedAndRemoveUntil(
//                           context,
//                           ReceiptPage.routeName,
//                           (route) => false,
//                           arguments: RatingPageArguments(
//                             customerDataModel: provider.customerDetail!.data,
//                             customerId: provider.orderDetail!.userId,
//                           ),
//                         );

//                         // Navigator.pushNamedAndRemoveUntil(
//                         //   context,
//                         //   GiveRatingScreen.routeName,dsfgdfg
//                         //   (route) => false,
//                         //   arguments: RatingPageArguments(
//                         //     customerDataModel: provider.customerDetail!.data,
//                         //     customerId: provider.orderDetail!.userId,
//                         //   ),
//                         // );

//                         // showDialog(
//                         //   barrierDismissible: false,
//                         //   context: context,
//                         //   builder: (_) => WillPopScope(
//                         //     onWillPop: () async => false,
//                         //     child: MainDialog(
//                         //       isOrderDialog: false,
//                         //       customerDetailModel: provider.customerDetail,
//                         //       orderDetail: provider.orderDetail,
//                         //       deviceSize: _deviceSize,
//                         //       onEnd: () async {
//                         //         await provider.clearState();
//                         //         Navigator.pushNamedAndRemoveUntil(context,
//                         //             HomePage.routeName, (route) => false);
//                         //       },
//                         //     ),
//                         //   ),
//                         // );
//                       }
//                     }
//                   },
//                 );
//               },
//             );

//             return Stack(
//               children: <Widget>[
//                 GoogleMap(
//                   mapType: MapType.normal,
//                   myLocationButtonEnabled: false,
//                   zoomControlsEnabled: false,
//                   initialCameraPosition: provider.kJapanCoordinate,
//                   onMapCreated: (GoogleMapController controller) async {
//                     provider.googleMapController = controller;
//                     await provider.setCurrentLocation(
//                       widget.orderDetail,
//                       widget.customerDetail,
//                     );
//                   },
//                   polylines: provider.polylines,
//                   markers: Set<Marker>.of(provider.markers.values),
//                 ),
//                 SafeArea(
//                   child: Stack(
//                     children: [
//                       Column(
//                         mainAxisSize: MainAxisSize.max,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           getStatus(provider.orderStatus)
//                               ? OriginWidget(
//                                   deviceWidth: deviceSize.width,
//                                 )
//                               : DestinationWidget(
//                                   deviceWidth: deviceSize.width,
//                                 ),
//                           // Column(
//                           //   children: [
//                           //     Text(
//                           //         "Driver latlong realtime: ${provider.driverUpdatedLatLong}"),
//                           //     // Text(
//                           //     //     "Polyline is: ${provider.polylineCoordinates}"),
//                           //   ],
//                           // ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 const CurrentLocationOrderWidget(),
//                                 BottomContainerOrder(
//                                   newMessgeCount:
//                                       Provider.of<LatestSocketProvider>(context,
//                                               listen: true)
//                                           .unreadMessageCount,
//                                   currentOrderStatus: session.currentOrderState,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
