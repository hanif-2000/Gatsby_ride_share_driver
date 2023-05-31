import 'package:equatable/equatable.dart';

abstract class ContactUsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ContactUsInitial extends ContactUsState {}

class ContactUsLoading extends ContactUsState {}

class ContactUsSuccess extends ContactUsState {
  final String? data;

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
