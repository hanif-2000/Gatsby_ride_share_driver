import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/receipt/data/model/receipt_model.dart';
import 'package:dio/dio.dart';

abstract class ReceiptDataSource {
  Future<ReceiptDataModel> getReceipt(String id);
}

class ReceiptDataSourceImplementation implements ReceiptDataSource {
  final Dio dio;

  ReceiptDataSourceImplementation({required this.dio});

  @override
  Future<ReceiptDataModel> getReceipt(String id) async {
    String url = 'api/webservice/driver/order/receipt';
    logMe('Request data ---> $id');

    try {
      final response = await dio.post(
        url,
        data: FormData.fromMap({'id': id}),
      );
      final model = ReceiptDataModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
