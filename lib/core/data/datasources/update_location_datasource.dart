import 'package:appkey_taxiapp_driver/core/data/models/update_loc_response_model.dart';
import 'package:dio/dio.dart';

abstract class UpdateLocationDataSource {
  Future<UpdateLocationResponseModel> doUpdateLocation(FormData formData);
}

class UpdateLocationDataSourceImplementation
    implements UpdateLocationDataSource {
  final Dio dio;

  UpdateLocationDataSourceImplementation({required this.dio});

  @override
  Future<UpdateLocationResponseModel> doUpdateLocation(
      FormData formData) async {
    String url = 'api/webservice/driver/update-coordinate';

    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = UpdateLocationResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
