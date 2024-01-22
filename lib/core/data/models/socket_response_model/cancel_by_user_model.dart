// To parse this JSON data, do
//
//     final cancelByUserModel = cancelByUserModelFromJson(jsonString);

import 'dart:convert';

CancelByUserModel cancelByUserModelFromJson(String str) =>
    CancelByUserModel.fromJson(json.decode(str));

String cancelByUserModelToJson(CancelByUserModel data) =>
    json.encode(data.toJson());

class CancelByUserModel {
  dynamic response;
  String message;
  String type;
  dynamic orderId;
  dynamic data;

  CancelByUserModel({
    required this.response,
    required this.message,
    required this.type,
    required this.orderId,
    required this.data,
  });

  factory CancelByUserModel.fromJson(Map<String, dynamic> json) =>
      CancelByUserModel(
        response: json["Response"] ?? "",
        message: json["message"] ?? "",
        type: json["type"] ?? "",
        orderId: json["OrderID"] ?? "",
        data: json["data"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "message": message,
        "type": type,
        "OrderID": orderId,
        "data": data,
      };
}
