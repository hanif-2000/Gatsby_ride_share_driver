import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/model/image_upload_response.dart';
import 'package:appkey_taxiapp_driver/features/profile/data/models/edit_profile_response_model.dart';
import 'package:dio/dio.dart';
import '../../../../core/utility/helper.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../models/profile_response_model.dart';

abstract class ProfileDataSource {
  Future<ProfileDataModel> getProfile();
  Future<int> updateProfile(String url, FormData formData);
  Future<int> updateEmail(FormData formData);
  Future<String?> doUploadProfile(String image);
  Future<EditProfileResponseModel> updatePassword(FormData formData);
}

class ProfileDataSourceImplementation implements ProfileDataSource {
  final Dio dio;

  ProfileDataSourceImplementation({required this.dio});

  @override
  Future<ProfileDataModel> getProfile() async {
    log("get profile called-----");
    final session = locator<Session>();
    String tokenDriver = session.sessionToken;
    String url = 'api/webservice/driver/profile';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );

      log("response data is ${response.data}");
      log("get profile data message is ${response.data["message"]}");

      if (response.data['message'] == "Account Suspended") {
        showToast(message: "Account Suspended");
      }
      final model = ProfileResponseModel.fromJson(response.data);

      log("get profile data is ${model.data}");

      if (model.success == 1) {
        log("success is 1");
        return model.data;
      }
      // else if ((response.data["message"] == "Account Suspended") &&
      //     (response.data["success"] == 0)) {
      //   log("success is 0");
      //   log("account suspended");
      //   showToast(message: "Account Suspended");

      //   return response.data["message"];
      // }
      else {
        return response.data["message"];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> updateProfile(String url, FormData formData) async {
    // String url = 'api/webservice/driver/update-profile';
    print('User request data ---> ${formData.fields.toString()}');
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

  @override
  Future<String?> doUploadProfile(String image) async {
    String url = 'api/webservice/upload';
    FormData data = FormData.fromMap({
      "upload": await MultipartFile.fromFile(
        image,
        filename: image.split('/').last,
      ),
    });
    try {
      final response = await dio.post(
        url,
        data: data,
      );
      print('Signup response ---> ${response.data}');
      final model = ImageUploadResponse.fromMap(response.data);
      if (model.success == 1) {
        return model.fileName;
      } else {
        return '';
      }
    } catch (e) {
      rethrow;
    }
  }
}
