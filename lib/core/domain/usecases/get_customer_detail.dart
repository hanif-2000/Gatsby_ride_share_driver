import 'package:appkey_taxiapp_driver/core/domain/entities/currency.dart';
import 'package:appkey_taxiapp_driver/core/domain/repositories/currency_repository.dart';
import 'package:appkey_taxiapp_driver/core/domain/repositories/customer_detail_repository.dart';
import 'package:dartz/dartz.dart';

import '../../data/models/customer_detail_model.dart';
import '../../error/failure.dart';

abstract class GetCustomerDetailUseCase<Type> {
  Future<Either<Failure, CustomerDetailModel>> call(String userId);
}

class GetCustomerDetail implements GetCustomerDetailUseCase {
  CustomerDetailRepository repository;

  GetCustomerDetail(this.repository);

  @override
  Future<Either<Failure, CustomerDetailModel>> call(String userId) async {
    return await repository.getCustomerDetail(userId);
  }
}
