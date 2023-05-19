import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/update_loc_response_model.dart';
import '../repositories/update_location_repository.dart';

abstract class UpdateLocationUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, UpdateLocationResponseModel>> execute(
      FormData formData);
}

class DoUpdateLocation implements UpdateLocationUseCase<String> {
  final UpdateLocationRepository repository;

  DoUpdateLocation({required this.repository});

  @override
  Future<Either<Failure, UpdateLocationResponseModel>> execute(
      FormData formData) async {
    final result = await repository.doUpdateLocation(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
