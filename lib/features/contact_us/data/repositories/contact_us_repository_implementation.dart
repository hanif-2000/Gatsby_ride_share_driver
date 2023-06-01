import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/data/datasource/contact_us_data_source.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/data/model/contact_us_model.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/domain/repositories/contact_us_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

class ContactUsRepositoryImplementation implements ContactUsRepository {
  final ContactUsDataSource dataSource;

  ContactUsRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, ContactUsResponseModel>> doContactUs(
      String url, FormData formData) async {
    try {
      final data = await dataSource.doContactUs(url, formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure ForgotPassword repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
