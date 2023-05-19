import 'package:equatable/equatable.dart';

class EditProfileResponseModel extends Equatable {
  final int success;
  final String? message;

  const EditProfileResponseModel({
    required this.success,
    this.message,
  });

  @override
  List<Object?> get props => [success, message];

  factory EditProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      EditProfileResponseModel(
        message: json['message'] ?? '',
        success: json['success'] ?? 1,
      );
  Map<String, dynamic> toJson() =>
      {'message': message ?? '', 'success': success};
}
