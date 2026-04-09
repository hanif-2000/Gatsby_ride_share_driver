import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/model/create_profile_response_model.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/model/image_upload_response.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/model/vehicle_type_respose_model.dart';
import 'package:dio/dio.dart';

import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';

abstract class CreateProfileDataSource {
  Future<CreateProfileResponseModel?> doCreateProfile(
      String url, Map<String, dynamic> data);

  Future<String?> doUploadProfile(String image);

  Future<VehicleTypeResponseModel> getVehicleTypes();
}

class CreateProfileDataSourceImplementation implements CreateProfileDataSource {
  final Dio dio;

  CreateProfileDataSourceImplementation({required this.dio});

  @override
  Future<CreateProfileResponseModel?> doCreateProfile(
      String url, Map<String, dynamic> mapData) async {
    // String url = 'api/webservice/driver/signup';
    // await FirebaseHelper.setupMessaging();
    final session = locator<Session>();
    String tokenDriver = session.sessionToken;
    // String fcmToken = session.sessionFcmToken;
    dio.withToken();
    logMe('Create profile url --> $url');
    logMe('Create profile data --> ${mapData.toString()}');

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

  @override
  Future<String?> doUploadProfile(String image) async {
    String url = 'api/webservice/upload';
    final session = locator<Session>();
    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        image,
        filename: image.split('/').last,
      ),
    });
    try {
      final response = await dio.post(
        url,
        data: data,
        options: Options(headers: {
          "Authorization": "Bearer ${session.sessionToken}",
        }),
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

  @override
  Future<VehicleTypeResponseModel> getVehicleTypes() async {
    String url = 'api/webservice/vehicleCategories';
    try {
      final response = await dio.get(
        url,
      );
      print('Signup response ---> ${response.data}');
      final model = VehicleTypeResponseModel.fromMap(response.data);
      if (model.success == 1) {
        return model;
      } else {
        return model;
      }
    } catch (e) {
      rethrow;
    }
  }
}
