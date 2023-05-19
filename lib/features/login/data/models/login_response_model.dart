import 'package:equatable/equatable.dart';

class LoginResponseModel extends Equatable {
  final LoginDataModel? data;
  final num? success;
  final String? token;

  const LoginResponseModel({
    this.data,
    this.success,
    this.token,
  });

  @override
  List<Object?> get props => [data, success, token];

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        data:
            json['user'] == null ? null : LoginDataModel.fromJson(json['user']),
        token: json['token'] ?? '',
        success: json['success'] ?? 1,
      );
  Map<String, dynamic> toJson() => {
        'data': data == null ? '' : data!.toJson(),
        'token': token ?? '',
        'success': success ?? '',
      };
}

class LoginDataModel extends Equatable {
  final num driverId;
  final String name;
  final String email;
  final String phoneNumber;
  final String fcmToken;
  final int status;
  final String image;
  final String categoryId;

  const LoginDataModel(
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

  factory LoginDataModel.fromJson(Map<String, dynamic> json) => LoginDataModel(
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
