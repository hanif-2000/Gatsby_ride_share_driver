import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/widgets/button_order.dart';

class BottomContainerOrder extends StatelessWidget {
  int newMessgeCount;
  int currentOrderStatus;
  // dynamic orderTotal;

  BottomContainerOrder(
      {Key? key,
      required this.newMessgeCount,
      // required this.orderTotal,
      required this.currentOrderStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LatestSocketProvider>(
      builder: (context, provider, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // CustomerInfoWidget(),
            ButtonOrder(
                // orderTotal: orderTotal,
                newMessgeCount: newMessgeCount,
                currentOrderStatus: currentOrderStatus),
          ],
        );
      },
    );
  }
}
