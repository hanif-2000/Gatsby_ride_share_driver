import 'package:appkey_taxiapp_driver/core/data/models/reject_data_model.dart';
import 'package:appkey_taxiapp_driver/core/data/models/request_list_model.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/order/data/models/create_order_response_model.dart';
import 'package:appkey_taxiapp_driver/features/order/data/models/get_status_response.dart';
import 'package:appkey_taxiapp_driver/features/order/data/models/status_oder_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/driver_detail.dart';
import '../../domain/entities/order_detail.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_data_source.dart';
import '../models/driver_location_response_model.dart';

class OrderRepositoryImplementation implements OrderRepository {
  final OrderDataSource dataSource;

  OrderRepositoryImplementation({required this.dataSource});

  @override
  Future<Either<Failure, ChangeStatusesponseModel>> changeStatus(
      FormData formData) async {
    try {
      final data = await dataSource.changeStatus(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure Order repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, RequestListDataModel>> getRequestListData(
      FormData formData) async {
    try {
      final data = await dataSource.getRequestListData(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure Order repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, UpdateStatusOrderResponseModel>> updateStatusOrder(
      FormData formData) async {
    try {
      final data = await dataSource.updateStatusOrder(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure Update status Order repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, GetStatusResponseModel>> getStatusOrder() async {
    try {
      final data = await dataSource.getStatusOrder();
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure get status Order repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, OrderDetail>> getDetailOrder(String orderId) async {
    try {
      final data = await dataSource.getDetailOrder(orderId);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure getDetailOrder repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, DriverDetail>> getDriverDetail() async {
    try {
      final data = await dataSource.getDriverDetail();
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure getDriverDetail repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, DriverLocationResponseModel>>
      getDriverLocation() async {
    try {
      final data = await dataSource.getDriverLocation();
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure getDriverLocation repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, RejectDataModel>> rejectRequest(
      FormData formData) async {
    try {
      final data = await dataSource.rejectRequest(formData);
      return Right(data);
    } on DioError catch (e) {
      logMe("Failure getDriverLocation repository ${e.toString()}");
      return Left(ServerFailure(message: e.message));
    }
  }
}
