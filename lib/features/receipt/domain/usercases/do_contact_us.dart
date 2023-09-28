import 'package:appkey_taxiapp_driver/features/receipt/data/model/receipt_model.dart';
import 'package:appkey_taxiapp_driver/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class ReceiptUseCase<Type> {
  Future<Either<Failure, ReceiptDataModel>> call(
      String id, String time, String distance);
}

class DoReceipt implements ReceiptUseCase<String> {
  final ReceiptRepository repository;

  DoReceipt({required this.repository});

  @override
  Future<Either<Failure, ReceiptDataModel>> call(
      String id, String time, String distance) async {
    final result = await repository.getReceipt(id, time, distance);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
