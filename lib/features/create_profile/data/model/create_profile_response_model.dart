import 'package:equatable/equatable.dart';

class CreateProfileResponseModel extends Equatable {
  final num? success;
  final String? message;

  const CreateProfileResponseModel({this.message, this.success});

  @override
  List<Object?> get props => [success, message];

  factory CreateProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateProfileResponseModel(
          success: json['status'] == true ? 1 : (json['success'] ?? 0),
          message: json['message']);

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
      };
}
