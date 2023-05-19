// import 'package:appkey_taxiapp_driver/core/static/assets.dart';
// import 'package:appkey_taxiapp_driver/core/static/colors.dart';
// import 'package:appkey_taxiapp_driver/core/static/enums.dart';
// import 'package:appkey_taxiapp_driver/core/static/styles.dart';
// import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
// import 'package:appkey_taxiapp_driver/core/utility/extension.dart';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../providers/home_provider.dart';
// import 'payment_tile_widget.dart';

// class PaymentOption extends StatelessWidget {
//   const PaymentOption({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<HomeProvider>(builder: (context, provider, _) {
//       return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
//           child: GestureDetector(
//             onTap: () {
//               showModalBottomSheet(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return SizedBox(
//                       height: 170,
//                       child: LayoutBuilder(builder: (context, constaints) {
//                         return ListView(
//                           children: [
//                             SizedBox(
//                               height: constaints.maxHeight * 0.25,
//                               child: Padding(
//                                 padding: const EdgeInsets.only(
//                                     top: 8.0, left: 15.0, bottom: 0.0),
//                                 child: Text(
//                                   appLoc.selectPaymentMethod,
//                                   style: selectPamyemntStyle,
//                                 ),
//                               ),
//                             ),
//                             SizedBox(
//                                 height: constaints.maxHeight * 0.35,
//                                 child: PaymentTile(
//                                   title: appLoc.cash,
//                                   assets: cashIcon,
//                                   onTap: () {
//                                     provider.setPaymentMethod =
//                                         PaymentMethod.cash;
//                                     Navigator.pop(context);
//                                   },
//                                   selected: provider.paymentMethod == null
//                                       ? false
//                                       : provider.paymentMethod ==
//                                               PaymentMethod.cash
//                                           ? true
//                                           : false,
//                                 )),
//                             SizedBox(
//                                 height: constaints.maxHeight * 0.35,
//                                 child: PaymentTile(
//                                   title: appLoc.creditDebit,
//                                   assets: creditIcon,
//                                   onTap: () {
//                                     provider.setPaymentMethod =
//                                         PaymentMethod.creditCard;
//                                     Navigator.pop(context);
//                                   },
//                                   selected: provider.paymentMethod == null
//                                       ? false
//                                       : provider.paymentMethod ==
//                                               PaymentMethod.creditCard
//                                           ? true
//                                           : false,
//                                 )),
//                           ],
//                         );
//                       }),
//                     );
//                   });
//             },
//             child: Card(
//                 child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: SizedBox(
//                       height: 40,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           const Padding(
//                             padding: EdgeInsets.only(
//                                 left: 10, top: 10, bottom: 10, right: 12),
//                             child: Icon(
//                               Icons.payment,
//                               color: primaryColor,
//                             ),
//                           ),
//                           Flexible(
//                             flex: 5,
//                             fit: FlexFit.tight,
//                             child: Text(
//                               provider.paymentMethod == null
//                                   ? appLoc.selectPaymentMethod
//                                   : provider.paymentMethod!.getString(),
//                               style: selectPamyemntStyle,
//                             ),
//                           ),
//                           Expanded(
//                               child: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: const [
//                               Icon(
//                                 Icons.arrow_forward_ios,
//                                 color: primaryColor,
//                               ),
//                             ],
//                           ))
//                         ],
//                       ),
//                     ))),
//           ));
//     });
//   }
// }
