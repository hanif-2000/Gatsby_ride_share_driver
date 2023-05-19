import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/button_order.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/category_car_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/distance_price_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/payment_widget.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/order_provider.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/widgets/button_cancel_order.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/widgets/info_customer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/static/enums.dart';

class BottomContaineOrder extends StatelessWidget {
  const BottomContaineOrder({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, provider, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [CustomerInfoWidget(), ButtonOrder()],
      );
    });
  }
}
