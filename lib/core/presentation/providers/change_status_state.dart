import 'package:appkey_taxiapp_driver/features/order/data/models/create_order_response_model.dart';
import 'package:equatable/equatable.dart';

import '../../error/failure.dart';

abstract class ChangeStatusState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChangeStatusInitial extends ChangeStatusState {}

class ChangeStatusLoading extends ChangeStatusState {}

class ChangeStatusLoaded extends ChangeStatusState {
  final ChangeStatusesponseModel data;

  ChangeStatusLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class ChangeStatusFailure extends ChangeStatusState {
  final Failure failure;

  ChangeStatusFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
