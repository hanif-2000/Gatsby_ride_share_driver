import 'package:appkey_taxiapp_driver/core/data/models/update_loc_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

abstract class UpdateLocationRepository {
  Future<Either<Failure, UpdateLocationResponseModel>> doUpdateLocation(
      FormData formData);
}
