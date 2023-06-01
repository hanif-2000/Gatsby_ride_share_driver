import 'package:appkey_taxiapp_driver/features/contact_us/data/model/contact_us_model.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/domain/repositories/contact_us_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

abstract class ContactUsUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, ContactUsResponseModel>> call(
      String url, FormData formData);
}

class DoContactUs implements ContactUsUseCase<String> {
  final ContactUsRepository repository;

  DoContactUs({required this.repository});

  @override
  Future<Either<Failure, ContactUsResponseModel>> call(
      String url, FormData formData) async {
    final result = await repository.doContactUs(url, formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
