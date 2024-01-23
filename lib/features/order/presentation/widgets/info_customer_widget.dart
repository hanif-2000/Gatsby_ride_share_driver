import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/cache_network_widget.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/presentation/widgets/rounded_upper_container.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';

class CustomerInfoWidget extends StatelessWidget {
  const CustomerInfoWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<LatestSocketProvider>(builder: (context, provider, _) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    builder: (context) {
                      return RoundedUpperContainer(
                        height: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              smallVerticalSpacing(),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomCacheNetworkImage(
                                          img: provider.customerDetail!.photo!,
                                          size: 60),
                                      // SizedBox(
                                      //   height: 60,
                                      //   width: 60,
                                      //   // child: CircleAvatar(
                                      //   //   backgroundImage:
                                      //   //       AssetImage(userAvatarImage),
                                      //   //   maxRadius: 15,
                                      //   //   minRadius: 15,
                                      //   // ),
                                      //   child: provider.customerDetail!.data
                                      //           .photo.isEmpty
                                      //       ? const CircleAvatar(
                                      //           radius: 33,
                                      //           backgroundImage:
                                      //               AssetImage(userAvatarImage),
                                      //         )
                                      //       : CircleAvatar(
                                      //           radius: 33,
                                      //           backgroundImage: NetworkImage(
                                      //               mergePhotoUrl(provider
                                      //                   .customerDetail!
                                      //                   .data
                                      //                   .photo)),
                                      //         ),
                                      // ),
                                      mediumHorizontalSpacing(),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            provider.customerDetail!.name,
                                            style: titlePlatStyle,
                                          ),
                                          Text(
                                            provider
                                                .customerDetail!.phoneNumber,
                                            style: titleModelStyle,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  smallVerticalSpacing(),
                                  const Divider(
                                    color: Colors.grey,
                                  ),
                                  smallVerticalSpacing(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.my_location,
                                          color: primaryColor, size: 30),
                                      smallHorizontalSpacing(),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              appLoc.origin,
                                              style: const TextStyle(
                                                      fontSize: 13,
                                                      color: greyBlackColor,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  .usePoppinsW6Font(),
                                            ),
                                            Text(
                                              provider.originAddress,
                                              style: titleModelStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  mediumVerticalSpacing(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: primaryColor, size: 30),
                                      smallHorizontalSpacing(),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              appLoc.destination,
                                              style: const TextStyle(
                                                      fontSize: 13,
                                                      color: greyBlackColor,
                                                      fontWeight:
                                                          FontWeight.bold)
                                                  .usePoppinsW6Font(),
                                            ),
                                            Text(
                                              provider.destinationAddress,
                                              style: titleModelStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: const Icon(
                Icons.person_pin,
                color: Colors.grey,
                size: 40,
              ),
            ),
          ),
        ],
      );
    });
  }
}
