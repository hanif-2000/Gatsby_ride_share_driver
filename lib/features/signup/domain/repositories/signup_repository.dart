import 'package:appkey_taxiapp_driver/features/signup/data/model/signup_response_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class SignupRepository {
  Future<Either<Failure, SignupResponseModel?>> doSignup(
      String email, String password, String position);
}
