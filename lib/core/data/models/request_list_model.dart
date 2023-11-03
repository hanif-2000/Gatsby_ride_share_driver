import 'package:equatable/equatable.dart';

class RequestListDataModel extends Equatable {
  final int success;
  final String message;
  final List<RequestListModel> data;

  const RequestListDataModel({
    required this.success,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [success, message, data];

  factory RequestListDataModel.fromMap(Map<String, dynamic> json) =>
      RequestListDataModel(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<RequestListModel>.from(
                json["data"].map((x) => RequestListModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

class RequestListModel extends Equatable {
  final int id;
  final int? driverId;
  final int customerId;
  final int vehicleCategoryId;
  final String startCoordinate;
  final String endCoordinate;
  final String startAddress;
  final String endAddress;
  final dynamic distance;
  final int oneWay;
  final dynamic orderTime;
  final int paymentMethod;
  final int status;
  final dynamic total;
  final dynamic pendingAmount;
  final dynamic newTotal;

  final DateTime createdAt;
  final DateTime updatedAt;
  final String? firstName;
  final String? lastName;
  final String? image;
  final dynamic rating;

  const RequestListModel({
    required this.id,
    this.driverId,
    required this.customerId,
    required this.vehicleCategoryId,
    required this.startCoordinate,
    required this.endCoordinate,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.oneWay,
    required this.orderTime,
    required this.paymentMethod,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
    this.firstName,
    this.lastName,
    this.image,
    this.pendingAmount,
    this.newTotal,
    this.rating,
  });

  @override
  List<Object?> get props => [
        id,
        driverId,
        customerId,
        vehicleCategoryId,
        startCoordinate,
        endCoordinate,
        startAddress,
        endAddress,
        distance,
        oneWay,
        orderTime,
        paymentMethod,
        status,
        total,
        createdAt,
        updatedAt,
        firstName,
        lastName,
        image,
        pendingAmount,
        newTotal,
        rating,
      ];

  factory RequestListModel.fromMap(Map<String, dynamic> json) =>
      RequestListModel(
        id: json["id"],
        driverId: json["driver_id"],
        customerId: json["customer_id"],
        vehicleCategoryId: json["vehicle_category_id"],
        startCoordinate: json["start_coordinate"],
        endCoordinate: json["end_coordinate"],
        startAddress: json["start_address"],
        endAddress: json["end_address"],
        distance: json["distance"],
        oneWay: json["one_way"],
        pendingAmount: json["pending_amount"],
        newTotal: json["new_total"],
        orderTime: DateTime.parse(json["order_time"]),
        paymentMethod: json["payment_method"],
        status: json["status"],
        total: json["total"],
        rating: json["rating"] != null
            ? int.tryParse(json['rating'].toString())
            : 0,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "driver_id": driverId,
        "customer_id": customerId,
        "vehicle_category_id": vehicleCategoryId,
        "start_coordinate": startCoordinate,
        "end_coordinate": endCoordinate,
        "start_address": startAddress,
        "end_address": endAddress,
        "distance": distance,
        "one_way": oneWay,
        "order_time": orderTime.toIso8601String(),
        "payment_method": paymentMethod,
        "status": status,
        "total": total,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "first_name": firstName,
        "last_name": lastName,
        "image": image,
        "rating": rating,
        "pendingAmount": pendingAmount,
        "newTotal": newTotal,
      };
}
