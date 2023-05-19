import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/forgot_password_response_model.dart';

abstract class ForgotPasswordRepository {
  Future<Either<Failure, ForgotPasswordResponseModel>> doForgotPassword(
      FormData formData);
}
