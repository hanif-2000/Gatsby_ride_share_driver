
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DestinationWidget extends StatelessWidget {

  final double deviceWidth;

  const DestinationWidget({
    Key? key,
    required this.deviceWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, map, _) {
        if (map.originAddress == '') {
          return const SizedBox();
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
            child: GestureDetector(
              onTap: () {},
              child: SizedBox(
                width: deviceWidth,
                // height: 60,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(2, 2),
                        blurRadius: 12,
                        color: Color.fromRGBO(0, 0, 0, 0.16),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // const Icon(
                        //   Icons.location_on,
                        //   color: primaryColor,
                        //   size: 30,
                        // ),
                        Container(
                          decoration: const BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 5),
                                blurRadius: 12,
                                color: Color.fromRGBO(0, 0, 0, 0.16),
                              )
                            ],
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/order/ic_location.svg',
                            height: 30,
                            width: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Drop-off',
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: greyC8C7CC,
                                ),
                              ),
                              Text(
                                map.destinationAddress,
                                softWrap: false,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
