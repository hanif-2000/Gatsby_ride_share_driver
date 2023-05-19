import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/features/profile/data/models/edit_profile_response_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../models/profile_response_model.dart';

abstract class ProfileDataSource {
  Future<ProfileDataModel> getProfile();
  Future<int> updateProfile(FormData formData);
  Future<int> updateEmail(FormData formData);
  Future<EditProfileResponseModel> updatePassword(FormData formData);
}

class ProfileDataSourceImplementation implements ProfileDataSource {
  final Dio dio;

  ProfileDataSourceImplementation({required this.dio});

  @override
  Future<ProfileDataModel> getProfile() async {
    final session = locator<Session>();
    String tokenDriver = session.sessionToken;
    String url = 'api/webservice/driver/profile';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );
      final model = ProfileResponseModel.fromJson(response.data);
      return model.data;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> updateProfile(FormData formData) async {
    String url = 'api/webservice/driver/update-profile';
    dio.withToken();
    try {
      final response = await dio.post(url, data: formData);
      final model = EditProfileResponseModel.fromJson(response.data);
      return model.success;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> updateEmail(FormData formData) async {
    String url = 'api/webservice/driver/update-email';
    dio.withToken();
    try {
      final response = await dio.post(url, data: formData);
      final model = EditProfileResponseModel.fromJson(response.data);
      return model.success;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<EditProfileResponseModel> updatePassword(FormData formData) async {
    String url = 'api/webservice/driver/update-password';
    dio.withToken();
    try {
      final response = await dio.post(url, data: formData);
      final model = EditProfileResponseModel.fromJson(response.data);
      return model;
    } catch (e) {
      rethrow;
    }
  }
}
