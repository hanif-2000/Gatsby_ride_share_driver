import 'dart:developer';
import 'package:dio/dio.dart';
import '../../utility/injection.dart';
import '../../utility/session_helper.dart';
import '../models/customer_detail_model.dart';

abstract class CustomerDetailDataSource {
  Future<CustomerDetailModel> getCustomerDetail(String userId);
}

class CustomerDetailDataSourceImplementation
    implements CustomerDetailDataSource {
  final Dio dio;

  CustomerDetailDataSourceImplementation({required this.dio});

  @override
  Future<CustomerDetailModel> getCustomerDetail(String userId) async {
    final session = locator<Session>();
    String token = session.sessionToken;
    String path =
        'api/webservice/driver/customer-by-id?id=$userId';

    try {
      final response = await dio.get(path);
      return CustomerDetailModel.fromJson(response.data);
    } catch (e) {
      log("CustomerDetail detail Error CustomerDetailDataSourceImplementation : ",
          error: e);
      rethrow;
    }
  }
}
