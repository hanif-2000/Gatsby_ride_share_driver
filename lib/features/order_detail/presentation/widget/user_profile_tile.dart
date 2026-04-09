import 'package:appkey_taxiapp_driver/core/presentation/pages/other_user_profile.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/cache_network_widget.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/entities/order_detail.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/page/rating_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/data/models/customer_detail_model.dart';
import '../../../../core/static/colors.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/convert_one_decimal_helper.dart';
import '../../../../core/utility/helper.dart';

class UserProfileTile extends StatelessWidget {
  final CustomerDataModel? customerDataModel;
  final OrderDetail? orderDetails;

  const UserProfileTile(
      {super.key, required this.customerDataModel, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    return ((customerDataModel == null) || (customerDataModel == ''))
        ? const Text("Fetching data Please Wait ... ")
        : Row(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, OtherUserProfile.routeName);
                  },
                  child: CustomCacheNetworkImage(
                      img: customerDataModel!.photo!, size: 45)
                  ),
              mediumHorizontalSpacing(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customerDataModel!.name,
                    textAlign: TextAlign.center,
                    style: titleStyle
                        .copyWith(
                          fontSize: 16,
                        )
                        .usePoppinsW5Font(),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RatingListPage.routeName,
                          arguments: customerDataModel!.id);
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/home/ic_start.svg'),
                        smallHorizontalSpacing(),
                        Text(customerDataModel!.rating.toString().isNotEmpty?  convertToOneDecimal(customerDataModel!.rating.toString()):"0.0",
                          // double.tryParse(customerDataModel!.rating.toString())
                          //         ?.toStringAsFixed(1) ??
                          //     "",
                          // '${customerDataModel!.rating}',
                          textAlign: TextAlign.center,
                          style: titleStyle
                              .copyWith(
                                fontSize: 14,
                              )
                              .usePoppinsW6Font(),
                        ),
                        smallHorizontalSpacing(),
                        Text(
                          'Reviews',
                          textAlign: TextAlign.center,
                          style: titleStyle
                              .copyWith(
                                fontSize: 14,
                                color: yellowE5A829,
                                decoration: TextDecoration.underline,
                              )
                              .usePoppinsW5Font(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //Bottom sheet customer ride price
                  Text(
                    'CA\$ ${(double.tryParse(orderDetails!.newTotal.toString()) ?? double.tryParse(orderDetails!.totalPrice.toString()) ?? 0.0).toStringAsFixed(2)}',

                    textAlign: TextAlign.center,
                    style: titleStyle
                        .copyWith(
                          fontSize: 16,
                        )
                        .usePoppinsW6Font(),
                  ),
                  Text('${orderDetails!.distance} Km',
                    textAlign: TextAlign.center,
                    style: titleStyle
                        .copyWith(
                          fontSize: 14,
                          color: greyB6B6B6,
                        )
                        .usePoppinsW5Font(),
                  ),
                ],
              ),
            ],
          );
    // },
    // );
  }
}
