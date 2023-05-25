import 'package:equatable/equatable.dart';

abstract class UploadState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UploadInitial extends UploadState {}

class UploadLoading extends UploadState {}

class UploadSuccess extends UploadState {
  final String? data;

  UploadSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class UploadFailure extends UploadState {
  final String failure;

  UploadFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
