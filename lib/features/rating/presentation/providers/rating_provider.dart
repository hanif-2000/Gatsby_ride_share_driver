import 'package:appkey_taxiapp_driver/core/presentation/providers/form_provider.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/rating/domain/usercases/do_rating.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/providers/rating_list_state.dart';
import 'package:appkey_taxiapp_driver/features/rating/presentation/providers/rating_state.dart';
import 'package:dio/dio.dart';

class RatingProvider extends FormProvider {
  final DoRating doRating;

  RatingProvider({required this.doRating});

  double rating = 1;

  updateRating(double value) {
    rating = value;
    notifyListeners();
  }

  Stream<RatingState> addRating({int? customerId, int? orderId}) async* {
    yield RatingLoading();
    final session = locator<Session>();
    final ratingResult = await doRating.call(FormData.fromMap({
      'id': customerId,
      'order_id': session.orderId,
      'rating': rating,
      'review': firstNameController.text.trim(),
      'type': '2',
    }));
    yield* ratingResult.fold((statusCode) async* {
      logMe(statusCode);
      yield RatingFailure(failure: statusCode.message);
    }, (result) async* {
      if (result != null) {
        yield RatingSuccess(data: result.message);
      } else {
        yield RatingFailure(failure: "Please try again!");
      }
    });
  }

  Stream<RatingListState> getRatingList({
    String? userId,
    String? type = '2',
  }) async* {
    yield RatingListLoading();
    // final session = locator<Session>();
    final ratingResult = await doRating.getRatings(
        FormData.fromMap(
          {
            'id': userId,
            'type': type,
          },
        ),
        'api/webservice/rating/list');
    yield* ratingResult.fold((statusCode) async* {
      logMe(statusCode);
      yield RatingListFailure(failure: statusCode.message);
    }, (result) async* {
      if (result != null) {
        yield RatingListSuccess(data: result);
      } else {
        yield RatingListFailure(failure: 'Please try again!');
      }
    });
  }
}
