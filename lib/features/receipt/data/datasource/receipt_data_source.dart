import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/receipt/data/model/receipt_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';

abstract class ReceiptDataSource {
  Future<ReceiptDataModel> getReceipt(String id, String time, String distance);
}

class ReceiptDataSourceImplementation implements ReceiptDataSource {
  final Dio dio;

  ReceiptDataSourceImplementation({required this.dio});

  @override
  Future<ReceiptDataModel> getReceipt(
      String id, String time, String distance) async {
    String url = 'api/webservice/driver/order/receipt';
    logMe('Request data ---> $id');
    logMe('Request data ---> $time');
    logMe('Request data ---> $distance');

    final session = locator<Session>();

    try {
      final response = await dio.post(
        url,
        data: FormData.fromMap({'id': id, 'time': time, 'distance': distance}),
      );
      final model = ReceiptDataModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
