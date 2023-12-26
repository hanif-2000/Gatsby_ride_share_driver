import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/features/rating/data/model/rating_list_data_model.dart';
import 'package:appkey_taxiapp_driver/features/rating/data/model/rating_model.dart';
import 'package:dio/dio.dart';

abstract class RatingDataSource {
  Future<RatingModel?> doRating(FormData data);

  Future<RatingListDataModel?> getRatings(FormData data, String url);
}

class RatingDataSourceImplementation implements RatingDataSource {
  final Dio dio;

  RatingDataSourceImplementation({required this.dio});

  @override
  Future<RatingModel> doRating(FormData formData) async {
    // String url = 'api/webservice/order/rating';
    String url = 'api/webservice/driver/order/rating';

    print('User request data ---> ${formData.fields.toString()}');
    dio.withToken();
    try {
      final response = await dio.post(url, data: formData);
      final model = RatingModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RatingListDataModel> getRatings(FormData formData, String url) async {
    // String url = 'api/webservice/order/rating';
    print('User request data ---> ${formData.fields.toString()}');
    dio.withToken();
    try {
      final response = await dio.post(url, data: formData);
      final model = RatingListDataModel.fromMap(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
