import 'package:appkey_taxiapp_driver/core/data/models/reject_data_model.dart';
import 'package:equatable/equatable.dart';

import '../../error/failure.dart';

abstract class RejectRequestState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RejectRequestEmpty extends RejectRequestState {}

class RejectRequestLoading extends RejectRequestState {}

class RejectRequestLoaded extends RejectRequestState {
  final RejectDataModel data;

  RejectRequestLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class RejectRequestFailure extends RejectRequestState {
  final Failure failure;

  RejectRequestFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
