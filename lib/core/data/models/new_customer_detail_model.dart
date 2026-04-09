// To parse this JSON data, do
//
//     final newCustomerResponseDataModel = newCustomerResponseDataModelFromJson(jsonString);

import 'dart:convert';

NewCustomerResponseDataModel newCustomerResponseDataModelFromJson(String str) =>
    NewCustomerResponseDataModel.fromJson(json.decode(str));

String newCustomerResponseDataModelToJson(NewCustomerResponseDataModel data) =>
    json.encode(data.toJson());

class NewCustomerResponseDataModel {
  int success;
  Data data;

  NewCustomerResponseDataModel({
    required this.success,
    required this.data,
  });

  factory NewCustomerResponseDataModel.fromJson(Map<String, dynamic> json) =>
      NewCustomerResponseDataModel(
        success: json["success"] ?? 0,
        data: json["data"] != null ? Data.fromJson(json["data"]) : Data.empty(),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  String driverDetail;
  CustomerDetail customerDetail;

  Data({
    required this.driverDetail,
    required this.customerDetail,
  });

  factory Data.empty() => Data(
        driverDetail: '',
        customerDetail: CustomerDetail.empty(),
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        driverDetail: json["driver_detail"] ?? '',
        customerDetail: json["customer_detail"] != null
            ? CustomerDetail.fromJson(json["customer_detail"])
            : CustomerDetail.empty(),
      );

  Map<String, dynamic> toJson() => {
        "driver_detail": driverDetail,
        "customer_detail": customerDetail.toJson(),
      };
}

class CustomerDetail {
  int id;
  String name;
  String firstName;
  String lastName;
  String email;
  String phone;
  dynamic otp;
  String country;
  String loginType;
  dynamic socialId;
  dynamic firebaseUid;
  String fcmToken;
  String deviceType;
  String chatToken;
  int verificationStatus;
  int status;
  int firstOrder;
  String image;
  dynamic latitude;
  dynamic longitude;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  int pendingAmount;

  CustomerDetail({
    required this.id,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.otp,
    required this.country,
    required this.loginType,
    required this.socialId,
    required this.firebaseUid,
    required this.fcmToken,
    required this.deviceType,
    required this.chatToken,
    required this.verificationStatus,
    required this.status,
    required this.firstOrder,
    required this.image,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.pendingAmount,
  });

  factory CustomerDetail.empty() => CustomerDetail(
        id: 0, name: '', firstName: '', lastName: '', email: '', phone: '',
        otp: null, country: '', loginType: '', socialId: null, firebaseUid: null,
        fcmToken: '', deviceType: '', chatToken: '', verificationStatus: 0,
        status: 0, firstOrder: 0, image: '', latitude: null, longitude: null,
        createdAt: DateTime.now(), updatedAt: DateTime.now(), deletedAt: null, pendingAmount: 0,
      );

  factory CustomerDetail.fromJson(Map<String, dynamic> json) => CustomerDetail(
        id: json["id"] ?? 0,
        name: json["name"] ?? '',
        firstName: json["first_name"] ?? '',
        lastName: json["last_name"] ?? '',
        email: json["email"] ?? '',
        phone: json["phone"] ?? '',
        otp: json["otp"],
        country: json["country"] ?? '',
        loginType: json["login_type"] ?? '',
        socialId: json["social_id"],
        firebaseUid: json["firebase_uid"],
        fcmToken: json["fcm_token"] ?? '',
        deviceType: json["device_type"] ?? '',
        chatToken: json["chat_token"]?.toString() ?? '',
        verificationStatus: json["verification_status"] ?? 0,
        status: json["status"] is bool ? (json["status"] ? 1 : 0) : json["status"] ?? 0,
        firstOrder: json["first_order"] ?? 0,
        image: json["image"] ?? '',
        latitude: json["Latitude"],
        longitude: json["Longitude"],
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
        deletedAt: json["deleted_at"],
        pendingAmount: json["pending_amount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone": phone,
        "otp": otp,
        "country": country,
        "login_type": loginType,
        "social_id": socialId,
        "firebase_uid": firebaseUid,
        "fcm_token": fcmToken,
        "device_type": deviceType,
        "chat_token": chatToken,
        "verification_status": verificationStatus,
        "status": status,
        "first_order": firstOrder,
        "image": image,
        "Latitude": latitude,
        "Longitude": longitude,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "pending_amount": pendingAmount,
      };
}
