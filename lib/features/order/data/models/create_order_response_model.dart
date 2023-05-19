import 'package:equatable/equatable.dart';

class ChangeStatusesponseModel extends Equatable {
  final int success;
  final String? message;

  const ChangeStatusesponseModel({
    required this.success,
    this.message,
  });

  @override
  List<Object?> get props => [success, message];

  factory ChangeStatusesponseModel.fromJson(Map<String, dynamic> json) =>
      ChangeStatusesponseModel(
        message: json['message'] ?? '',
        success: json['success'] ?? 1,
      );
  Map<String, dynamic> toJson() =>
      {'message': message ?? '', 'success': success};
}
