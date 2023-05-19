import 'package:appkey_taxiapp_driver/core/presentation/providers/total_price_state.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/login/presentation/pages/login_page.dart';
import '../../utility/global_function.dart';
import '../pages/place_picker_page/place_picker_page.dart';
import '../providers/home_provider.dart';

class DestinationWidget extends StatelessWidget {
  final double deviceWidth;

  const DestinationWidget({
    Key? key,
    required this.deviceWidth,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, map, _) {
      if (map.originAddress == '') {
        return const SizedBox();
      } else {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            child: GestureDetector(
                onTap: () {},
                child: SizedBox(
                    width: deviceWidth,
                    height: 60,
                    child: Card(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              const Icon(Icons.location_on,
                                  color: primaryColor, size: 30),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  map.destinationAddress,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          )),
                    ))));
      }
    });
  }
}
