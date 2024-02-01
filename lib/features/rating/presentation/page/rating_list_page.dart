import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/providers/rating_list_state.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/providers/rating_provider.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/widgets/rating_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/static/assets.dart';
import '../../../../core/static/styles.dart';
import '../../../../core/utility/convert_one_decimal_helper.dart';
import '../../../../core/utility/injection.dart';
import '../../../order_detail/presentation/widget/custom_rating_bar.dart';

class RatingListPage extends StatelessWidget {
  const RatingListPage({Key? key, required this.userId}) : super(key: key);
  static const routeName = '/RatingListPage';
  final String userId;

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (context) => locator<RatingProvider>(),
      child: Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: const Text(
            "Ratings",
            style: TextStyle(color: blackColor),
          ),
          centerTitle: true,
          backgroundColor: whiteColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: blackColor,
            ),
          ),
        ),
        body: SafeArea(
          child: Consumer<RatingProvider>(builder: (context, provider, _) {
            return StreamBuilder<RatingListState>(
                stream: provider.getRatingList(userId: userId, type: '2'),
                builder: (context, snapshot) {
                  switch (snapshot.data.runtimeType) {
                    case RatingListLoading:
                      return const Center(child: CircularProgressIndicator());
                    case RatingListFailure:
                      final failure =
                          (snapshot.data as RatingListFailure).failure;
                      showToast(message: failure);
                      return const SizedBox.shrink();
                    case RatingListSuccess:
                      final data = (snapshot.data as RatingListSuccess).data;
                      return data!.list.isEmpty
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      noRating,
                                      width: deviceSize.width / 2,
                                      height: deviceSize.width / 2,
                                    ),
                                    const Text(
                                      "No Rating Yet, Please Give rating once ride completed",
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : ListView(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Padding(
                                    //   padding: const EdgeInsets.only(
                                    //       top: 20, bottom: 16),
                                    //   child: Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: [
                                    //       IconButton(
                                    //         onPressed: () {
                                    //           Navigator.pop(context);
                                    //         },
                                    //         icon: SvgPicture.asset(
                                    //             'assets/icons/auth/ic_back.svg'),
                                    //       ),
                                    //       Text(
                                    //         appLoc.ratings,
                                    //         textAlign: TextAlign.center,
                                    //         style: titleStyle
                                    //             .copyWith(
                                    //               fontSize: 18,
                                    //             )
                                    //             .usePoppinsW5Font(),
                                    //       ),
                                    //       const SizedBox(
                                    //         width: 30,
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    largeVerticalSpacing(),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 16),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: whiteColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(.2),
                                              blurRadius: 12.0,
                                              blurStyle: BlurStyle.outer,
                                              offset: const Offset(0, 4),
                                            ),
                                          ]),
                                      child: Row(
                                        children: [
                                          Text(
                                            convertToOneDecimal(
                                                data.rating.toString()),
                                            // '${_data.rating}',v
                                            textAlign: TextAlign.center,
                                            style: titleStyle
                                                .copyWith(
                                                  fontSize: 34,
                                                )
                                                .usePoppinsW5Font(),
                                          ),
                                          mediumHorizontalSpacing(),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomRatingBar(
                                                initialRating: data.rating,
                                                isEditable: true,
                                                itemSize: 25,
                                              ),
                                              smallVerticalSpacing(),
                                              Text(
                                                'Based On ${data.ratingCount} Reviews',
                                                style: titleStyle
                                                    .copyWith(
                                                      fontSize: 12,
                                                    )
                                                    .usePoppinsW4Font(),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // const FormContactUs(),
                                largeVerticalSpacing(),
                                ...List.generate(
                                  data.list.length,
                                  (index) => RatingListTile(
                                    ratingItem: data.list[index],
                                  ),
                                ),
                                mediumVerticalSpacing(),
                              ],
                            );

                    default:
                      return const SizedBox.shrink();
                  }
                });
          }),
        ),
      ),
    );
  }
}
