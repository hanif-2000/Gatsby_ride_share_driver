import 'package:appkey_taxiapp_driver/features/receipt/data/model/receipt_model.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class ReceiptRepository {
  Future<Either<Failure, ReceiptDataModel>> getReceipt(String id);
}
