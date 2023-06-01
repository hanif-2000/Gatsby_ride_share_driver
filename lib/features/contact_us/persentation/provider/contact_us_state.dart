import 'package:appkey_taxiapp_driver/features/contact_us/data/model/contact_us_model.dart';
import 'package:equatable/equatable.dart';

abstract class ContactUsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsSuccess extends ContactUsState {
  final ContactUsResponseModel? data;

  ContactUsSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class ContactUsFailure extends ContactUsState {
  final String failure;

  ContactUsFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
