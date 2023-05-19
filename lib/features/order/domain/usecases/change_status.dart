import 'package:appkey_taxiapp_driver/features/order/data/models/create_order_response_model.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

abstract class ChangeStatusUseCase<Type> {
  Future<Either<Failure, ChangeStatusesponseModel>> execute(FormData formData);
}

class ChangeStatus implements ChangeStatusUseCase<String> {
  final OrderRepository repository;

  ChangeStatus({required this.repository});

  @override
  Future<Either<Failure, ChangeStatusesponseModel>> execute(
      FormData formData) async {
    final result = await repository.changeStatus(formData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
