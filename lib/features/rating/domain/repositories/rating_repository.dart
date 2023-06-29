import 'package:appkey_taxiapp_driver/features/rating/data/model/rating_list_data_model.dart';
import 'package:appkey_taxiapp_driver/features/rating/data/model/rating_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

abstract class RatingRepository {
  Future<Either<Failure, RatingModel?>> doRating(FormData data);

  Future<Either<Failure, RatingListDataModel?>> getRatings(
      FormData data, String url);
}
