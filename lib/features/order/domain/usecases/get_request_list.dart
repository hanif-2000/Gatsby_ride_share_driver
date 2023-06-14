import 'package:appkey_taxiapp_driver/core/data/models/request_list_model.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/repositories/order_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';

abstract class GetRequestListUseCase<Type> {
  Future<Either<Failure, RequestListDataModel>> call(FormData data);
}

class GetRequestList implements GetRequestListUseCase {
  final OrderRepository repository;

  GetRequestList({required this.repository});

  @override
  Future<Either<Failure, RequestListDataModel>> call(FormData data) async {
    return await repository.getRequestListData(data);
  }
}
