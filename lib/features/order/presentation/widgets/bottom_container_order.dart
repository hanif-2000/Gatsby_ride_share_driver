import 'package:appkey_taxiapp_driver/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/widgets/button_order.dart';

class BottomContainerOrder extends StatelessWidget {
  const BottomContainerOrder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, provider, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            // CustomerInfoWidget(),
            ButtonOrder(),
          ],
        );
      },
    );
  }
}
