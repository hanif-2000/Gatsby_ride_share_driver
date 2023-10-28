import 'package:appkey_taxiapp_driver/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/widgets/button_order.dart';

class BottomContainerOrder extends StatelessWidget {
  int newMessgeCount;
  BottomContainerOrder({Key? key, required this.newMessgeCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // CustomerInfoWidget(),
            ButtonOrder(newMessgeCount: newMessgeCount),
          ],
        );
      },
    );
  }
}
