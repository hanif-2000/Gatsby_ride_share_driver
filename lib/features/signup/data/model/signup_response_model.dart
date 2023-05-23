import 'package:equatable/equatable.dart';

class SignupResponseModel extends Equatable {
  final SignupDataModel? data;
  final num? success;
  final String? token;
  final String? message;

  const SignupResponseModel(
      {this.data, this.success, this.token, this.message});

  @override
  List<Object?> get props => [/*data,*/ success, token];

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) =>
      SignupResponseModel(
        data: json['data'] == null
            ? null
            : SignupDataModel.fromJson(json['data']),
        token: json['token'] ?? '',
        success: json['success'] ?? 1,
        message: json['message'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'data': data == null ? '' : data!.toJson(),
        'token': token ?? '',
        'success': success ?? '',
        'message': message ?? ''
      };
}

class SignupDataModel extends Equatable {
  final num driverId;
  final String name;
  final String email;
  final String phoneNumber;
  final String fcmToken;
  final int status;
  final String image;
  final String categoryId;

  const SignupDataModel(
      {required this.driverId,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.fcmToken,
      required this.status,
      required this.categoryId,
      required this.image});

  @override
  List<Object?> get props =>
      [driverId, name, email, phoneNumber, fcmToken, status, image, categoryId];

  factory SignupDataModel.fromJson(Map<String, dynamic> json) =>
      SignupDataModel(
          driverId: json['id'],
          name: json['name'],
          email: json['email'],
          phoneNumber: json['phone'],
          fcmToken: json['fcm_token'] ?? '',
          image: json['image'] ?? '',
          categoryId: json['vehicle_category_id'] ?? '',
          status: json['status'] ?? '');

  Map<String, dynamic> toJson() => {
        'id': driverId,
        'name': name,
        'email': email,
        'telp_driver': phoneNumber,
        'fcm_token': fcmToken,
        'vehicle_category_id': categoryId,
        'image': image,
        'status': status,
      };
}
