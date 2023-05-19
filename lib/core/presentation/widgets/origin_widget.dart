import 'package:appkey_taxiapp_driver/core/presentation/pages/home_page/home_page.dart';
import 'package:appkey_taxiapp_driver/core/presentation/pages/place_picker_page/place_picker_page.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../features/login/presentation/pages/login_page.dart';
import '../../static/enums.dart';
import '../../utility/global_function.dart';
import '../providers/home_provider.dart';

class OriginWidget extends StatelessWidget {
  final double deviceWidth;

  const OriginWidget({
    Key? key,
    required this.deviceWidth,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, map, _) {
      if (map.originAddress == '') {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            child: SizedBox(
              width: deviceWidth,
              height: 60,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ));
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
                              const Icon(Icons.my_location,
                                  color: primaryColor, size: 30),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  map.originAddress,
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
