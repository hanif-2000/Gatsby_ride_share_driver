import 'package:equatable/equatable.dart';

import '../../../order/domain/entities/order_detail.dart';

abstract class OrderDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OrderDetailInitial extends OrderDetailState {}

class OrderDetailLoading extends OrderDetailState {}

class OrderDetailLoaded extends OrderDetailState {
  final OrderDetail data;
  OrderDetailLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class OrderDetailFailure extends OrderDetailState {
  final String failure;

  OrderDetailFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
