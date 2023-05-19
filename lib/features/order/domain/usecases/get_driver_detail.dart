import 'package:appkey_taxiapp_driver/core/domain/entities/price_category_list.dart';
import 'package:appkey_taxiapp_driver/core/domain/repositories/price_category_repository.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/driver_detail.dart';

abstract class GetDriverDetailUseCase<Type> {
  Future<Either<Failure, DriverDetail>> call();
}

class GetDriverDetail implements GetDriverDetailUseCase {
  OrderRepository repository;

  GetDriverDetail({required this.repository});

  @override
  Future<Either<Failure, DriverDetail>> call() async {
    return await repository.getDriverDetail();
  }
}
