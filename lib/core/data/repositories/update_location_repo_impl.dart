import 'package:appkey_taxiapp_driver/core/data/datasources/update_location_datasource.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/update_location_repository.dart';
import '../models/update_loc_response_model.dart';

class UpdateLocationRepositoryImplementation
    implements UpdateLocationRepository {
  final UpdateLocationDataSource dataSource;

  UpdateLocationRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, UpdateLocationResponseModel>> doUpdateLocation(
      FormData formData) async {
    try {
      final data = await dataSource.doUpdateLocation(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure UpdateLocation repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
