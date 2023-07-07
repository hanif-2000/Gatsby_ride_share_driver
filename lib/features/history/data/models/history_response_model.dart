// To parse this JSON data, do
//
//     final historyResponseModel = historyResponseModelFromJson(jsonString);

import 'dart:convert';

HistoryResponseModel historyResponseModelFromJson(String str) =>
    HistoryResponseModel.fromJson(json.decode(str));

String historyResponseModelToJson(HistoryResponseModel data) =>
    json.encode(data.toJson());

class HistoryResponseModel {
  HistoryResponseModel({
    required this.success,
    required this.historyOrder,
  });

  int success;
  List<HistoryOrder> historyOrder;

  factory HistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      HistoryResponseModel(
        success: json["success"],
        historyOrder: List<HistoryOrder>.from(
          json["history_order"].map(
            (x) => HistoryOrder.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "history_order": List<dynamic>.from(
          historyOrder.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class HistoryOrder {
  HistoryOrder({
    required this.id,
    required this.driverId,
    required this.startCoordinate,
    required this.endCoordinate,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.total,
    required this.orderTime,
    this.startTime,
    this.endTime,
    required this.status,
    required this.image,
    required this.userName,
    required this.userPhone,
    required this.rating,
    required this.driverName,
    required this.driverPhone,
    required this.email,
    required this.paymentMethod,
    required this.taxiType,
    required this.timestamp,
    required this.vehicleCategory,
    required this.ratingList,
    required this.customerId,
  });

  String id;
  String driverId;
  String startCoordinate;
  String endCoordinate;
  String startAddress;
  String endAddress;
  String distance;
  int total;
  DateTime orderTime;
  DateTime? startTime;
  DateTime? endTime;
  String status;
  String image;
  String userName;
  String userPhone;
  int rating;
  String driverName;
  String driverPhone;
  String email;
  int paymentMethod;
  int taxiType;
  String timestamp;
  VehicleCategory vehicleCategory;
  List<RatingList> ratingList;
  int customerId;

  factory HistoryOrder.fromJson(Map<String, dynamic> json) => HistoryOrder(
        id: json["id"],
        driverId: json["driver_id"],
        startCoordinate: json["start_coordinate"],
        endCoordinate: json["end_coordinate"],
        startAddress: json["start_address"],
        endAddress: json["end_address"],
        distance: json["distance"],
        total: json["total"],
        orderTime: DateTime.parse(json["order_time"]),
        startTime: json["start_time"] == null
            ? null
            : DateTime.parse(json["start_time"]),
        endTime:
            json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        status: json["status"],
        image: json["image"],
        userName: json["user_name"],
        userPhone: json["user_phone"],
        rating: json["rating"],
        driverName: json["driver_name"],
        driverPhone: json["driver_phone"],
        email: json["email"],
        paymentMethod: json["payment_method"],
        taxiType: json["taxi_type"],
        timestamp: json["timestamp"],
        customerId: int.parse(json["customer_id"].toString()) ?? 0,
        vehicleCategory: VehicleCategory.fromMap(json["vehicle_category"]),
        ratingList: List<RatingList>.from(
          json["rating_list"].map(
            (x) => RatingList.fromMap(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver_id": driverId,
        "start_coordinate": startCoordinate,
        "end_coordinate": endCoordinate,
        "start_address": startAddress,
        "end_address": endAddress,
        "distance": distance,
        "total": total,
        "order_time": orderTime.toIso8601String(),
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "status": status,
        "image": image,
        "user_name": userName,
        "user_phone": userPhone,
        "rating": rating,
        "driver_name": driverName,
        "driver_phone": driverPhone,
        "email": email,
        "payment_method": paymentMethod,
        "taxi_type": taxiType,
        "timestamp": timestamp,
        "customer_id": customerId,
        "vehicle_category": vehicleCategory.toMap(),
        "rating_list": List<dynamic>.from(ratingList.map((x) => x.toMap())),
      };
}

class RatingList {
  int id;
  int senderId;
  int receiverId;
  int orderId;
  String rating;
  String review;
  int type;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  RatingList({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.orderId,
    required this.rating,
    required this.review,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RatingList.fromMap(Map<String, dynamic> json) => RatingList(
        id: json["id"],
        senderId: json["sender_id"],
        receiverId: json["receiver_id"],
        orderId: json["order_id"],
        rating: json["rating"],
        review: json["review"],
        type: json["type"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sender_id": senderId,
        "receiver_id": receiverId,
        "order_id": orderId,
        "rating": rating,
        "review": review,
        "type": type,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class VehicleCategory {
  int id;
  String category;
  int priceKm;
  int distance;
  int minKm;
  int minPrice;
  int extraKm;
  int seat;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  VehicleCategory({
    required this.id,
    required this.category,
    required this.priceKm,
    required this.distance,
    required this.minKm,
    required this.minPrice,
    required this.extraKm,
    required this.seat,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory VehicleCategory.fromMap(Map<String, dynamic> json) => VehicleCategory(
        id: json["id"],
        category: json["category"],
        priceKm: json["price_km"],
        distance: json["distance"],
        minKm: json["min_km"],
        minPrice: json["min_price"],
        extraKm: json["extra_km"],
        seat: json["seat"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "category": category,
        "price_km": priceKm,
        "distance": distance,
        "min_km": minKm,
        "min_price": minPrice,
        "extra_km": extraKm,
        "seat": seat,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
