import 'package:appkey_taxiapp_driver/features/rating/data/model/rating_list_data_model.dart';
import 'package:appkey_taxiapp_driver/features/rating/data/model/rating_model.dart';
import 'package:appkey_taxiapp_driver/features/rating/domain/repositories/rating_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failure.dart';

abstract class RatingUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, RatingModel?>> call(FormData data);

  Future<Either<Failure, RatingListDataModel?>> getRatings(
      FormData data, String url);
}

class DoRating implements RatingUseCase<String> {
  final RatingRepository repository;

  DoRating({required this.repository});

  @override
  Future<Either<Failure, RatingModel?>> call(FormData formData) async {
    final result = await repository.doRating(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }

  @override
  Future<Either<Failure, RatingListDataModel?>> getRatings(
      FormData formData, String url) async {
    final result = await repository.getRatings(formData, url);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
