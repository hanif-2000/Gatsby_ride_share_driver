// To parse this JSON data, do
//
//     final acceptByOtherDriverModel = acceptByOtherDriverModelFromJson(jsonString);

import 'dart:convert';

AcceptByOtherDriverModel acceptByOtherDriverModelFromJson(String str) =>
    AcceptByOtherDriverModel.fromJson(json.decode(str));

String acceptByOtherDriverModelToJson(AcceptByOtherDriverModel data) =>
    json.encode(data.toJson());

class AcceptByOtherDriverModel {
  dynamic response;
  String message;
  String type;
  dynamic data;
  dynamic driverId;

  AcceptByOtherDriverModel({
    required this.response,
    required this.message,
    required this.type,
    required this.data,
    required this.driverId,
  });

  factory AcceptByOtherDriverModel.fromJson(Map<String, dynamic> json) =>
      AcceptByOtherDriverModel(
        response: json["Response"] ?? "",
        message: json["message"] ?? "",
        type: json["type"] ?? "",
        data: json["data"] ?? "",
        driverId: json["driverID"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "message": message,
        "type": type,
        "data": data,
        "driverID": driverId,
      };
}
