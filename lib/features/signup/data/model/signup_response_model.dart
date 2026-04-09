import 'package:equatable/equatable.dart';

class SignupResponseModel extends Equatable {
  final SignupDataModel? data;
  final num? success;
  final String? token;
  final String? message;

  const SignupResponseModel(
      {this.data, this.success, this.token, this.message});

  @override
  List<Object?> get props => [data, success, token];

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    final dataObj = json['data'] as Map<String, dynamic>?;
    final userObj = dataObj?['data'] as Map<String, dynamic>?;
    return SignupResponseModel(
      data: userObj == null ? null : SignupDataModel.fromJson(userObj),
      token: dataObj?['token'] ?? '',
      success: (json['status'] == true) ? 1 : 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data == null ? '' : data!.toJson(),
        'token': token ?? '',
        'success': success ?? '',
        'message': message ?? ''
      };
}

class SignupDataModel extends Equatable {
  final num driverId;

  // final String name;
  final String email;

  // final String phoneNumber;
  // final String fcmToken;
  // final int status;
  // final String image;
  // final String categoryId;

  const SignupDataModel({
    required this.driverId,
    // required this.name,
    required this.email,
    // required this.phoneNumber,
    // required this.fcmToken,
    // required this.status,
    // required this.categoryId,
    // required this.image,
  });

  @override
  List<Object?> get props => [
        driverId,
        email, /*name,  phoneNumber, fcmToken, status, image, categoryId*/
      ];

  factory SignupDataModel.fromJson(Map<String, dynamic> json) =>
      SignupDataModel(
        driverId: json['id'],
        email: json['email'],
        // name: json['name'],
        // phoneNumber: json['phone'],
        // fcmToken: json['fcm_token'] ?? '',
        // image: json['image'] ?? '',
        // categoryId: json['vehicle_category_id'] ?? '',
        // status: json['status'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': driverId,
        'email': email,
        // 'name': name,
        // 'telp_driver': phoneNumber,
        // 'fcm_token': fcmToken,
        // 'vehicle_category_id': categoryId,
        // 'image': image,
        // 'status': status,
      };
}
