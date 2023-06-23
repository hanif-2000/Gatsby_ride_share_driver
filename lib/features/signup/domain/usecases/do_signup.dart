import 'package:appkey_taxiapp_driver/features/signup/data/model/signup_response_model.dart';
import 'package:appkey_taxiapp_driver/features/signup/domain/repositories/signup_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class SignupUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, SignupResponseModel?>> call(String email, String password, String position);
}

class DoSignup implements SignupUseCase<String> {
  final SignupRepository repository;

  DoSignup({required this.repository});

  @override
  Future<Either<Failure, SignupResponseModel?>> call(
      String email, String password, String position) async {
    final result = await repository.doSignup(email, password, position);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
