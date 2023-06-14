import 'package:appkey_taxiapp_driver/core/data/models/request_list_model.dart';
import 'package:equatable/equatable.dart';

import '../../error/failure.dart';

abstract class RequestListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RequestListEmpty extends RequestListState {}

class RequestListLoading extends RequestListState {}

class RequestListLoaded extends RequestListState {
  final List<RequestListModel> data;

  RequestListLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class RequestListFailure extends RequestListState {
  final Failure failure;

  RequestListFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
