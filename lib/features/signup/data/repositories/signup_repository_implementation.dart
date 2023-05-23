import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/signup/data/datasource/signup_data_source.dart';
import 'package:appkey_taxiapp_driver/features/signup/data/model/signup_response_model.dart';
import 'package:appkey_taxiapp_driver/features/signup/domain/repositories/signup_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

class SignupRepositoryImplementation implements SignupRepository {
  final SignupDataSource dataSource;

  SignupRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, SignupDataModel?>> doSignup(
      String email, String password) async {
    try {
      final data = await dataSource.doSignup(email, password);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure Signup repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
