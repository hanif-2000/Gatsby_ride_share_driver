import 'package:appkey_taxiapp_driver/core/data/models/request_list_model.dart';
import 'package:appkey_taxiapp_driver/features/order/data/models/get_status_response.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/create_order_response_model.dart';
import '../../data/models/driver_location_response_model.dart';
import '../../data/models/status_oder_response_model.dart';
import '../entities/driver_detail.dart';
import '../entities/order_detail.dart';

abstract class OrderRepository {
  Future<Either<Failure, ChangeStatusesponseModel>> changeStatus(
      FormData formData);

  Future<Either<Failure, UpdateStatusOrderResponseModel>> updateStatusOrder(
      FormData formData);

  Future<Either<Failure, GetStatusResponseModel>> getStatusOrder();

  Future<Either<Failure, OrderDetail>> getDetailOrder(String orderId);

  Future<Either<Failure, DriverDetail>> getDriverDetail();

  Future<Either<Failure, DriverLocationResponseModel>> getDriverLocation();

  Future<Either<Failure, RequestListDataModel>> getRequestListData(
      FormData formData);
}
