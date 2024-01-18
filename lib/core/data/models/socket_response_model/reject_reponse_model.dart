// To parse this JSON data, do
//
//     final rejectResponseModel = rejectResponseModelFromJson(jsonString);

import 'dart:convert';

RejectResponseModel rejectResponseModelFromJson(String str) =>
    RejectResponseModel.fromJson(json.decode(str));

String rejectResponseModelToJson(RejectResponseModel data) =>
    json.encode(data.toJson());

class RejectResponseModel {
  bool response;
  String message;
  String type;
  int data;

  RejectResponseModel({
    required this.response,
    required this.message,
    required this.type,
    required this.data,
  });

  factory RejectResponseModel.fromJson(Map<String, dynamic> json) =>
      RejectResponseModel(
        response: json["Response"],
        message: json["message"],
        type: json["type"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "message": message,
        "type": type,
        "data": data,
      };
}
