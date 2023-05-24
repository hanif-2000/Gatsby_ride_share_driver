import 'package:appkey_taxiapp_driver/features/create_profile/data/model/create_profile_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class CreateProfileState extends Equatable{
  @override
  List<Object?> get props => [];
}

class CreateProfileInitial extends CreateProfileState{}

class CreateProfileLoading extends CreateProfileState{}

class CreateProfileSuccess extends CreateProfileState{
  final CreateProfileResponseModel data;
  CreateProfileSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class CreateProfileFailure extends CreateProfileState{
  final String failure;

  CreateProfileFailure({required this.failure});

  @override
  List<Object?> get props => [failure];

}