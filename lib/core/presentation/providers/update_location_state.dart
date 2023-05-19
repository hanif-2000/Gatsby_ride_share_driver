import 'package:appkey_taxiapp_driver/features/order/data/models/create_order_response_model.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/update_loc_response_model.dart';
import '../../error/failure.dart';

abstract class UpdateLocationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateLocationInitial extends UpdateLocationState {}

class UpdateLocationLoading extends UpdateLocationState {}

class UpdateLocationLoaded extends UpdateLocationState {
  final UpdateLocationResponseModel data;

  UpdateLocationLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class UpdateLocationFailure extends UpdateLocationState {
  final Failure failure;

  UpdateLocationFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
