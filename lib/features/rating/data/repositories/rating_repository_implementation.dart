import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/rating/data/datasource/rating_data_source.dart';
import 'package:appkey_taxiapp_driver/features/rating/data/model/rating_list_data_model.dart';
import 'package:appkey_taxiapp_driver/features/rating/data/model/rating_model.dart';
import 'package:appkey_taxiapp_driver/features/rating/domain/repositories/rating_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

class RatingRepositoryImplementation implements RatingRepository {
  final RatingDataSource dataSource;

  RatingRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, RatingModel?>> doRating(FormData formData) async {
    try {
      final data = await dataSource.doRating(formData);
      if (data!.success == 1) {
        return Right(data);
      } else {
        return Left(ServerFailure(message: data.message));
      }
    } on DioError catch (e) {
      logMe("Failure login repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, RatingListDataModel?>> getRatings(
      FormData formData, String url) async {
    try {
      final data = await dataSource.getRatings(formData, url);
      if (data!.success == 1) {
        return Right(data);
      } else {
        return Left(ServerFailure(message: data.message));
      }
    } on DioError catch (e) {
      logMe("Failure login repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
