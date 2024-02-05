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
      {Key? key, required this.customerDataModel, required this.orderDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    logMe("Customer data model is :->> $customerDataModel");
    // return Consumer<OrderProvider>(
    //   builder: (context, provider, _) {
    return ((customerDataModel == null) || (customerDataModel == ''))
        ? const Text("Fetching data Please Wait ... ")

        //  const CircularProgressIndicator(
        //     color: Colors.blue,
        //   )
        : Row(
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, OtherUserProfile.routeName);
                  },
                  child: CustomCacheNetworkImage(
                      img: customerDataModel!.photo!, size: 45)

                  //  Container(
                  //   height: 45,
                  //   width: 45,
                  //   decoration: BoxDecoration(
                  //     shape: BoxShape.circle,
                  //     color: redD03B3B,
                  //     image: DecorationImage(
                  //       image: NetworkImage(
                  //         '$BASE_URL${provider.customerDetail!.photo}',
                  //       ),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
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
                        Text(
                          convertToOneDecimal(
                              customerDataModel!.rating.toString()),
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
                    // '\$${provider.orderDetail!.totalPrice.toStringAsFixed(2)}',
                    'CA\$ ${(double.parse(orderDetails!.newTotal.toString())).toStringAsFixed(2)}',

                    textAlign: TextAlign.center,
                    style: titleStyle
                        .copyWith(
                          fontSize: 16,
                        )
                        .usePoppinsW6Font(),
                  ),
                  Text(
                    '${orderDetails!.distance} Km',
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
