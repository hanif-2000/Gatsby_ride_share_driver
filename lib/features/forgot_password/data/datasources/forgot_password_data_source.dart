import 'package:appkey_taxiapp_driver/features/forgot_password/data/models/forgot_password_response_model.dart';
import 'package:dio/dio.dart';

abstract class ForgotPasswordDataSource {
  Future<ForgotPasswordResponseModel> doForgotPassword(
      String url, FormData formData);
}

class ForgotPasswordDataSourceImplementation
    implements ForgotPasswordDataSource {
  final Dio dio;

  ForgotPasswordDataSourceImplementation({required this.dio});

  @override
  Future<ForgotPasswordResponseModel> doForgotPassword(
      String url, FormData formData) async {
    // String url = 'api/webservice/reset-password-user';

    try {
      final response = await dio.post(
        url,
        data: formData,
      );
      final model = ForgotPasswordResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
