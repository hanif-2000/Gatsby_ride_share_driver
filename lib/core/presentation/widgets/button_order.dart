import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/chat/presendtation/page/chat_page.dart';
import 'package:appkey_taxiapp_driver/features/order_detail/presentation/widget/user_profile_tile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_client/web_socket_client.dart';
import '../../../features/order/presentation/pages/new_order_page.dart';
import '../../../features/receipt/persentation/pages/new_receipt_page.dart';
import '../../static/styles.dart';
import '../../utility/injection.dart';
import '../pages/home_page/home_page.dart';

class ChatDetail {
  String? userName;
  String? userPhoto;
  int? userId;

  ChatDetail(this.userName, this.userPhoto, this.userId);
}

class ButtonOrder extends StatelessWidget {
  int newMessgeCount;
  int currentOrderStatus;
  // dynamic orderTotal;
  ButtonOrder(
      {Key? key,
      required this.newMessgeCount,
      // required this.orderTotal,
      required this.currentOrderStatus})
      : super(key: key);

  Session session = locator<Session>();

  var dio = Dio();

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Consumer2(
      builder: (context, LatestSocketProvider provider, HomeProvider homeProvider, _) {
        final socketProvider = context.read<LatestSocketProvider>();
        log("unread message count is --------->>>>>>:${socketProvider.unreadMessageCount}");
        log("current status from previous screen  is $currentOrderStatus}");
        log("session order status is:-->>${session.currentOrderState}");
        log("is order running : ${session.isOrderRunning}");
        return Container(
          padding: const EdgeInsets.all(8),
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

              /**   SHOW CUSTOMER PROFILE TILE SECTION */
              UserProfileTile(
                customerDataModel: socketProvider.customerDetail,
                orderDetails: socketProvider.orderDetail,
              ),
              mediumVerticalSpacing(),

              /** CALL NOW / MESSAGE BUTTON SECTION */
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: deviceSize.width * .44,
                          child: CustomButton(
                              image: 'assets/icons/order/ic_call.svg',
                              text: Text(
                                'Call now',
                                style: txtButtonStyle,
                              ),
                              event: () {
                                socketProvider.callCustomer();
                              },
                              buttonHeight: 48,
                              isRounded: true,
                              bgColor:green2DAA5F

                              ),
                        ),
                        smallHorizontalSpacing(),
                        SizedBox(
                          width: deviceSize.width * .44,
                          child: CustomButton(
                              image: 'assets/icons/order/ic_message.svg',
                              text: Text(
                                'Message',
                                style: txtButtonStyle,
                              ),
                              event: () {


                                print("Customer name____>>. ${socketProvider.customerDetail!.name}");
                                print("Customer name____>>. ${socketProvider.customerDetail!.photo}");
                                print("Customer name____>>. ${socketProvider.customerDetail!.id}");

                                Navigator.pushNamed(
                                  context,
                                  ChatPage.routeName,
                                  arguments: ChatDetail(
                                    socketProvider.customerDetail!.name,
                                    socketProvider.customerDetail!.photo,
                                    socketProvider.customerDetail!.id,
                                  ),
                                );

                              },
                              buttonHeight: 48,
                              isRounded: true,
                              bgColor: blue249DE0

                              ),
                        ),
                      ],
                    ),
                  ),
                  socketProvider.unreadMessageCount != 0
                      ? Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                                color: redf52d56Color, shape: BoxShape.circle),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                socketProvider.unreadMessageCount.toString(),
                                style: const TextStyle(color: whiteColor),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
              mediumVerticalSpacing(),

              /** ------- RIDE STATUS INTO STRING Section ------- */
              CustomButton(
                  text: Text(
                    socketProvider.rideText,
                    style: txtButtonStyle,
                  ),
                  event: () async {
                    showLoading();
                    print(
                        "**********--------->>>>>>. ${socketProvider.currentOrderStatus} <<<<<<-----------***********");
                    if ((socketProvider.currentOrderStatus == 0) ||
                        socketProvider.currentOrderStatus == 1) {
                      /** start ride to customer place */
                      socketProvider.updateOrderStatus(
                        status: "2",
                        actualTime: "0",
                        startTime: '',
                        endTime: '',
                      );
                    } else if (socketProvider.currentOrderStatus == 2) {
                      /** reached customer place */

                      socketProvider.updateOrderStatus(
                        status: "3",
                        actualTime: "0",
                        startTime: '',
                        endTime: '',
                      );
                    } else if (socketProvider.currentOrderStatus == 3) {
                      /** START TRIP */

                      session.setStartTime = DateTime.now().toString();
                      socketProvider.updateOrderStatus(
                        status: "5",
                        actualTime: "0",
                        startTime: DateTime.now().toString(),
                        endTime: '',
                      );
                    } else if (socketProvider.currentOrderStatus == 5) {
                      try {
                        socketProvider.calculateDistanceCovered2();
                         await Future.delayed(const Duration(milliseconds: 500));
                        socketProvider.updateOrderStatus(
                          status: "7",
                          actualTime: double.tryParse(session.estimatedTime)?.toString() ?? '',
                          startTime: session.rideStartTime,
                          endTime: DateTime.now().toString(),
                        );
                        dismissLoading();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          ReceiptPage.routeName,
                              (route) => false,
                          arguments: RatingPageArguments(
                            customerDataModel: socketProvider.customerDetail!,
                            customerId: socketProvider.orderDetail!.userId,
                          ),
                        );

                        // Log ride completion time
                        log("Ride complete end time is: ${DateTime.now()}");
                      } catch (e) {
                        dismissLoading();
                        // Handle any errors here
                        print('Error: $e');
                      }
                    }

                  },
                  buttonHeight: 48,
                  isRounded: true,
                  bgColor: Colors.black),
              mediumVerticalSpacing(),
              /** ------ CANCEL RIDE Button Section ------ */
              Visibility(
                visible: ((session.currentOrderState == 5) ||
                        (socketProvider.currentOrderStatus == 5))
                    ? false
                    : ((session.currentOrderState == 6) ||
                            (socketProvider.currentOrderStatus == 6))
                        ? false
                        : ((session.currentOrderState == 7) ||
                                (socketProvider.currentOrderStatus == 7))
                            ? false
                            : ((session.currentOrderState == 8) ||
                                    (socketProvider.currentOrderStatus == 8))
                                ? true
                                : (!session.isOrderRunning)
                                    ? true
                                    : true,
                child: CustomButton(
                    text: Text(
                      'Cancel Ride',
                      style: txtButtonStyle,
                    ),
                    event: () {
                      showCancelConfirmationAlertDialog(
                          context: context,
                          onTap: () async {
                            socketProvider.removeOrderFromList(
                                orderId: session.runningOrderId);

                            Navigator.pop(context);
                            showLoading();

                            socketProvider.updateOrderStatus(
                                    status: "8",
                                    actualTime: "0",
                                    endTime: '',
                                    startTime: '',
                            ).then((value) {
                              session.setRunningOrderStatus = 0;
                              session.setIsOrderRunning = false;
                              session.clearOrderSession();

                              dismissLoading();
                              if (value) {
                                homeProvider.clearState();
                                socketProvider.clearState();

                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                    (route) => false);
                              } else {
                                log("**** Something went wrong");
                              }
                            });
                            // String updateStatusUrl =
                            //     'https://php.parastechnologies.in/taxi/public/api/webservice/driver/update-status';

                            // var data = FormData.fromMap(
                            //     {'id': session.runningOrderId, 'status': '8'});

                            // log("form data is: ${data.fields}");
                            // log("Session token: ${session.sessionToken}");
                            // dio.options.headers["Authorization"] =
                            //     "Bearer +${session.sessionToken}";

                            // var res =
                            //     await dio.post(updateStatusUrl, data: data);

                            // log("status code is" + res.statusCode.toString());

                            // if (res.statusCode == 200) {
                            //   if (res.data["success"] == 1) {
                            //     log("Ride is canceled");
                            //     Navigator.pushNamedAndRemoveUntil(
                            //       context,
                            //       HomePage.routeName,
                            //       (route) => false,
                            //     );
                            //   } else {
                            //     showToast(
                            //         message:
                            //             "Something went wrong Please try again");
                            //   }
                            // }

                            // try {
                            //   var response = await dio.request(
                            //     'https://php.parastechnologies.in/taxi/public/api/webservice/driver/update-status',
                            //     options: Options(
                            //       method: 'POST',
                            //       headers: {
                            //         "Authorization":
                            //             "Bearer ${provider.session.sessionToken}"
                            //       },
                            //     ),
                            //     data: data,
                            //   );
                            //   // Response res =
                            //   //     await dio.post(updateStatusUrl, data: data);

                            //   log("status code is${response.statusCode}");

                            //   if (response.statusCode == 200) {
                            //     dismissLoading();
                            //     if (response.data["success"] == 1) {
                            //       session.setCurrentOrderState = 100;
                            //       session.setIsOrderRunning = false;
                            //       provider.clearState();
                            //       dismissLoading();

                            //       log("Ride is canceled");

                            //       Navigator.pushNamedAndRemoveUntil(
                            //         context,
                            //         HomePage.routeName,
                            //         (route) => false,
                            //       );
                            //     } else {
                            //       showToast(
                            //           message:
                            //               "Something went wrong Please try again");
                            //     }
                            // //   }
                            // } catch (e) {
                            //   dismissLoading();

                            //   log("exception :-->> $e");
                            //   log(e.toString());
                            // }

                            // provider
                            //     .submitStatusOrder(true)
                            //     .listen((event) async {
                            //   if (event is UpdateStatusOrderLoaded) {
                            //     log("UpdateStatusOrderLoaded called");
                            //   }
                            // });

                            // Navigator.pushNamedAndRemoveUntil(
                            //   context,
                            //   HomePage.routeName,
                            //   (route) => false,
                            // );
                            // log("Ride is canceled");
                          });
                    },
                    buttonHeight: 48,
                    isRounded: true,
                    bgColor: Colors.red),
              ),

              mediumVerticalSpacing(),
            ],
          ),
        );
      },
    );
  }
}
