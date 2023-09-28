import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/receipt/data/datasource/receipt_data_source.dart';
import 'package:appkey_taxiapp_driver/features/receipt/data/model/receipt_model.dart';
import 'package:appkey_taxiapp_driver/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

class ReceiptRepositoryImplementation implements ReceiptRepository {
  final ReceiptDataSource dataSource;

  ReceiptRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, ReceiptDataModel>> getReceipt(
      String id, String time, String distance) async {
    try {
      final data = await dataSource.getReceipt(id, time, distance);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure ForgotPassword repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
