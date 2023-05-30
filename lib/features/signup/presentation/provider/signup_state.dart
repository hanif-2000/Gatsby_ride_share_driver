import 'package:appkey_taxiapp_driver/features/signup/data/model/signup_response_model.dart';
import 'package:equatable/equatable.dart';


abstract class SignupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final SignupResponseModel? data;
  SignupSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class SignupFailure extends SignupState {
  final String failure;

  SignupFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
