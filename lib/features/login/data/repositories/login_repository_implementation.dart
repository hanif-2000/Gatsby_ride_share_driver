import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_data_source.dart';
import '../models/login_response_model.dart';

class LoginRepositoryImplementation implements LoginRepository {
  final LoginDataSource dataSource;

  LoginRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, LoginDataModel?>> doLogin(
      String email, String password, String position) async {
    try {
      final data = await dataSource.doLogin(email, password, position);
      if (data!.success == 1) {
        return Right(data.data);
      } else {
        return Left(ServerFailure(message: data.message));
      }
    } on DioException catch (e) {
      logMe("Failure login repository ${e.toString()}");
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      // Try to extract server message from response body
      String? serverMessage;
      if (responseData is Map) {
        serverMessage = responseData['message']?.toString() ??
            responseData['error']?.toString();
      }

      if (statusCode == 422) {
        return Left(ServerFailure(message: serverMessage ?? "Invalid email or password. Please check your credentials."));
      }
      if (statusCode == 403) {
        return Left(ServerFailure(message: serverMessage ?? "Your account is under review. Please wait for admin approval."));
      }
      if (statusCode == 401) {
        return Left(ServerFailure(message: serverMessage ?? "Incorrect email or password."));
      }
      if (statusCode != null && statusCode >= 500) {
        return Left(ServerFailure(message: "Server error. Please try again later."));
      }
      return Left(ServerFailure(message: serverMessage ?? "Something went wrong. Please try again."));
    } catch (e) {
      logMe("Failure login repository ${e.toString()}");
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
