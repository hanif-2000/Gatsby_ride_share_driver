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
    final session = locator<Session>();
    String tokenDriver = session.sessionToken;
    dio.withToken();
    
    // Debug Logging
    logMe('═══════════════════════════════════════');
    logMe('🔵 CREATE PROFILE API CALL');
    logMe('═══════════════════════════════════════');
    logMe('🔵 URL --> $url');
    logMe('🔵 Token --> $tokenDriver');
    logMe('🔵 Request Data:');
    mapData.forEach((key, value) {
      logMe('   $key: $value');
    });
    logMe('═══════════════════════════════════════');

    FormData data = FormData.fromMap(mapData);
    
    try {
      final response = await dio.post(
        url,
        data: data,
      );
      
      logMe('🟢 SUCCESS Response ---> ${response.data}');
      final model = CreateProfileResponseModel.fromJson(response.data);
      
      if (model.success == 1) {
        return model;
      } else {
        logMe('🟡 API returned success=0');
        return null;
      }
    } on DioException catch (e) {
      logMe('═══════════════════════════════════════');
      logMe('🔴 CREATE PROFILE ERROR');
      logMe('═══════════════════════════════════════');
      logMe('🔴 Status Code: ${e.response?.statusCode}');
      logMe('🔴 Response Data: ${e.response?.data}');
      logMe('🔴 Error Message: ${e.message}');
      logMe('🔴 Error Type: ${e.type}');
      logMe('═══════════════════════════════════════');
      rethrow;
    } catch (e) {
      logMe('🔴 Unknown Error: $e');
      rethrow;
    }
  }

  @override
  Future<String?> doUploadProfile(String image) async {
    String url = 'api/webservice/upload';
    
    logMe('═══════════════════════════════════════');
    logMe('🔵 UPLOAD IMAGE API CALL');
    logMe('🔵 URL --> $url');
    logMe('🔵 Image Path --> $image');
    logMe('═══════════════════════════════════════');
    
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
      logMe('🟢 Upload Response ---> ${response.data}');
      final model = ImageUploadResponse.fromMap(response.data);
      if (model.success == 1) {
        return model.fileName;
      } else {
        return '';
      }
    } on DioException catch (e) {
      logMe('🔴 Upload Error: ${e.response?.statusCode}');
      logMe('🔴 Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      logMe('🔴 Unknown Upload Error: $e');
      rethrow;
    }
  }

  @override
  Future<VehicleTypeResponseModel> getVehicleTypes() async {
    String url = 'api/webservice/vehicle/categories';
    
    logMe('═══════════════════════════════════════');
    logMe('🔵 GET VEHICLE TYPES API CALL');
    logMe('🔵 URL --> $url');
    logMe('═══════════════════════════════════════');
    
    try {
      final response = await dio.get(
        url,
      );
      logMe('🟢 Vehicle Types Response ---> ${response.data}');
      final model = VehicleTypeResponseModel.fromMap(response.data);
      return model;
    } on DioException catch (e) {
      logMe('🔴 Vehicle Types Error: ${e.response?.statusCode}');
      logMe('🔴 Response: ${e.response?.data}');
      rethrow;
    } catch (e) {
      logMe('🔴 Unknown Error: $e');
      rethrow;
    }
  }
}