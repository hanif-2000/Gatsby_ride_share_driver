import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/datasource/create_profile_data_source.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/model/create_profile_response_model.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/domain/repositories/create_profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

class CreateProfileRepositoryImplementation implements CreateProfileRepository {
  final CreateProfileDataSource dataSource;

  CreateProfileRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, CreateProfileResponseModel?>> doCreateProfile(
      String url, Map<String, dynamic> mapData) async {
    try {
      final data = await dataSource.doCreateProfile(url, mapData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure Signup repository -- ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
