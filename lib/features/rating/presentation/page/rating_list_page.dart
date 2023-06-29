import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/order_detail/presentation/widget/custom_rating_bar.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/providers/rating_list_state.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/providers/rating_provider.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/widgets/rating_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/utility/injection.dart';

class RatingListPage extends StatelessWidget {
  const RatingListPage({Key? key, required this.userId}) : super(key: key);
  static const routeName = '/RatingListPage';
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => locator<RatingProvider>(),
      child: Scaffold(
        backgroundColor: whiteColor,
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
                      final _data = (snapshot.data as RatingListSuccess).data;
                      return _data!.list.isEmpty
                          ? const Center(
                              child: Text('No rating yet!'),
                            )
                          : ListView(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20, bottom: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: SvgPicture.asset(
                                                'assets/icons/auth/ic_back.svg'),
                                          ),
                                          Text(
                                            appLoc.ratings,
                                            textAlign: TextAlign.center,
                                            style: titleStyle
                                                .copyWith(
                                                  fontSize: 18,
                                                )
                                                .usePoppinsW5Font(),
                                          ),
                                          const SizedBox(
                                            width: 30,
                                          ),
                                        ],
                                      ),
                                    ),
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
                                            '${_data.rating}',
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
                                              const CustomRatingBar(
                                                initialRating: 5,
                                                isEditable: true,
                                                itemSize: 25,
                                              ),
                                              smallVerticalSpacing(),
                                              Text(
                                                'Based On ${_data.ratingCount} Reviews',
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
                                  _data.list.length,
                                  (index) => RatingListTile(
                                    ratingItem: _data.list[index],
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
