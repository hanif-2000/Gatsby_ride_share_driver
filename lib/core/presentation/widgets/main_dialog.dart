import 'package:appkey_taxiapp_driver/core/presentation/widgets/cache_network_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';

import '../../../features/order/domain/entities/order_detail.dart';
import '../../data/models/customer_detail_model.dart';
import 'custom_button/custom_button_widget.dart';

class MainDialog extends StatelessWidget {
  final bool? isOrderDialog;
  final OrderDetail? orderDetail;
  final CustomerDetailModel? customerDetailModel;
  final void Function()? onDecline;
  final void Function()? onAccept;
  final void Function()? onEnd;
  final Size deviceSize;

  const MainDialog({
    Key? key,
    this.isOrderDialog = true,
    this.orderDetail,
    this.customerDetailModel,
    this.onDecline,
    this.onAccept,
    this.onEnd,
    required this.deviceSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color.fromRGBO(0, 0, 0, 0.4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  isOrderDialog!
                      ? ListTile(
                          leading: SizedBox(
                              width: 40,
                              height: 40,
                              child: CustomCacheNetworkImage(
                                  img: customerDetailModel!.data.photo!,
                                  size: 66)
                              //  customerDetailModel!.data.photo.isEmpty
                              //     ? const CircleAvatar(
                              //         radius: 33,
                              //         backgroundImage:
                              //             AssetImage(userAvatarImage),
                              //       )
                              //     : CircleAvatar(
                              //         radius: 33,
                              //         backgroundImage: NetworkImage(mergePhotoUrl(
                              //             customerDetailModel!.data.photo)),
                              //       ),

                              ),
                          title: Text(
                            customerDetailModel!.data.name,
                            style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)
                                .usePoppinsW6Font(),
                          ),
                        )
                      : SizedBox(
                          height: 50,
                          child: Center(
                              child: Text(
                            appLoc.thankyou,
                            style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)
                                .usePoppinsW6Font(),
                          ))),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                appLoc.customerCurrentLocation,
                                style: const TextStyle(
                                        fontSize: 13,
                                        color: greyBlackColor,
                                        fontWeight: FontWeight.bold)
                                    .usePoppinsW6Font(),
                              ),
                              // const SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  const Expanded(
                                      flex: 1,
                                      child: Icon(Icons.gps_fixed,
                                          color: primaryColor)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 9,
                                    child: Text(
                                      orderDetail!.startAddress,
                                      style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)
                                          .usePoppinsW6Font(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                appLoc.customerDestination,
                                style: const TextStyle(
                                        fontSize: 13,
                                        color: greyBlackColor,
                                        fontWeight: FontWeight.bold)
                                    .usePoppinsW6Font(),
                              ),
                              // const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  const Expanded(
                                    flex: 1,
                                    child: Icon(Icons.location_on,
                                        color: primaryColor),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 9,
                                    child: Text(
                                      orderDetail!.endAddress,
                                      style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)
                                          .usePoppinsW6Font(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    flex: 9,
                                    child: Container(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Text(
                                      mergePriceTxt(
                                          orderDetail!.totalPrice.toString()),
                                      style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)
                                          .usePoppinsW6Font(),
                                      maxLines: 1,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  isOrderDialog!
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: CustomButton(
                                  text: Text(
                                    appLoc.decline,
                                    style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)
                                        .usePoppinsW6Font(),
                                  ),
                                  event: () {
                                    onDecline!();
                                  },
                                  buttonHeight:
                                      MediaQuery.of(context).size.height *
                                          0.075,
                                  isRounded: true,
                                  bgColor: Colors.black),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: CustomButton(
                                  text: Text(
                                    appLoc.accept,
                                    style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold)
                                        .usePoppinsW6Font(),
                                  ),
                                  event: () {
                                    onAccept!();
                                  },
                                  buttonHeight:
                                      MediaQuery.of(context).size.height *
                                          0.075,
                                  isRounded: true,
                                  bgColor: primaryColor),
                            ),
                          ],
                        )
                      : Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: CustomButton(
                            event: () {
                              onEnd!();
                            },
                            text: Text(
                              appLoc.end,
                              style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)
                                  .usePoppinsW6Font(),
                            ),
                            bgColor: primaryColor,
                          ),
                        ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
