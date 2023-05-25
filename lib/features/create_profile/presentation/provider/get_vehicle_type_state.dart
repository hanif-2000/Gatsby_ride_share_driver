import 'package:appkey_taxiapp_driver/features/create_profile/data/model/vehicle_type_respose_model.dart';
import 'package:equatable/equatable.dart';

abstract class GetVehicleTypeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetVehicleTypeInitial extends GetVehicleTypeState {}

class GetVehicleTypeLoading extends GetVehicleTypeState {}

class GetVehicleTypeSuccess extends GetVehicleTypeState {
  final List<VehicleTypeDataModel>? data;

  GetVehicleTypeSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetVehicleTypeFailure extends GetVehicleTypeState {
  final String failure;

  GetVehicleTypeFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
