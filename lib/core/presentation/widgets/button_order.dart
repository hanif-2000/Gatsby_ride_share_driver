import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/presentation/providers/socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/chat/presendtation/page/chat_page.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/order_provider.dart';
import 'package:appkey_taxiapp_driver/features/order_detail/presentation/widget/user_profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/order/presentation/providers/update_status_order_state.dart';
import '../../static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';

import '../../utility/injection.dart';

class ChatDetail {
  String? userName;
  String? userPhoto;
  int? userId;

  ChatDetail(this.userName, this.userPhoto, this.userId);
}

class ButtonOrder extends StatelessWidget {
  int newMessgeCount;
  ButtonOrder({Key? key, required this.newMessgeCount}) : super(key: key);

  SocketProvider socketProvider = locator<SocketProvider>();

  @override
  Widget build(BuildContext context) {
    var _deviceSize = MediaQuery.of(context).size;
    final session = locator<Session>();
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        log("unread message count is --------->>>>>>:" +
            socketProvider.unreadMessageCount.toString());
        return Container(
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
              // provider.orderDetail != null
              //     ? Padding(
              //         padding: const EdgeInsets.symmetric(
              //           vertical: 8.0,
              //           horizontal: 8.0,
              //         ),
              //         child: Card(
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(
              //               vertical: 8.0,
              //               horizontal: 20.0,
              //             ),
              //             child: SizedBox(
              //               height: 50,
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //                 children: <Widget>[
              //                   Expanded(
              //                     flex: 5,
              //                     child: Row(
              //                       children: [
              //                         Expanded(
              //                           child: AutoSizeText(
              //                             appLoc.distance,
              //                             style: const TextStyle(
              //                               fontWeight: FontWeight.normal,
              //                             ),
              //                             minFontSize: 15,
              //                             maxFontSize: 18,
              //                             maxLines: 1,
              //                             overflow: TextOverflow.ellipsis,
              //                           ),
              //                         ),
              //                         Expanded(
              //                           child: AutoSizeText(
              //                             mergeDistanceTxt(
              //                                 provider.orderDetail!.distance),
              //                             style: const TextStyle(
              //                               fontWeight: FontWeight.bold,
              //                               color: primaryColor,
              //                             ),
              //                             minFontSize: 16,
              //                             maxFontSize: 20,
              //                             maxLines: 1,
              //                             overflow: TextOverflow.ellipsis,
              //                           ),
              //                         )
              //                       ],
              //                     ),
              //                   ),
              //                   Padding(
              //                     padding:
              //                         const EdgeInsets.symmetric(horizontal: 5),
              //                     child: SizedBox(
              //                       width: 1,
              //                       child: Container(
              //                         color: Colors.grey[350],
              //                       ),
              //                     ),
              //                   ),
              //                   const SizedBox(
              //                     width: 8,
              //                   ),
              //                   Expanded(
              //                     flex: 5,
              //                     child: Container(
              //                       child: Align(
              //                         alignment: Alignment.centerLeft,
              //                         child: Row(
              //                           children: [
              //                             Expanded(
              //                               child: AutoSizeText(
              //                                 appLoc.price,
              //                                 style: const TextStyle(
              //                                   fontWeight: FontWeight.normal,
              //                                 ),
              //                                 minFontSize: 15,
              //                                 maxFontSize: 18,
              //                                 maxLines: 1,
              //                                 overflow: TextOverflow.ellipsis,
              //                               ),
              //                             ),
              //                             Expanded(
              //                               child: AutoSizeText(
              //                                 mergePriceTxt(provider
              //                                     .orderDetail!.totalPrice
              //                                     .toString()),
              //                                 style: const TextStyle(
              //                                   fontWeight: FontWeight.bold,
              //                                   color: primaryColor,
              //                                 ),
              //                                 minFontSize: 16,
              //                                 maxFontSize: 20,
              //                                 maxLines: 1,
              //                                 overflow: TextOverflow.ellipsis,
              //                               ),
              //                             )
              //                           ],
              //                         ),
              //                       ),
              //                     ),
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     : const SizedBox(),
              const UserProfileTile(),
              mediumVerticalSpacing(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: _deviceSize.width * .42,
                    child: CustomButton(
                      image: 'assets/icons/order/ic_call.svg',
                      text: Text(
                        'Call now',
                        style: txtButtonStyle,
                      ),
                      event: () {
                        // session.orderStatus == 1
                        //     ? provider.callCustomer()
                        //     : session.orderStatus == 2
                        //         ? provider.callCustomer()
                        //         : session.orderStatus == 3
                        //             ?

                        provider.callCustomer();
                        // : () {};

                        // provider.callCustomer();
                      },
                      buttonHeight: 48,
                      isRounded: true,
                      bgColor:
                          //  session.orderStatus == 1
                          //     ? green2DAA5F
                          //     : session.orderStatus == 2
                          //         ? green2DAA5F
                          //         : session.orderStatus == 3
                          //             ?

                          green2DAA5F,
                      // : grey606060Color,
                    ),
                  ),
                  smallHorizontalSpacing(),
                  Stack(
                    children: [
                      SizedBox(
                        width: _deviceSize.width * .42,
                        child: CustomButton(
                            image: 'assets/icons/order/ic_message.svg',
                            text: Text(
                              'Message',
                              style: txtButtonStyle,
                            ),
                            event: () {
                              // session.orderStatus == 1
                              //     ? Navigator.pushNamed(context, ChatPage.routeName,
                              //         arguments: ChatDetail(
                              //           provider.customerDetail!.data.name,
                              //           provider.customerDetail!.data.photo,
                              //           provider.customerDetail!.data.id,
                              //         ))
                              //     : session.orderStatus == 2
                              //         ? Navigator.pushNamed(
                              //             context, ChatPage.routeName,
                              //             arguments: ChatDetail(
                              //               provider.customerDetail!.data.name,
                              //               provider.customerDetail!.data.photo,
                              //               provider.customerDetail!.data.id,
                              //             ))
                              //         : session.orderStatus == 3
                              //             ?
                              Navigator.pushNamed(context, ChatPage.routeName,
                                  arguments: ChatDetail(
                                    provider.customerDetail!.data.name,
                                    provider.customerDetail!.data.photo,
                                    provider.customerDetail!.data.id,
                                  ));
                              // : () {};
                            },
                            buttonHeight: 48,
                            isRounded: true,
                            bgColor:
                                //  session.orderStatus == 1
                                //     ? blue249DE0
                                //     : session.orderStatus == 2
                                //         ? blue249DE0
                                //         : session.orderStatus == 3
                                //             ?
                                blue249DE0
                            // :
                            // grey606060Color,
                            ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: blackColor, shape: BoxShape.circle),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              socketProvider.unreadMessageCount.toString(),
                              style: const TextStyle(color: whiteColor),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              mediumVerticalSpacing(),
              CustomButton(
                  text: Text(
                    provider.orderStatus.getString(),
                    style: txtButtonStyle,
                  ),
                  event: () {
                    provider.submitStatusOrder().listen(
                      (event) async {
                        if (event is UpdateStatusOrderLoaded) {
                          log("UpdateStatusOrderLoaded called");

                          if (provider.orderStatus ==
                              OrderStatus.departureToCustomerplace) {
                            session.setOrderStatus = 2;
                          } else if (provider.orderStatus ==
                              OrderStatus.arriveAtCustomerPlace) {
                            session.setOrderStatus = 3;
                            log("arrive at customer place called");
                            // showDialog(
                            //   barrierDismissible: false,
                            //   context: context,
                            //   builder: (context) {
                            //     return WillPopScope(
                            //       onWillPop: () async => false,
                            //       child: DepartDialog(
                            //         callback: (b, call) {
                            //           if (call) {
                            //             provider.callCustomer();
                            //           }
                            //         },
                            //       ),
                            //     );
                            //   },
                            // );
                          } else if (provider.orderStatus ==
                              OrderStatus.departureToDestination) {
                            session.setOrderStatus = 5;
                          } else if (provider.orderStatus ==
                              OrderStatus.arriveAtDestination) {
                            session.setOrderStatus = 6;
                          } else if (provider.orderStatus ==
                              OrderStatus.complete) {
                            session.setOrderStatus = 7;
                          }
                        }
                      },
                    );
                  },
                  buttonHeight: 48,
                  isRounded: true,
                  bgColor: Colors.black),
            ],
          ),
        );
      },
    );
  }
}
