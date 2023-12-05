import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/data/models/history_data_model.dart';
import 'package:appkey_taxiapp_driver/core/data/models/reject_data_model.dart';
import 'package:appkey_taxiapp_driver/core/data/models/request_list_model.dart';
import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/features/order/data/models/detail_driver_response.dart';
import 'package:appkey_taxiapp_driver/features/order/data/models/detail_order_response_model.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/entities/driver_detail.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/entities/order_detail.dart';
import 'package:dio/dio.dart';
import '../../../../core/utility/helper.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../models/create_order_response_model.dart';
import '../models/driver_location_response_model.dart';
import '../models/get_status_response.dart';
import '../models/status_oder_response_model.dart';

abstract class OrderDataSource {
  Future<ChangeStatusesponseModel> changeStatus(FormData formData);

  Future<UpdateStatusOrderResponseModel> updateStatusOrder(FormData formData);

  Future<GetStatusResponseModel> getStatusOrder();

  Future<OrderDetail> getDetailOrder(String orderId);

  Future<DriverDetail> getDriverDetail();

  Future<DriverLocationResponseModel> getDriverLocation();

  Future<RequestListDataModel> getRequestListData(FormData formData);

  Future<RejectDataModel> rejectRequest(FormData formData);

  Future<HistoryDataModel> getHistoryListData();
}

class OrderDataSourceImplementation implements OrderDataSource {
  final Dio dio;

  OrderDataSourceImplementation({required this.dio});

  @override
  Future<ChangeStatusesponseModel> changeStatus(FormData formData) async {
    String url = 'api/webservice/driver/set-status';
    dio.withToken();
    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = ChangeStatusesponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RequestListDataModel> getRequestListData(FormData formData) async {
    String url = 'api/webservice/driver/requests/new';
    dio.withToken();
    try {
      final response = await dio.post(
        url,
        // data: formData,
      );
      final model = RequestListDataModel.fromMap(response.data);

      if (model.success == 1) {
        return model;
      } else if (response.data["message"] == "Account Suspended") {
        log("account suspended");
        showToast(message: "Account Suspended");

        return response.data["message"];
      }
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RejectDataModel> rejectRequest(FormData formData) async {
    String url = 'api/webservice/driver/order/reject';
    dio.withToken();
    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = RejectDataModel.fromMap(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<HistoryDataModel> getHistoryListData() async {
    String url = 'api/webservice/driver/order';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );
      final model = HistoryDataModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UpdateStatusOrderResponseModel> updateStatusOrder(
      FormData formData) async {
    String url = 'api/webservice/driver/update-status';
    dio.withToken();
    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = UpdateStatusOrderResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<GetStatusResponseModel> getStatusOrder() async {
    final session = locator<Session>();
    String orderId = session.runningOrderId.toString();
    String url = 'api/webservice/driver/order-status?id=$orderId';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );
      final model = GetStatusResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<OrderDetail> getDetailOrder(String orderId) async {
    String url = 'api/webservice//getOrder?id=$orderId';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );
      final model = OrderDetailResponseModel.fromJson(response.data);
      return model.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DriverDetail> getDriverDetail() async {
    final session = locator<Session>();
    String driverId = session.driverId;
    String url = 'api/webservice//driver-profile?id_driver=$driverId';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );
      final model = DriverDetailResponseModel.fromJson(response.data);
      return model.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<DriverLocationResponseModel> getDriverLocation() async {
    final session = locator<Session>();
    String driverId = session.driverId;
    String url = 'api/webservice/driver_location?id_driver=$driverId';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );
      final model = DriverLocationResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
