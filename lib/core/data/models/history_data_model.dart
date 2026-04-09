// To parse this JSON data, do
//
//     final historyDataModel = historyDataModelFromJson(jsondynamic);

import 'dart:convert';

HistoryDataModel historyDataModelFromJson(dynamic str) =>
    HistoryDataModel.fromJson(json.decode(str));

dynamic historyDataModelToJson(HistoryDataModel data) =>
    json.encode(data.toJson());

class HistoryDataModel {
  int success;
  List<HistoryOrder> historyOrder;

  HistoryDataModel({
    required this.success,
    required this.historyOrder,
  });

  factory HistoryDataModel.fromJson(Map<dynamic, dynamic> json) =>
      HistoryDataModel(
        success: json["success"] ?? 0,
        historyOrder: json["history_order"] != null
            ? List<HistoryOrder>.from(json["history_order"].map((x) => HistoryOrder.fromJson(x)))
            : [],
      );

  Map<dynamic, dynamic> toJson() => {
        "success": success,
        "history_order":
            List<dynamic>.from(historyOrder.map((x) => x.toJson())),
      };
}

class HistoryOrder {
  dynamic id;
  dynamic driverId;
  dynamic customerId;
  dynamic startCoordinate;
  dynamic endCoordinate;
  dynamic startAddress;
  dynamic endAddress;
  dynamic distance;
  double total;
  dynamic grandTotal;
  dynamic tip;
  dynamic extraDistance;
  dynamic extraDistancePrice;
  dynamic extraTime;
  dynamic extraTimePrice;
  DateTime orderTime;
  dynamic startTime;
  dynamic endTime;
  dynamic status;
  dynamic image;
  dynamic userName;
  dynamic userPhone;
  int rating;
  DriverName driverName;
  dynamic driverPhone;
  Email email;
  int paymentMethod;
  int taxiType;
  dynamic timestamp;
  VehicleCategory vehicleCategory;
  List<RatingList> ratingList;
  dynamic pendingAmount;
  dynamic newTotal;
  PaymentStatus paymentStatus;

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
    required this.tip,
    required this.extraDistance,
    required this.extraDistancePrice,
    required this.extraTime,
    required this.extraTimePrice,
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
    required this.pendingAmount,
    required this.newTotal,
    required this.paymentStatus,
  });

  factory HistoryOrder.fromJson(Map<dynamic, dynamic> json) => HistoryOrder(
        id: json["id"],
        driverId: json["driver_id"],
        customerId: json["customer_id"],
        startCoordinate: json["start_coordinate"],
        endCoordinate: json["end_coordinate"],
        startAddress: json["start_address"],
        endAddress: json["end_address"],
        distance: json["distance"],
        total: json["total"]?.toDouble(),
        grandTotal: json["grand_total"],
        tip: json["tip"],
        extraDistance: json["extra_distance"],
        extraDistancePrice: json["extra_distance_price"],
        extraTime: json["extra_time"],
        extraTimePrice: json["extra_time_price"],
        orderTime: json["order_time"] != null && json["order_time"].toString().isNotEmpty
            ? DateTime.parse(json["order_time"])
            : DateTime.now(),
        startTime: json["start_time"],
        endTime: json["end_time"],
        status: json["status"],
        image: json["image"],
        userName: json["user_name"] ?? '',
        userPhone: json["user_phone"],
        rating: json["rating"],
        driverName: driverNameValues.map[json["driver_name"]] ?? DriverName.XYFU_YXYDCU,
        driverPhone: json["driver_phone"],
        email: emailValues.map[json["email"]] ?? Email.TESTDEV_GMAIL_COM,
        paymentMethod: json["payment_method"],
        taxiType: json["taxi_type"],
        timestamp: json["timestamp"],
        vehicleCategory: json["vehicle_category"] != null && json["vehicle_category"] is Map
            ? VehicleCategory.fromJson(json["vehicle_category"])
            : VehicleCategory.empty(),
        ratingList: json["rating_list"] != null
            ? List<RatingList>.from(json["rating_list"].map((x) => RatingList.fromJson(x)))
            : [],
        pendingAmount: json["pending_amount"],
        newTotal: json["new_total"],
        paymentStatus: paymentStatusValues.map[json["payment_status"]] ?? PaymentStatus.NO,
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "driver_id": driverId,
        "customer_id": customerId,
        "start_coordinate": startCoordinate,
        "end_coordinate": endCoordinate,
        "start_address": startAddress,
        "end_address": endAddress,
        "distance": distance,
        "total": total,
        "grand_total": grandTotal,
        "tip": tip,
        "extra_distance": extraDistance,
        "extra_distance_price": extraDistancePrice,
        "extra_time": extraTime,
        "extra_time_price": extraTimePrice,
        "order_time": orderTime.toIso8601String(),
        "start_time": startTime,
        "end_time": endTime,
        "status": status,
        "image": image,
        "user_name": userName,
        "user_phone": userPhone,
        "rating": rating,
        "driver_name": driverNameValues.reverse[driverName],
        "driver_phone": driverPhone,
        "email": emailValues.reverse[email],
        "payment_method": paymentMethod,
        "taxi_type": taxiType,
        "timestamp": timestamp,
        "vehicle_category": vehicleCategory.toJson(),
        "rating_list": List<dynamic>.from(ratingList.map((x) => x.toJson())),
        "pending_amount": pendingAmount,
        "new_total": newTotal,
        "payment_status": paymentStatusValues.reverse[paymentStatus],
      };
}

enum DriverName { XYFU_YXYDCU }

final driverNameValues = EnumValues({"xyfu yxydcu": DriverName.XYFU_YXYDCU});

enum Email { CUSTOMER01_YOPMAIL_COM, TESTDEV1_GMAIL_COM, TESTDEV_GMAIL_COM }

final emailValues = EnumValues({
  "customer01@yopmail.com": Email.CUSTOMER01_YOPMAIL_COM,
  "testdev1@gmail.com": Email.TESTDEV1_GMAIL_COM,
  "testdev@gmail.com": Email.TESTDEV_GMAIL_COM
});

enum PaymentStatus { NO, YES }

final paymentStatusValues =
    EnumValues({"no": PaymentStatus.NO, "yes": PaymentStatus.YES});

class RatingList {
  int id;
  int senderId;
  int receiverId;
  int orderId;
  dynamic rating;
  dynamic? review;
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

  factory RatingList.fromJson(Map<dynamic, dynamic> json) => RatingList(
        id: json["id"] ?? 0,
        senderId: json["sender_id"] ?? 0,
        receiverId: json["receiver_id"] ?? 0,
        orderId: json["order_id"] ?? 0,
        rating: json["rating"],
        review: json["review"],
        type: json["type"] ?? 1,
        status: json["status"] ?? 1,
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
      );

  Map<dynamic, dynamic> toJson() => {
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

// enum UserName { ANKIT_BISHT, CUSTOMER_ONE, HHGG_UFFU }

// final userNameValues = EnumValues({
//   "Ankit bisht": UserName.ANKIT_BISHT,
//   "Customer One": UserName.CUSTOMER_ONE,
//   "hhgg uffu": UserName.HHGG_UFFU
// });

class VehicleCategory {
  int id;
  Category category;
  double priceKm;
  double priceMin;
  int techFee;
  double baseFare;
  int distance;
  double minKm;
  int minPrice;
  int extraKm;
  dynamic seat;
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
        id: 0, category: Category.ECONOMY, priceKm: 0, priceMin: 0,
        techFee: 0, baseFare: 0, distance: 0, minKm: 0, minPrice: 0,
        extraKm: 0, seat: '', createdAt: DateTime.now(), updatedAt: DateTime.now(), deletedAt: null,
      );

  factory VehicleCategory.fromJson(Map<dynamic, dynamic> json) =>
      VehicleCategory(
        id: json["id"] ?? 0,
        category: categoryValues.map[json["category"]] ?? Category.ECONOMY,
        priceKm: (json["price_km"] ?? 0).toDouble(),
        priceMin: (json["price_min"] ?? 0).toDouble(),
        techFee: json["tech_fee"] ?? 0,
        baseFare: (json["base_fare"] ?? 0).toDouble(),
        distance: json["distance"] ?? 0,
        minKm: (json["min_km"] ?? 0).toDouble(),
        minPrice: json["min_price"] ?? 0,
        extraKm: json["extra_km"] ?? 0,
        seat: json["seat"],
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : DateTime.now(),
        updatedAt: json["updated_at"] != null ? DateTime.parse(json["updated_at"]) : DateTime.now(),
        deletedAt: json["deleted_at"],
      );

  Map<dynamic, dynamic> toJson() => {
        "id": id,
        "category": categoryValues.reverse[category],
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

enum Category { ECONOMY }

final categoryValues = EnumValues({"Economy": Category.ECONOMY});

class EnumValues<T> {
  Map<dynamic, T> map;
  late Map<T, dynamic> reverseMap;

  EnumValues(this.map);

  Map<T, dynamic> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
























// import 'dart:convert';

// HistoryDataModel historyDataModelFromJson(dynamic str) =>
//     HistoryDataModel.fromJson(json.decode(str));

// dynamic historyDataModelToJson(HistoryDataModel data) =>
//     json.encode(data.toJson());

// class HistoryDataModel {
//   int success;
//   List<HistoryOrder> historyOrder;

//   HistoryDataModel({
//     required this.success,
//     required this.historyOrder,
//   });

//   factory HistoryDataModel.fromJson(Map<dynamic, dynamic> json) =>
//       HistoryDataModel(
//         success: json["success"],
//         historyOrder: List<HistoryOrder>.from(
//             json["history_order"].map((x) => HistoryOrder.fromJson(x))),
//       );

//   Map<dynamic, dynamic> toJson() => {
//         "success": success,
//         "history_order":
//             List<dynamic>.from(historyOrder.map((x) => x.toJson())),
//       };
// }

// class HistoryOrder {
//   dynamic id;
//   dynamic driverId;
//   dynamic driverName;
//   dynamic image;
//   dynamic plateNumber;
//   dynamic rating;
//   dynamic startCoordinate;
//   dynamic endCoordinate;
//   dynamic startAddress;
//   dynamic endAddress;
//   dynamic distance;
//   dynamic total;
//   DateTime orderTime;
//   dynamic tip;
//   dynamic extraTime;
//   dynamic extraTimePrice;
//   dynamic extraDistance;
//   dynamic extraDistancePrice;

//   int? status;
//   dynamic timeSchool;
//   dynamic timeAfterSchool;
//   dynamic paymentMethod;
//   dynamic taxiType;
//   dynamic timestamp;
//   CategoryClass category;
//   List<RatingList>? ratingList;

//   HistoryOrder({
//     required this.id,
//     required this.driverId,
//     required this.driverName,
//     required this.image,
//     required this.plateNumber,
//     required this.rating,
//     required this.startCoordinate,
//     required this.endCoordinate,
//     required this.startAddress,
//     required this.endAddress,
//     required this.distance,
//     required this.total,
//     required this.orderTime,
//     required this.tip,
//     required this.status,
//     required this.timeSchool,
//     required this.timeAfterSchool,
//     required this.paymentMethod,
//     required this.taxiType,
//     required this.timestamp,
//     required this.category,
//     required this.ratingList,
//     required this.extraTime,
//     required this.extraTimePrice,
//     required this.extraDistance,
//     required this.extraDistancePrice,
//   });

//   factory HistoryOrder.fromJson(Map<dynamic, dynamic> json) => HistoryOrder(
//         id: json["id"] ?? '',
//         driverId: json["driver_id"] ?? "",
//         driverName: json["driver_name"] ?? "",
//         image: json["image"] ?? '',
//         plateNumber: json["plate_number"] ?? '',
//         rating: json["rating"] ?? 0,
//         tip: json["tip"] ?? 0,
//         extraTime: json["extra_time"] ?? "0",
//         extraTimePrice: json["extra_time_price"] ?? "0",
//         extraDistance: json["extra_distance"] ?? "0",
//         extraDistancePrice: json["extra_distance_price"] ?? "0",
//         startCoordinate: json["start_coordinate"] ?? '',
//         endCoordinate: json["end_coordinate"] ?? "",
//         startAddress: json["start_address"] ?? "",
//         endAddress: json["end_address"] ?? "",
//         distance: json["distance"] ?? '',
//         total: json["total"] ?? "",
//         orderTime: DateTime.parse(json["order_time"]),
//         status: json["status"] ?? 0,
//         timeSchool: json["time_school"] ?? '6',
//         timeAfterSchool: json["time_after_school"] ?? '',
//         paymentMethod: json["payment_method"],
//         taxiType: json["taxi_type"] ?? '1',
//         timestamp: json["timestamp"] ?? '',
//         category: CategoryClass.fromJson(json["category"]),
//         ratingList: json["rating_list"] != null
//             ? List<RatingList>.from(
//                 json["rating_list"].map((x) => RatingList.fromJson(x)))
//             : [],
//       );

//   Map<dynamic, dynamic> toJson() => {
//         "id": id,
//         "driver_id": driverId,
//         "driver_name": driverName,
//         "image": image,
//         "plate_number": plateNumber,
//         "rating": rating,
//         "start_coordinate": startCoordinate,
//         "end_coordinate": endCoordinate,
//         "start_address": startAddress,
//         "end_address": endAddress,
//         "distance": distance,
//         "total": total,
//         "tip": tip,
//         "order_time": orderTime.toIso8601dynamic(),
//         "status": status,
//         "time_school": timeSchool,
//         "time_after_school": timeAfterSchool,
//         "payment_method": paymentMethod,
//         "extraTime": extraTime,
//         "extraTimePrice": extraTimePrice,
//         "extraDistance": extraDistance,
//         "extraDistancePrice": extraDistancePrice,
//         "taxi_type": taxiType,
//         "timestamp": timestamp,
//         "category": category.toJson(),
//         "rating_list": List<dynamic>.from(ratingList!.map((x) => x.toJson())),
//       };
// }

// class CategoryClass {
//   int id;
//   dynamic? category;
//   double? priceKm;
//   int? techFee;
//   double? baseFare;
//   int? distance;
//   double? minKm;
//   int? minPrice;
//   int? extraKm;
//   dynamic? seat;
//   DateTime createdAt;
//   DateTime updatedAt;
//   dynamic deletedAt;

//   CategoryClass({
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
//     required this.deletedAt,
//   });

//   factory CategoryClass.fromJson(Map<dynamic, dynamic> json) => CategoryClass(
//         id: json["id"] ?? 0,
//         category: json["category"] ?? '',
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
//         deletedAt: json["deleted_at"],
//       );

//   Map<dynamic, dynamic> toJson() => {
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
//         "created_at": createdAt.toIso8601dynamic(),
//         "updated_at": updatedAt.toIso8601dynamic(),
//         "deleted_at": deletedAt,
//       };
// }

// class RatingList {
//   int id;
//   int senderId;
//   int receiverId;
//   int orderId;
//   dynamic rating;
//   dynamic? review;
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

//   factory RatingList.fromJson(Map<dynamic, dynamic> json) => RatingList(
//         id: json["id"] ?? 0,
//         senderId: json["sender_id"] ?? 0,
//         receiverId: json["receiver_id"] ?? 0,
//         orderId: json["order_id"] ?? 0,
//         rating: json["rating"] ?? "0.0",
//         review: json["review"] ?? '',
//         type: json["type"] ?? 1,
//         status: json["status"] ?? 1,
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );

//   Map<dynamic, dynamic> toJson() => {
//         "id": id,
//         "sender_id": senderId,
//         "receiver_id": receiverId,
//         "order_id": orderId,
//         "rating": rating,
//         "review": review,
//         "type": type,
//         "status": status,
//         "created_at": createdAt.toIso8601dynamic(),
//         "updated_at": updatedAt.toIso8601dynamic(),
//       };
// }




































// // class HistoryDataModel {
// //   int success;
// //   List<HistoryModel> historyModel;

// //   HistoryDataModel({
// //     required this.success,
// //     required this.historyModel,
// //   });

// //   factory HistoryDataModel.fromJson(Map<dynamic, dynamic> json) =>
// //       HistoryDataModel(
// //         success: json["success"],
// //         historyModel: List<HistoryModel>.from(
// //             json["history_order"].map((x) => HistoryModel.fromJson(x))),
// //       );

// //   Map<dynamic, dynamic> toJson() => {
// //         "success": success,
// //         "history_order":
// //             List<dynamic>.from(historyModel.map((x) => x.toJson())),
// //       };
// // }

// // class HistoryModel {
// //   dynamic? id;
// //   dynamic? driverId;
// //   dynamic startCoordinate;
// //   dynamic endCoordinate;
// //   dynamic startAddress;
// //   dynamic endAddress;
// //   dynamic distance;
// //   dynamic total;
// //   DateTime? orderTime;
// //   dynamic status;
// //   dynamic name;
// //   dynamic phone;
// //   dynamic email;
// //   dynamic paymentMethod;
// //   dynamic taxiType;
// //   dynamic timestamp;
// //   VehicleCategory vehicleCategory;

// //   HistoryModel({
// //     required this.id,
// //     required this.driverId,
// //     required this.startCoordinate,
// //     required this.endCoordinate,
// //     required this.startAddress,
// //     required this.endAddress,
// //     required this.distance,
// //     required this.total,
// //     required this.orderTime,
// //     required this.status,
// //     required this.name,
// //     required this.phone,
// //     required this.email,
// //     required this.paymentMethod,
// //     required this.taxiType,
// //     required this.timestamp,
// //     required this.vehicleCategory,
// //   });

// //   factory HistoryModel.fromJson(Map<dynamic, dynamic> json) => HistoryModel(
// //         id: json["id"] ?? '',
// //         driverId: json["driver_id"] ?? '',
// //         startCoordinate: json["start_coordinate"],
// //         endCoordinate: json["end_coordinate"],
// //         startAddress: json["start_address"] ?? '',
// //         endAddress: json["end_address"] ?? '',
// //         distance: json["distance"] ?? '',
// //         total: json["total"] ?? 0,
// //         orderTime: json["order_time"] != null
// //             ? DateTime.parse(json["order_time"])
// //             : DateTime.now(),
// //         status: json["status"] ?? "7",
// //         name: json["name"] ?? '',
// //         phone: json["phone"] ?? '',
// //         email: json["email"] ?? '',
// //         paymentMethod: json["payment_method"] ?? 1,
// //         taxiType: json["taxi_type"] ?? 1,
// //         timestamp: json["timestamp"],
// //         vehicleCategory: VehicleCategory.fromJson(json["vehicle_category"]),
// //       );

// //   Map<dynamic, dynamic> toJson() => {
// //         "id": id ?? '',
// //         "driver_id": driverId ?? '',
// //         "start_coordinate": startCoordinate,
// //         "end_coordinate": endCoordinate,
// //         "start_address": startAddress,
// //         "end_address": endAddress,
// //         "distance": distance,
// //         "total": total,
// //         "order_time": orderTime!.toIso8601dynamic(),
// //         "status": status,
// //         "name": name,
// //         "phone": phone,
// //         "email": email,
// //         "payment_method": paymentMethod,
// //         "taxi_type": taxiType,
// //         "timestamp": timestamp,
// //         "vehicle_category": vehicleCategory.toJson(),
// //       };
// // }

// // class VehicleCategory {
// //   dynamic id;
// //   dynamic category;
// //   dynamic priceKm;
// //   dynamic distance;
// //   dynamic minKm;
// //   dynamic minPrice;
// //   dynamic extraKm;
// //   dynamic seat;

// //   VehicleCategory({
// //     required this.id,
// //     required this.category,
// //     required this.priceKm,
// //     required this.distance,
// //     required this.minKm,
// //     required this.minPrice,
// //     required this.extraKm,
// //     required this.seat,
// //   });

// //   factory VehicleCategory.fromJson(Map<dynamic, dynamic> json) =>
// //       VehicleCategory(
// //         id: json["id"],
// //         category: json["category"],
// //         priceKm: json["price_km"],
// //         distance: json["distance"],
// //         minKm: json["min_km"],
// //         minPrice: json["min_price"],
// //         extraKm: json["extra_km"],
// //         seat: json["seat"],
// //       );

// //   Map<dynamic, dynamic> toJson() => {
// //         "id": id,
// //         "category": category,
// //         "price_km": priceKm,
// //         "distance": distance,
// //         "min_km": minKm,
// //         "min_price": minPrice,
// //         "extra_km": extraKm,
// //         "seat": seat,
// //       };
// // }
