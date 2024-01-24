import 'package:appkey_taxiapp_driver/core/presentation/widgets/cache_network_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/models/booking_data_model.dart';
import '../../static/assets.dart';
import '../pages/request_detail_page.dart';

class NewRequestTile extends StatelessWidget {
  const NewRequestTile({
    Key? key,
    required this.onAccept,
    required this.onReject,
    required this.index,
    required this.request,
  }) : super(key: key);

  final Function() onAccept;
  final Function() onReject;
  final int index;
  final List<Booking> request;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RequestDetailPage(
              requestListModel: request[index],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.2),
                blurRadius: 4.0,
              ),
            ]),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 8.0,
              ),
              decoration: const BoxDecoration(
                color: greyF9F9F9,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14),
                  topRight: Radius.circular(14),
                ),
              ),
              child: Row(
                children: [
                  request[index].image != null
                      ? CustomCacheNetworkImage(
                          img: request[index].image ??
                              "https://picsum.photos/250?image=9",
                          size: 50)
                      :
                      // request!.image == ''
                      const CircleAvatar(
                          radius: 25,
                          backgroundImage: AssetImage(userAvatarImage),
                        ),
                  // : CircleAvatar(
                  //     radius: 25,
                  //     backgroundImage:
                  //         NetworkImage(mergePhotoUrl(request!.image!)),
                  //   ),
                  smallHorizontalSpacing(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request[index].name ?? 'name',

                          //  ${request.lastName}
                          //  ',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ).usePoppinsW6Font(),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset('assets/icons/home/ic_start.svg'),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              request[index].customerRating.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ).usePoppinsW6Font(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        // 'CA\$ ${request!.total}',

                        // 'CA\$ ${request.newTotal.toStringAsFixed(2)}',

                        'CA\$ ${request[index].newTotal}' ?? "total",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ).usePoppinsW6Font(),
                      ),
                      Text(
                        '${request[index].distance} Km',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: greyB6B6B6,
                        ).usePoppinsW6Font(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/home/ic_pickup.svg'),
                      mediumHorizontalSpacing(),
                      Expanded(
                        child: Text(
                          request[index].startAddress ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ).usePoppinsW4Font(),
                        ),
                      ),
                    ],
                  ),
                  mediumVerticalSpacing(),
                  Row(
                    children: [
                      SvgPicture.asset('assets/icons/home/ic_drop_pin.svg'),
                      mediumHorizontalSpacing(),
                      Expanded(
                        child: Text(
                          request[index].endAddress ?? '',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ).usePoppinsW4Font(),
                        ),
                      ),
                    ],
                  ),
                  mediumVerticalSpacing(),
                  const Divider(
                    color: grey9c9c9c,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: Text(
                            appLoc.reject,
                            style: txtButtonStyle,
                          ),
                          event: () {
                            onReject();
                          },
                          buttonHeight: 40,
                          isRounded: true,
                          bgColor: redD03B3B,
                        ),
                      ),
                      mediumHorizontalSpacing(),
                      Expanded(
                        child: CustomButton(
                          text: Text(
                            appLoc.accept,
                            style: txtButtonStyle,
                          ),
                          event: () {
                            onAccept();
                            // Navigator.pushNamed(context, ChatPage.routeName);
                          },
                          buttonHeight: 40,
                          isRounded: true,
                          bgColor: green2DAA5F,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
