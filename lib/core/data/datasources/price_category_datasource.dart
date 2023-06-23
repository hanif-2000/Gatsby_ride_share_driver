import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/data/models/price_category_list_model.dart';
import 'package:appkey_taxiapp_driver/core/domain/entities/price_category_list.dart';
import 'package:dio/dio.dart';

abstract class PriceCategoryDataSource {
  Future<PriceCategoryList> getPriceCategoryList();
}

class PriceCategoryDataSourceImplementation implements PriceCategoryDataSource {
  final Dio dio;

  PriceCategoryDataSourceImplementation({required this.dio});

  @override
  Future<PriceCategoryList> getPriceCategoryList() async {
    String path = 'api/webservice/priceCategory';

    try {
      final response = await dio.post(path);
      return PriceCategoryListModel.fromJson(response.data);
    } catch (e) {
      log("PriceCategoryListModel detail Error PriceCategoryDataSourceImplementation : ",
          error: e);
      rethrow;
    }
  }
}
