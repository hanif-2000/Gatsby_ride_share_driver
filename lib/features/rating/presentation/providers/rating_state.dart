import 'package:equatable/equatable.dart';

abstract class RatingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RatingInitial extends RatingState {}

class RatingLoading extends RatingState {}

class RatingSuccess extends RatingState {
  final String? data;

  RatingSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class RatingFailure extends RatingState {
  final String failure;

  RatingFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
