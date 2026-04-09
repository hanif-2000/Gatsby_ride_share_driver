// To parse this JSON data, do
//
//     final notificationRideModel = notificationRideModelFromJson(jsonString);

import 'dart:convert';

NotificationRideModel notificationRideModelFromJson(String str) =>
    NotificationRideModel.fromJson(json.decode(str));

String notificationRideModelToJson(NotificationRideModel data) =>
    json.encode(data.toJson());

class NotificationRideModel {
  dynamic notificationTypeId;
  RideData id;
  dynamic body;
  dynamic title;
  dynamic message;

  NotificationRideModel({
    required this.notificationTypeId,
    required this.id,
    required this.body,
    required this.title,
    required this.message,
  });

  factory NotificationRideModel.fromJson(Map<String, dynamic> json) =>
      NotificationRideModel(
        notificationTypeId: json["notificationTypeId"],
        id: json["id"] != null && json["id"] is Map ? RideData.fromJson(json["id"]) : RideData(),
        body: json["body"],
        title: json["title"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "notificationTypeId": notificationTypeId,
        "id": id.toJson(),
        "body": body,
        "title": title,
        "message": message,
      };
}

class RideData {
  String? image;
  String? distance;
  dynamic latitude;
  String? actualTime;
  dynamic longitude;
  String? pendingAmount;
  String? total;
  String? newTotal;
  int? customerRating;
  String? phone;
  String? endCoordinate;
  String? startAddress;
  String? startCoordinate;
  String? customerId;
  String? name;
  String? id;
  String? endAddress;
  String? paymentMethod;
  String? estimatedTime;

  RideData({
    this.image,
    this.distance,
    this.latitude,
    this.actualTime,
    this.longitude,
    this.pendingAmount,
    this.total,
    this.newTotal,
    this.customerRating,
    this.phone,
    this.endCoordinate,
    this.startAddress,
    this.startCoordinate,
    this.customerId,
    this.name,
    this.id,
    this.endAddress,
    this.paymentMethod,
    this.estimatedTime,
  });

  factory RideData.fromJson(Map<String, dynamic> json) => RideData(
        image: json["image"],
        distance: json["distance"],
        latitude: json["Latitude"],
        actualTime: json["actual_time"],
        longitude: json["Longitude"],
        pendingAmount: json["pending_amount"],
        total: json["total"],
        newTotal: json["new_total"],
        customerRating: json["CustomerRating"],
        phone: json["phone"],
        endCoordinate: json["end_coordinate"],
        startAddress: json["start_address"],
        startCoordinate: json["start_coordinate"],
        customerId: json["customerID"],
        name: json["name"],
        id: json["id"],
        endAddress: json["end_address"],
        paymentMethod: json["payment_method"],
        estimatedTime: json["estimated_time"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "distance": distance,
        "Latitude": latitude,
        "actual_time": actualTime,
        "Longitude": longitude,
        "pending_amount": pendingAmount,
        "total": total,
        "new_total": newTotal,
        "CustomerRating": customerRating,
        "phone": phone,
        "end_coordinate": endCoordinate,
        "start_address": startAddress,
        "start_coordinate": startCoordinate,
        "customerID": customerId,
        "name": name,
        "id": id,
        "end_address": endAddress,
        "payment_method": paymentMethod,
        "estimated_time": estimatedTime,
      };
}
