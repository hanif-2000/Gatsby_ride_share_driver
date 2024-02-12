import 'package:appkey_taxiapp_driver/core/data/models/customer_detail_model.dart';
import 'package:appkey_taxiapp_driver/core/presentation/pages/job_completed_page.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/cache_network_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_button/custom_button_widget.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_text_field.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/order/presentation/pages/new_order_page.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/providers/rating_provider.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/providers/rating_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../order_detail/presentation/widget/custom_rating_bar.dart';

class GiveRatingScreen extends StatelessWidget {
  const GiveRatingScreen(
      {Key? key, required this.customerDataModel, required this.customerId})
      : super(key: key);
  static const routeName = '/GiveRatingScreen';
  final CustomerDataModel customerDataModel;
  final int customerId;

  @override
  Widget build(BuildContext context) {
    Session session = locator<Session>();
    return ChangeNotifierProvider(
      create: (context) => locator<RatingProvider>(),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Consumer2<RatingProvider, LatestSocketProvider>(
              builder: (context, provider, socketProvider, _) {
                return Form(
                  key: provider.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      largeVerticalSpacing(),
                      largeVerticalSpacing(),
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: IconButton(
                      //     onPressed: () {
                      //       Navigator.pushNamedAndRemoveUntil(
                      //           context, HomePage.routeName, (value) => true);
                      //     },
                      //     icon: SvgPicture.asset('assets/icons/auth/ic_back.svg'),
                      //   ),
                      // ),

                      CustomCacheNetworkImage(
                          img: customerDataModel.photo!, size: 150),
                      // Container(
                      //   height: 150,
                      //   width: 150,
                      //   decoration: BoxDecoration(
                      //     color: greenF0F9F1,
                      //     border: Border.all(color: greenF0F9F1),
                      //     shape: BoxShape.circle,
                      //   ),
                      //   child: Container(
                      //     margin: const EdgeInsets.all(10),
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: Colors.red,
                      //       image: DecorationImage(
                      //         image: NetworkImage(
                      //           '$BASE_URL${customerDataModel.photo}',
                      //         ),
                      //         fit: BoxFit.cover,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Text(
                        customerDataModel.name,
                        textAlign: TextAlign.center,
                        style: titleStyle
                            .copyWith(
                              fontSize: 18,
                            )
                            .usePoppinsW5Font(),
                      ),
                      largeVerticalSpacing(),
                      Text(
                        appLoc.rateYourPassenger,
                        textAlign: TextAlign.center,
                        style: titleStyle
                            .copyWith(
                              fontSize: 25,
                            )
                            .usePoppinsW5Font(),
                      ),
                      smallVerticalSpacing(),
                      Text(
                        appLoc.yourFeedbackWillHelp,
                        textAlign: TextAlign.center,
                        style: titleStyle
                            .copyWith(fontSize: 17, color: greyA2A0A8)
                            .usePoppinsW4Font(),
                      ),
                      mediumVerticalSpacing(),
                      CustomRatingBar(
                        initialRating: provider.rating,
                        itemSize: 40,
                        isEditable: false,
                        onUpdate: (value) {
                          print('Rating ----> $value');
                          provider.updateRating(value);
                        },
                      ),
                      largeVerticalSpacing(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            CustomTextField(
                              maxLine: 5,
                              placeholder: appLoc.pleaseEnterMessage,
                              title: appLoc.pleaseEnterMessage,
                              controller: provider.firstNameController,
                              inputType: TextInputType.multiline,
                              isError: provider.firstNameError,
                              fieldValidator: null,
                              // fieldValidator: ValidationHelper(
                              //   loc: appLoc,
                              //   isError: (bool value) =>
                              //       provider.setFirstNameError = value,
                              //   typeField: TypeField.name,
                              // ).validate(),
                            ),
                            largeVerticalSpacing(),
                            largeVerticalSpacing(),
                            CustomButton(
                              text: Text(
                                appLoc.submit,
                                style: txtButtonStyle,
                              ),
                              event: () {
                                var socketProvider =
                                    locator<LatestSocketProvider>();
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                // if (provider.formKey.currentState!.validate()) {
                                provider
                                    .addRating(
                                  customerId: customerId,
                                )
                                    .listen(
                                  (event) async {
                                    switch (event.runtimeType) {
                                      case RatingLoading:
                                        showLoading();
                                        break;
                                      case RatingFailure:
                                        final msg =
                                            (event as RatingFailure).failure;
                                        showToast(message: msg);
                                        dismissLoading();
                                        break;
                                      case RatingSuccess:
                                        dismissLoading();
                                        socketProvider.removeOrderFromList(
                                            orderId: session.runningOrderId);

                                        session.setRunningOrderStatus = 0;
                                        session.setIsOrderRunning = false;
                                        session.setIsRatingGiven = true;
                                        session.setIsPaymentDone = true;

                                        Navigator.pushNamed(
                                          context,
                                          JobCompletedPage.routeName,
                                          arguments: RatingPageArguments(
                                            customerDataModel:
                                                socketProvider.customerDetail!,
                                            customerId: socketProvider
                                                .customerDetail!.id,
                                          ),
                                        );

                                        break;
                                      default:
                                        showLoading();
                                        break;
                                    }
                                  },
                                );
                                // }
                              },
                              buttonHeight: 48,
                              isRounded: true,
                              bgColor: blackColor,
                            ),
                            largeVerticalSpacing(),
                            CustomButton(
                              text: Text(
                                appLoc.skip,
                                style:
                                    txtButtonStyle.copyWith(color: blackColor),
                              ),
                              event: () {
                                session.setIsRatingGiven = true;
                                session.setIsPaymentDone = true;

                                session.setRunningOrderStatus = 0;
                                session.setIsOrderRunning = false;
                                Navigator.pushNamed(
                                    context, JobCompletedPage.routeName);
                                // Navigator.pop(context);
                              },
                              showBorder: true,
                              buttonHeight: 48,
                              isRounded: true,
                              bgColor: Colors.white,
                            ),
                            largeVerticalSpacing(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
