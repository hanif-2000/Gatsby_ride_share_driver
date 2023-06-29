import 'package:appkey_taxiapp_driver/features/rating/data/model/rating_list_data_model.dart';
import 'package:equatable/equatable.dart';

abstract class RatingListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RatingListInitial extends RatingListState {}

class RatingListLoading extends RatingListState {}

class RatingListSuccess extends RatingListState {
  final RatingListDataModel? data;

  RatingListSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}

class RatingListFailure extends RatingListState {
  final String failure;

  RatingListFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
