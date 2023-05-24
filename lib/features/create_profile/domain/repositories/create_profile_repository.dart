import 'package:appkey_taxiapp_driver/features/create_profile/data/model/create_profile_response_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

abstract class CreateProfileRepository {
  Future<Either<Failure, CreateProfileResponseModel?>> doCreateProfile(
      String url, Map<String, dynamic> mapData);
}
