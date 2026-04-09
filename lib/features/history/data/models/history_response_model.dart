// To parse this JSON data, do
//
//     final historyResponseModel = historyResponseModelFromJson(jsonString);

import 'dart:convert';

HistoryResponseModel historyResponseModelFromJson(String str) =>
    HistoryResponseModel.fromJson(json.decode(str));

String historyResponseModelToJson(HistoryResponseModel data) =>
    json.encode(data.toJson());

class HistoryResponseModel {
  int success;
  List<HistoryOrder> historyOrder;

  HistoryResponseModel({
    required this.success,
    required this.historyOrder,
  });

  factory HistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      HistoryResponseModel(
        success: (json["status"] == true || json["success"] == 1) ? 1 : 0,
        historyOrder: (json["data"] ?? json["history_order"]) != null
            ? List<HistoryOrder>.from(
                (json["data"] ?? json["history_order"]).map((x) => HistoryOrder.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "history_order":
            List<dynamic>.from(historyOrder.map((x) => x.toJson())),
      };
}

class HistoryOrder {
  String? id;
  String? driverId;
  String? customerId;
  String? startCoordinate;
  String? endCoordinate;
  String? startAddress;
  String? endAddress;
  String? actual_time;
  String? actualTime;
  dynamic distance;
  dynamic total;
  dynamic grandTotal;
  dynamic pendingAmount;
  dynamic newTotal;
  dynamic extraTimeTaken;
  dynamic extraTimePrice;
  dynamic extraDistance;
  dynamic extraDistancePrice;
  dynamic tip;
  dynamic orderTime;
  dynamic startTime;
  dynamic endTime;
  dynamic status;
  String image;
  String userName;
  String userPhone;
  dynamic rating;
  String driverName;
  String driverPhone;
  String email;
  dynamic paymentStatus;
  int paymentMethod;
  int taxiType;
  dynamic price_km;
  dynamic price_min;
  dynamic tech_fee;
  dynamic base_fare;
  dynamic minimum_fare;
  dynamic price_per_min;
  String timestamp;
  VehicleCategory vehicleCategory;
  List<RatingList> ratingList;

  HistoryOrder({
    required this.id,
    required this.driverId,
    required this.customerId,
    required this.startCoordinate,
    required this.endCoordinate,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.total,
    required this.grandTotal,
    required this.pendingAmount,
    required this.newTotal,
    required this.tip,
    required this.orderTime,
    required this.startTime,
    required this.endTime,
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
    required this.extraDistance,
    required this.extraDistancePrice,
    required this.extraTimeTaken,
    required this.extraTimePrice,
    required this.paymentStatus,
     this.price_km,
     this.tech_fee,
     this.base_fare,
     this.minimum_fare,
     this.actual_time,
     this.price_min,
     this.price_per_min,
    this.actualTime
  });

  factory HistoryOrder.fromJson(Map<String, dynamic> json) => HistoryOrder(
        id: json["id"],
        driverId: json["driver_id"],
        minimum_fare: json["minimum_fare"],
        base_fare: json["base_fare"],
         tech_fee: json["tech_fee"],
         price_km: json["price_km"],
         actual_time: json["actual_time"]??"0.0",
         actualTime: json["actualTime"]??"0.0",
        customerId: json["customer_id"],
        startCoordinate: json["start_coordinate"],
        endCoordinate: json["end_coordinate"],
        startAddress: json["start_address"],
        endAddress: json["end_address"],
      price_per_min: json["price_per_min"],
    price_min: json["price_min"],
        distance:
            json["distance"] != null ? json["distance"].toString() : "0.0",
        total: json["total"] != null ? json["total"].toDouble() : 0.0,
        grandTotal: json["grand_total"] ?? '',
        pendingAmount: json["pending_amount"] ?? 0.0,
        newTotal: json["new_total"] ?? 0.0,
        tip: json["tip"] ?? '0',
        orderTime: json["order_time"] != null &&
                json["order_time"].toString().isNotEmpty
            ? DateTime.parse(json["order_time"])
            : DateTime.now(),
        startTime: json["start_time"] != null &&
                json["start_time"].toString().isNotEmpty
            ? DateTime.parse(json["start_time"])
            : DateTime.now(),
        endTime:
            json["end_time"] != null && json["end_time"].toString().isNotEmpty
                ? DateTime.parse(json["end_time"])
                : DateTime.now(),
        status: json["status"],
        extraDistance:
            ((json["extra_distance"] == null) || (json["extra_distance"] == ''))
                ? '0'
                : json["extra_distance"],
        extraDistancePrice: ((json["extra_distance_price"] == null) ||
                (json["extra_distance_price"] == ''))
            ? '0'
            : json["extra_distance_price"],
        extraTimeTaken:
            ((json["extra_time"] == null) || (json["extra_time"] == ''))
                ? '0'
                : json["extra_time"],
        extraTimePrice: ((json["extra_time_price"] == null) ||
                (json["extra_time_price"] == ''))
            ? '0'
            : json["extra_time_price"],
        // extraDistancePrice: json["extra_distance_price"] ?? '0',
        // extraTimeTaken: json["extra_time"] ?? "0",
        // extraTimePrice: json["extra_time_price"] ?? '0',
        image: json["image"],
        userName: json["user_name"],
        userPhone: json["user_phone"],
        rating: json["rating"] ?? 0,
        driverName: json["driver_name"],
        driverPhone: json["driver_phone"],
        email: json["email"],
        paymentMethod: json["payment_method"],
        taxiType: json["taxi_type"],
        paymentStatus: json["payment_status"],
        timestamp: json["timestamp"],
        vehicleCategory: json["vehicle_category"] != null && json["vehicle_category"] is Map
            ? VehicleCategory.fromJson(json["vehicle_category"])
            : VehicleCategory.empty(),
        ratingList: json["rating_list"] != null
            ? List<RatingList>.from(json["rating_list"].map((x) => RatingList.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver_id": driverId,
        "customer_id": customerId,
        "actualTime": actualTime,
        "start_coordinate": startCoordinate,
        "end_coordinate": endCoordinate,
        "start_address": startAddress,
        "end_address": endAddress,
        "distance": distance,
        "total": total,
        "grand_total": grandTotal,
        "price_per_min": price_per_min,
        "tip": tip,
        "order_time": orderTime!.toIso8601String(),
        "start_time": startTime!.toIso8601String(),
        "end_time": endTime!.toIso8601String(),
        "status": status,
        "image": image,
        "price_min": price_min,
        "user_name": userName,
        "user_phone": userPhone,
        "rating": rating,
        "driver_name": driverName,
        "driver_phone": driverPhone,
        "email": email,
        "pending_amount": pendingAmount,
        "new_total": newTotal,
        "payment_method": paymentMethod,
        "taxi_type": taxiType,
        "extra_distance": extraDistance,
        "extra_distance_price": extraDistancePrice,
        "extra_time": extraTimeTaken,
        "extra_time_price": extraTimePrice,
        "timestamp": timestamp,
        "vehicle_category": vehicleCategory.toJson(),
        "paymentStatus": paymentStatus,
        "rating_list": List<dynamic>.from(ratingList.map((x) => x.toJson())),
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

  factory RatingList.fromJson(Map<String, dynamic> json) => RatingList(
        // id: json["id"],
        // senderId: json["sender_id"],
        // receiverId: json["receiver_id"],
        // orderId: json["order_id"],
        // rating: json["rating"],
        // review: json["review"],
        // type: json["type"],
        // status: json["status"],
        // createdAt: DateTime.parse(json["created_at"]),
        // updatedAt: DateTime.parse(json["updated_at"]),

        id: json["id"] ?? 0,
        senderId: json["sender_id"] ?? 0,
        receiverId: json["receiver_id"] ?? 0,
        orderId: json["order_id"] ?? 0,
        rating: json["rating"] ?? "0.0",
        review: json["review"] ?? '',
        type: json["type"] ?? 1,
        status: json["status"] ?? 1,
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
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
  double priceKm;
  double priceMin;
  int techFee;
  double baseFare;
  int distance;
  double minKm;
  int minPrice;
  int extraKm;
  String seat;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  VehicleCategory({
    required this.id,
    required this.category,
    required this.priceKm,
    required this.priceMin,
    required this.techFee,
    required this.baseFare,
    required this.distance,
    required this.minKm,
    required this.minPrice,
    required this.extraKm,
    required this.seat,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory VehicleCategory.empty() => VehicleCategory(
        id: 0, category: '', priceKm: 0, priceMin: 0, techFee: 0,
        baseFare: 0, distance: 0, minKm: 0, minPrice: 0, extraKm: 0,
        seat: '', createdAt: DateTime.now(), updatedAt: DateTime.now(), deletedAt: null,
      );

  factory VehicleCategory.fromJson(Map<String, dynamic> json) =>
      VehicleCategory(
        id: json["id"] ?? 0,
        category: json["category"] ?? '',
        priceKm: (json["price_km"] ?? 0).toDouble(),
        priceMin: (json["price_min"] ?? 0).toDouble(),
        techFee: json["tech_fee"] ?? 0,
        baseFare: (json["base_fare"] ?? 0).toDouble(),
        distance: json["distance"] ?? 0,
        minKm: (json["min_km"] ?? 0).toDouble(),
        minPrice: json["min_price"] ?? 0,
        extraKm: json["extra_km"] ?? 0,
        seat: json["seat"] ?? '',
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "price_km": priceKm,
        "price_min": priceMin,
        "tech_fee": techFee,
        "base_fare": baseFare,
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











































// // To parse this JSON data, do
// //
// //     final historyResponseModel = historyResponseModelFromJson(jsonString);

// import 'dart:convert';

// HistoryResponseModel historyResponseModelFromJson(String str) =>
//     HistoryResponseModel.fromJson(json.decode(str));

// String historyResponseModelToJson(HistoryResponseModel data) =>
//     json.encode(data.toJson());

// class HistoryResponseModel {
//   int success;
//   List<HistoryOrder>? historyOrder;

//   HistoryResponseModel({
//     required this.success,
//     required this.historyOrder,
//   });

//   factory HistoryResponseModel.fromJson(Map<String, dynamic> json) =>
//       HistoryResponseModel(
//         success: json["success"],
//         historyOrder: json["history_order"] != null
//             ? List<HistoryOrder>.from(
//                 json["history_order"].map((x) => HistoryOrder.fromJson(x)))
//             : [],
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "history_order":
//             List<dynamic>.from(historyOrder!.map((x) => x.toJson())),
//       };
// }

// class HistoryOrder {
//   String? id;
//   String? driverId;
//   String? customerId;
//   String? startCoordinate;
//   String? endCoordinate;
//   String? startAddress;
//   String? endAddress;
//   String? distance;
//   double? total;
//   String grandTotal;
//   dynamic tip;
//   DateTime? orderTime;
//   DateTime? startTime;
//   DateTime? endTime;
//   String? status;
//   String? image;
//   String? userName;
//   String? userPhone;
//   int? rating;
//   String? driverName;
//   String? driverPhone;
//   String? email;
//   int paymentMethod;
//   int taxiType;
//   String timestamp;
//   VehicleCategory vehicleCategory;
//   List<RatingList> ratingList;

//   HistoryOrder({
//     required this.id,
//     required this.driverId,
//     required this.customerId,
//     required this.startCoordinate,
//     required this.endCoordinate,
//     required this.startAddress,
//     required this.endAddress,
//     required this.distance,
//     required this.total,
//     required this.grandTotal,
//     required this.orderTime,
//     required this.startTime,
//     required this.endTime,
//     required this.status,
//     required this.image,
//     required this.userName,
//     required this.userPhone,
//     required this.rating,
//     required this.driverName,
//     required this.driverPhone,
//     required this.email,
//     required this.paymentMethod,
//     required this.taxiType,
//     required this.timestamp,
//     required this.tip,
//     required this.vehicleCategory,
//     required this.ratingList,
//   });

//   factory HistoryOrder.fromJson(Map<String, dynamic> json) => HistoryOrder(
//         id: json["id"],
//         driverId: json["driver_id"],
//         customerId: json["customer_id"],
//         startCoordinate: json["start_coordinate"],
//         endCoordinate: json["end_coordinate"],
//         startAddress: json["start_address"],
//         endAddress: json["end_address"],
//         distance: json["distance"],
//         tip: json["tip"],
//         total: json["total"] != null ? json["total"]?.toDouble() : 0.0,
//         grandTotal: json["grand_total"],
//         orderTime: json["order_time"] != null
//             ? DateTime.parse(json["order_time"])
//             : DateTime.now(),
//         startTime: json["start_time"] != null
//             ? DateTime.parse(json["start_time"])
//             : DateTime.now(),
//         endTime: json["end_time"] != null
//             ? DateTime.parse(json["end_time"])
//             : DateTime.now(),
//         status: json["status"],
//         image: json["image"],
//         userName: json["user_name"],
//         userPhone: json["user_phone"],
//         rating: json["rating"],
//         driverName: json["driver_name"],
//         driverPhone: json["driver_phone"],
//         email: json["email"],
//         paymentMethod: json["payment_method"],
//         taxiType: json["taxi_type"],
//         timestamp: json["timestamp"],
//         vehicleCategory: VehicleCategory.fromJson(json["vehicle_category"]),
//         ratingList: List<RatingList>.from(
//             json["rating_list"].map((x) => RatingList.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "driver_id": driverId ?? '',
//         "customer_id": customerId ?? '',
//         "start_coordinate": startCoordinate,
//         "end_coordinate": endCoordinate ?? '',
//         "start_address": startAddress ?? '',
//         "end_address": endAddress ?? '',
//         "distance": distance ?? '',
//         "total": total ?? 0.0,
//         "grand_total": grandTotal,
//         "order_time": orderTime == null
//             ? DateTime.now().toIso8601String()
//             : orderTime!.toIso8601String(),
//         "start_time": startTime == null
//             ? DateTime.now().toIso8601String()
//             : startTime!.toIso8601String(),
//         "end_time": endTime == null
//             ? DateTime.now().toIso8601String()
//             : endTime!.toIso8601String(),
//         "status": status ?? '',
//         "image": image,
//         "tip": tip,
//         "user_name": userName ?? '',
//         "user_phone": userPhone ?? '',
//         "rating": rating ?? 0,
//         "driver_name": driverName ?? '',
//         "driver_phone": driverPhone ?? "",
//         "email": email ?? '',
//         "payment_method": paymentMethod,
//         "taxi_type": taxiType,
//         "timestamp": timestamp,
//         "vehicle_category": vehicleCategory.toJson(),
//         "rating_list": List<dynamic>.from(ratingList.map((x) => x.toJson())),
//       };
// }

// class RatingList {
//   int id;
//   int senderId;
//   int receiverId;
//   int orderId;
//   String rating;
//   String review;
//   int type;
//   int status;
//   DateTime createdAt;
//   DateTime updatedAt;

//   RatingList({
//     required this.id,
//     required this.senderId,
//     required this.receiverId,
//     required this.orderId,
//     required this.rating,
//     required this.review,
//     required this.type,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory RatingList.fromJson(Map<String, dynamic> json) => RatingList(
//         id: json["id"],
//         senderId: json["sender_id"],
//         receiverId: json["receiver_id"],
//         orderId: json["order_id"],
//         rating: json["rating"],
//         review: json["review"] ?? '',
//         type: json["type"],
//         status: json["status"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "sender_id": senderId,
//         "receiver_id": receiverId,
//         "order_id": orderId,
//         "rating": rating,
//         "review": review,
//         "type": type,
//         "status": status,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//       };
// }

// class VehicleCategory {
//   int id;
//   String category;
//   double priceKm;
//   int techFee;
//   double baseFare;
//   int distance;
//   double minKm;
//   int minPrice;
//   int extraKm;
//   String seat;
//   DateTime createdAt;
//   DateTime updatedAt;
//   // dynamic deletedAt;

//   VehicleCategory({
//     required this.id,
//     required this.category,
//     required this.priceKm,
//     required this.techFee,
//     required this.baseFare,
//     required this.distance,
//     required this.minKm,
//     required this.minPrice,
//     required this.extraKm,
//     required this.seat,
//     required this.createdAt,
//     required this.updatedAt,
//     // required this.deletedAt,
//   });

//   factory VehicleCategory.fromJson(Map<String, dynamic> json) =>
//       VehicleCategory(
//         id: json["id"],
//         category: json["category"],
//         priceKm: json["price_km"]?.toDouble(),
//         techFee: json["tech_fee"],
//         baseFare: json["base_fare"]?.toDouble(),
//         distance: json["distance"],
//         minKm: json["min_km"]?.toDouble(),
//         minPrice: json["min_price"],
//         extraKm: json["extra_km"],
//         seat: json["seat"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         // deletedAt: json["deleted_at"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "category": category,
//         "price_km": priceKm,
//         "tech_fee": techFee,
//         "base_fare": baseFare,
//         "distance": distance,
//         "min_km": minKm,
//         "min_price": minPrice,
//         "extra_km": extraKm,
//         "seat": seat,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         // "deleted_at": deletedAt,
//       };
// }
