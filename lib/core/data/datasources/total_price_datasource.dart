import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/data/models/total_price_model.dart';
import 'package:dio/dio.dart';

abstract class TotalPriceDataSource {
  Future<TotalPriceModel> getTotalPrice(
      String kategoriId, String distance, String night);
}

class TotalPriceDataSourceImplementation implements TotalPriceDataSource {
  final Dio dio;

  TotalPriceDataSourceImplementation({required this.dio});

  @override
  Future<TotalPriceModel> getTotalPrice(
      String kategoriId, String distance, String night) async {
    String path =
        'api/webservice/total-price-order?id_kategori=$kategoriId&distance=$distance&night_service=$night';

    try {
      final response = await dio.get(path);
      return TotalPriceModel.fromJson(response.data);
    } catch (e) {
      log("Total price detail Error TotalPriceDataSourceImplementation : ",
          error: e);
      rethrow;
    }
  }
}
