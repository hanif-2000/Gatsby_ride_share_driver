import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/data/model/contact_us_model.dart';
import 'package:dio/dio.dart';

abstract class ContactUsDataSource {
  Future<ContactUsResponseModel> doContactUs(String url, FormData formData);
}

class ContactUsDataSourceImplementation implements ContactUsDataSource {
  final Dio dio;

  ContactUsDataSourceImplementation({required this.dio});

  @override
  Future<ContactUsResponseModel> doContactUs(
      String url, FormData formData) async {
    // String url = 'api/webservice/reset-password-user';
    logMe('Request data ---> ${formData.fields.toString()}');

    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = ContactUsResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
