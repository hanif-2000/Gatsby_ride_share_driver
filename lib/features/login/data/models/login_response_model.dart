import 'package:equatable/equatable.dart';

class LoginResponseModel extends Equatable {
  final LoginDataModel? data;
  final num? success;
  final String? token;
  final String? message;

  const LoginResponseModel({
    this.data,
    this.success,
    this.token,
    this.message,
  });

  @override
  List<Object?> get props => [data, success, token];

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final dataObj = json['data'] as Map<String, dynamic>?;
    final userObj = dataObj?['user'] as Map<String, dynamic>?;
    return LoginResponseModel(
      data: userObj == null ? null : LoginDataModel.fromJson(userObj),
      token: dataObj?['token'] ?? '',
      success: (json['status'] == true) ? 1 : 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data == null ? '' : data!.toJson(),
        'token': token ?? '',
        'success': success ?? '',
        'message': message ?? '',
      };
}

class LoginDataModel extends Equatable {
  final num driverId;
  final String name;
  final String email;
  final String phoneNumber;
  final String fcmToken;
  final int status;
  final int verificationStatus;
  final String image;
  final dynamic categoryId;
  final String chatToken;

  const LoginDataModel(
      {required this.driverId,
      required this.name,
      required this.email,
      required this.phoneNumber,
      required this.fcmToken,
      required this.status,
      required this.verificationStatus,
      required this.categoryId,
      required this.chatToken,
      required this.image});

  @override
  List<Object?> get props =>
      [driverId, name, email, phoneNumber, fcmToken, status, verificationStatus, image, categoryId];

  factory LoginDataModel.fromJson(Map<String, dynamic> json) => LoginDataModel(
      driverId: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? '',
      fcmToken: json['fcm_token'] ?? '',
      image: json['image'] ?? '',
      chatToken:
          json['chat_token'] != null ? json['chat_token'].toString() : '',
      categoryId: json['vehicle_category_id'] ?? '',
      verificationStatus: json['verification_status'] ?? 0,
      status: json['status'] is bool ? (json['status'] == true ? 1 : 0) : json['status'] ?? 0);

  Map<String, dynamic> toJson() => {
        'id': driverId,
        'name': name,
        'email': email,
        'telp_driver': phoneNumber,
        'fcm_token': fcmToken,
        'vehicle_category_id': categoryId,
        'image': image,
        'chat_token': chatToken,
        'status': status,
        'verification_status': verificationStatus,
      };
}
