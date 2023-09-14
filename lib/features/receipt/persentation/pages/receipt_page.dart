import 'package:appkey_taxiapp_driver/core/presentation/pages/home_page/home_page.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/features/receipt/data/model/receipt_model.dart';
import 'package:appkey_taxiapp_driver/features/receipt/persentation/provider/receipt_provider.dart';
import 'package:appkey_taxiapp_driver/features/receipt/persentation/provider/receipt_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../../../core/static/dimens.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/helper.dart';
import 'package:provider/provider.dart';

class ReceiptPage extends StatelessWidget {
  const ReceiptPage({Key? key, this.id}) : super(key: key);
  static const routeName = '/ReceiptPage';
  final String? id;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<ReceiptProvider>(),
      child: Scaffold(
        body: Consumer<ReceiptProvider>(
          builder: (context, provider, _) {
            return StreamBuilder<ReceiptState>(
              stream: provider.getReceiptAPI(),
              builder: (context, state) {
                print('$state');
                switch (state.data.runtimeType) {
                  case ReceiptLoading:
                    return const Center(child: CircularProgressIndicator());
                  case ReceiptFailure:
                    final failure = (state.data as ReceiptFailure).failure;
                    showToast(message: failure);
                    return const SizedBox.shrink();
                  case ReceiptSuccess:
                    final _data = (state.data as ReceiptSuccess).data;
                    if (_data == null) {
                      return Center(
                        child: Text(
                          appLoc.therearenopastorders,
                          style: formLabelHeaderStyle,
                        ),
                      );
                    }
                    OrderReceipt order = _data.orderReceipt.first;

                    int time =
                        (order.endTime!.difference(order.startTime!).inMinutes);

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 60, bottom: 16),
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                    color: Color.fromRGBO(0, 0, 0, 0.16),
                                  )
                                ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  appLoc.tripDetail,
                                  textAlign: TextAlign.center,
                                  style: titleStyle.copyWith(
                                    fontSize: fontLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: redD03B3B,
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            '$BASE_URL${order.image}',
                                          ),
                                        ),
                                      ),
                                    ),
                                    mediumHorizontalSpacing(),
                                    Column(
                                      children: [
                                        Text(
                                          '${order.userName}',
                                          textAlign: TextAlign.center,
                                          style: titleStyle
                                              .copyWith(
                                                fontSize: 16,
                                              )
                                              .usePoppinsW5Font(),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/home/ic_start.svg'),
                                        smallHorizontalSpacing(),
                                        Text(
                                          '${order.rating!.toStringAsFixed(1)}',
                                          textAlign: TextAlign.center,
                                          style: titleStyle
                                              .copyWith(
                                                fontSize: 14,
                                              )
                                              .usePoppinsW6Font(),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                largeVerticalSpacing(),
                                Text(
                                  'Fare Breakdown ',
                                  textAlign: TextAlign.start,
                                  style: titleStyle
                                      .copyWith(
                                        fontSize: 16,
                                      )
                                      .usePoppinsW6Font(),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Date',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                              color: grey7c7c7c,
                                            )
                                            .usePoppinsW6Font(),
                                      ),
                                      Text(
                                        '${DateFormat.yMMMd().format(order.orderTime)}',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                            )
                                            .usePoppinsW5Font(),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Time',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                              color: grey7c7c7c,
                                            )
                                            .usePoppinsW6Font(),
                                      ),
                                      Text(
                                        '${DateFormat.jm().format(order.orderTime)}',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                            )
                                            .usePoppinsW5Font(),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total Distance',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                              color: grey7c7c7c,
                                            )
                                            .usePoppinsW6Font(),
                                      ),
                                      Text(
                                        '${order.distance}',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                            )
                                            .usePoppinsW5Font(),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Time taken',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                              color: grey7c7c7c,
                                            )
                                            .usePoppinsW6Font(),
                                      ),
                                      Text(
                                        '${time ?? 0} min',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 16,
                                            )
                                            .usePoppinsW5Font(),
                                      ),
                                    ],
                                  ),
                                ),
                                largeVerticalSpacing(),
                                Text(
                                  'Payment Information',
                                  textAlign: TextAlign.start,
                                  style: titleStyle
                                      .copyWith(
                                        fontSize: 16,
                                      )
                                      .usePoppinsW6Font(),
                                ),
                                smallVerticalSpacing(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Payment Through',
                                        textAlign: TextAlign.center,
                                        style: titleStyle
                                            .copyWith(
                                              fontSize: 13,
                                              color: grey7D7979,
                                            )
                                            .usePoppinsW6Font(),
                                      ),
                                      Row(
                                        children: [
                                          // SvgPicture.asset(
                                          //     'assets/icons/home/ic_card_master.svg'),
                                          smallHorizontalSpacing(),
                                          Text(
                                            getPaymentType(order.paymentMethod),
                                            textAlign: TextAlign.center,
                                            style: titleStyle
                                                .copyWith(
                                                    fontSize: 16,
                                                    color: grey7D7979)
                                                .usePoppinsW5Font(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                mediumVerticalSpacing(),
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: greyB6B6B6.withOpacity(.3),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Price',
                                            textAlign: TextAlign.center,
                                            style: titleStyle
                                                .copyWith(
                                                  fontSize: 16,
                                                  color: grey7c7c7c,
                                                )
                                                .usePoppinsW6Font(),
                                          ),
                                          Text(
                                            '\$${order.total}',
                                            textAlign: TextAlign.center,
                                            style: titleStyle
                                                .copyWith(
                                                  fontSize: 16,
                                                )
                                                .usePoppinsW5Font(),
                                          ),
                                        ],
                                      ),
                                      smallVerticalSpacing(),
                                      const Divider(
                                        color: grey7D7979,
                                      ),
                                      smallVerticalSpacing(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Service Price (5%)',
                                            textAlign: TextAlign.center,
                                            style: titleStyle
                                                .copyWith(
                                                  fontSize: 16,
                                                  color: grey7c7c7c,
                                                )
                                                .usePoppinsW6Font(),
                                          ),
                                          Text(
                                            '\$${(order.total * 5) / 100}',
                                            textAlign: TextAlign.center,
                                            style: titleStyle
                                                .copyWith(
                                                  fontSize: 16,
                                                )
                                                .usePoppinsW5Font(),
                                          ),
                                        ],
                                      ),
                                      smallVerticalSpacing(),
                                      const Divider(
                                        color: grey7D7979,
                                      ),
                                      smallVerticalSpacing(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total Price',
                                            textAlign: TextAlign.center,
                                            style: titleStyle
                                                .copyWith(
                                                  fontSize: 16,
                                                  color: grey7c7c7c,
                                                )
                                                .usePoppinsW6Font(),
                                          ),
                                          Text(
                                            '\$${order.total - ((order.total * 5) / 100)}',
                                            textAlign: TextAlign.center,
                                            style: titleStyle
                                                .copyWith(
                                                  fontSize: 16,
                                                )
                                                .usePoppinsW5Font(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                largeVerticalSpacing(),
                                largeVerticalSpacing(),
                                CustomButton(
                                  text: Text(
                                    '${appLoc.continuee}',
                                    style: txtButtonStyle,
                                  ),
                                  event: () {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        HomePage.routeName, (route) => false);
                                  },
                                  buttonHeight: 48,
                                  isRounded: true,
                                  bgColor: blackColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
