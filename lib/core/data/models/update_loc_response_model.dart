import 'package:equatable/equatable.dart';

class UpdateLocationResponseModel extends Equatable {
  final int success;
  final String? message;

  const UpdateLocationResponseModel({
    required this.success,
    this.message,
  });

  @override
  List<Object?> get props => [success, message];

  factory UpdateLocationResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateLocationResponseModel(
        message: json['message'] ?? '',
        success: json['success'] ?? 1,
      );
  Map<String, dynamic> toJson() =>
      {'message': message ?? '', 'success': success};
}
