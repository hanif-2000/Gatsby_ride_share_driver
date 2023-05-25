import 'package:appkey_taxiapp_driver/features/create_profile/data/model/create_profile_response_model.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/model/vehicle_type_respose_model.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/domain/repositories/create_profile_repository.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class CreateProfileUseCase<Type> {
  // return statusCode when fails
  // return token when succeed
  Future<Either<Failure, CreateProfileResponseModel?>> call(
      String url, Map<String, dynamic> mapData);

  Future<Either<Failure, String?>> upload(String image);

  Future<Either<Failure, List<VehicleTypeDataModel>?>> getVehicleTypes();
}

class DoCreateProfile implements CreateProfileUseCase<String> {
  final CreateProfileRepository repository;

  DoCreateProfile({required this.repository});

  @override
  Future<Either<Failure, CreateProfileResponseModel?>> call(
      String url, Map<String, dynamic> mapData) async {
    final result = await repository.doCreateProfile(url, mapData);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }

  @override
  Future<Either<Failure, String?>> upload(String image) async {
    final result = await repository.doUploadProfile(image);
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }

  @override
  Future<Either<Failure, List<VehicleTypeDataModel>?>> getVehicleTypes() async {
    final result = await repository.getVehicleTypes();
    return result.fold((l) => Left(l), (r) {
      return Right(r);
    });
  }
}
