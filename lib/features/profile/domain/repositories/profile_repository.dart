import 'package:appkey_taxiapp_driver/features/about_us/data/models/aboutus_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/edit_profile_response_model.dart';
import '../../data/models/profile_response_model.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileDataModel>> getProfile();
  Future<Either<Failure, int>> updateProfile(String url, FormData formData);
  Future<Either<Failure, int>> updateEmail(FormData formData);
  Future<Either<Failure, EditProfileResponseModel>> updatePassword(
      FormData formData);
  Future<Either<Failure, String?>> doUploadProfile(String image);
}
