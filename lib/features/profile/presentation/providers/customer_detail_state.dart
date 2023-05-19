import 'package:equatable/equatable.dart';

import '../../../../core/data/models/customer_detail_model.dart';

abstract class CustomerDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CustomerDetailInitial extends CustomerDetailState {}

class CustomerDetailLoading extends CustomerDetailState {}

class CustomerDetailLoaded extends CustomerDetailState {
  final CustomerDetailModel data;
  CustomerDetailLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class CustomerDetailFailure extends CustomerDetailState {
  final String failure;

  CustomerDetailFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
