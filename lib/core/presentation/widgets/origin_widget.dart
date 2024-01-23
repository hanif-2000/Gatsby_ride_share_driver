import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OriginWidget extends StatelessWidget {
  final double deviceWidth;
  final String originAddress;

  const OriginWidget({
    Key? key,
    required this.deviceWidth,
    required this.originAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LatestSocketProvider>(
      builder: (context, map, _) {
        // if (map.originAddress == '') {
        //   return Padding(
        //     padding: const EdgeInsets.symmetric(
        //       vertical: 3,
        //       horizontal: 8,
        //     ),
        //     child: SizedBox(
        //       width: deviceWidth,
        //       height: 60,
        //       child: const Center(
        //         child: CircularProgressIndicator(
        //           color: blackColor,
        //         ),
        //       ),
        //     ),
        //   );
        // } else {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 3,
            horizontal: 8,
          ),
          child: GestureDetector(
            onTap: () {},
            child: SizedBox(
              width: deviceWidth,
              // height: 60,
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.my_location,
                        color: Colors.black,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PICK UP',
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: greyC8C7CC,
                              ),
                            ),
                            Text(
                              originAddress,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
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
        // }
      },
    );
  }
}
