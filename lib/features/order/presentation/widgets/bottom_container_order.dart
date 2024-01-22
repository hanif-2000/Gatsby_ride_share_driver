import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/widgets/button_order.dart';
import '../providers/new_order_provider.dart';

class BottomContainerOrder extends StatelessWidget {
  int newMessgeCount;
  int currentOrderStatus;

  BottomContainerOrder(
      {Key? key,
      required this.newMessgeCount,
      required this.currentOrderStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // CustomerInfoWidget(),
            ButtonOrder(
                newMessgeCount: newMessgeCount,
                currentOrderStatus: currentOrderStatus),
          ],
        );
      },
    );
  }
}
