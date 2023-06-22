import 'package:appkey_taxiapp_driver/features/receipt/data/model/receipt_model.dart';
import 'package:equatable/equatable.dart';

abstract class ReceiptState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReceiptInitial extends ReceiptState {}

class ReceiptLoading extends ReceiptState {}

class ReceiptSuccess extends ReceiptState {
  final ReceiptDataModel? data;

  ReceiptSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class ReceiptFailure extends ReceiptState {
  final String failure;

  ReceiptFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
