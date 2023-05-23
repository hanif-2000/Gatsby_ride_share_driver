import 'package:appkey_taxiapp_driver/core/domain/entities/order_data_detail.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/pages/order_page.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/order_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../features/login/presentation/pages/login_page.dart';
import '../../../features/order/presentation/providers/update_status_order_state.dart';
import '../../../features/order/presentation/widgets/depart_dialog.dart';
import '../../static/styles.dart';
import '../../utility/global_function.dart';
import '../providers/home_provider.dart';
import 'custom_simple_dialog.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';

class ButtonOrder extends StatelessWidget {
  const ButtonOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, provider, _) {
      return Container(
        color: const Color.fromRGBO(0, 0, 0, 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            provider.orderDetail != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: AutoSizeText(
                                        appLoc.distance,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                        minFontSize: 15,
                                        maxFontSize: 18,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      child: AutoSizeText(
                                        mergeDistanceTxt(
                                            provider.orderDetail!.distance),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                        minFontSize: 16,
                                        maxFontSize: 20,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: SizedBox(
                                  width: 1,
                                  child: Container(
                                    color: Colors.grey[350],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                flex: 5,
                                child: Container(
                                    child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AutoSizeText(
                                          appLoc.price,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.normal),
                                          minFontSize: 15,
                                          maxFontSize: 18,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        child: AutoSizeText(
                                          mergePriceTxt(provider
                                              .orderDetail!.totalPrice
                                              .toString()),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                          minFontSize: 16,
                                          maxFontSize: 20,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 8),
              child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: CustomButton(
                      text: Text(
                        provider.orderStatus.getString(),
                        style: txtButtonStyle,
                      ),
                      event: () {
                        provider.submitStatusOrder().listen((event) async {
                          if (event is UpdateStatusOrderLoaded) {
                            if (provider.orderStatus ==
                                OrderStatus.arriveAtCustomerPlace) {
                              showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return WillPopScope(
                                      onWillPop: () async => false,
                                      child: DepartDialog(
                                        callback: (b, call) {
                                          if (call) {
                                            provider.callCustomer();
                                          }
                                        },
                                      ),
                                    );
                                  });
                            }
                          }
                        });
                      },
                      bgColor: provider.orderStatus == OrderStatus.driverAccept
                          ? Colors.black
                          : provider.orderStatus ==
                                  OrderStatus.customerConfirmation
                              ? Colors.black
                              : primaryColor)),
            ),
          ],
        ),
      );
    });
  }
}
