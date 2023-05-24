import 'package:appkey_taxiapp_driver/core/utility/firebase_helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/model/create_profile_response_model.dart';
import 'package:appkey_taxiapp_driver/features/signup/data/model/signup_response_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';

abstract class CreateProfileDataSource {
  Future<CreateProfileResponseModel?> doCreateProfile(
      String url, Map<String, dynamic> data);
}

class CreateProfileDataSourceImplementation implements CreateProfileDataSource {
  final Dio dio;

  CreateProfileDataSourceImplementation({required this.dio});

  @override
  Future<CreateProfileResponseModel?> doCreateProfile(
      String url, Map<String, dynamic> mapData) async {
    // String url = 'api/webservice/driver/signup';
    await FirebaseHelper.setupMessaging();
    final session = locator<Session>();
    // String fcmToken = session.sessionFcmToken;
    FormData data = FormData.fromMap(mapData);
    try {
      final response = await dio.post(
        url,
        data: data,
      );
      print('Signup response ---> ${response.data}');
      final model = CreateProfileResponseModel.fromJson(response.data);
      final session = locator<Session>();
      if (model.success == 1) {
        // session.setUserId = model.data!.driverId.toString();
        // session.setToken = model.token!;
        // session.setSessionCategoryId = model.data!.categoryId.toString();
        return model;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
