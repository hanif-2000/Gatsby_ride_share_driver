import 'dart:convert';

HistoryDataModel historyDataModelFromJson(String str) =>
    HistoryDataModel.fromJson(json.decode(str));

String historyDataModelToJson(HistoryDataModel data) =>
    json.encode(data.toJson());

class HistoryDataModel {
  int success;
  List<HistoryOrder> historyOrder;

  HistoryDataModel({
    required this.success,
    required this.historyOrder,
  });

  factory HistoryDataModel.fromJson(Map<String, dynamic> json) =>
      HistoryDataModel(
        success: json["success"],
        historyOrder: List<HistoryOrder>.from(
            json["history_order"].map((x) => HistoryOrder.fromJson(x))),
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
  String? driverName;
  String? image;
  String? plateNumber;
  int? rating;
  String? startCoordinate;
  String? endCoordinate;
  String? startAddress;
  String? endAddress;
  String? distance;
  String? total;
  DateTime orderTime;
  dynamic tip;
  dynamic extraTime;
  dynamic extraTimePrice;
  dynamic extraDistance;
  dynamic extraDistancePrice;

  int? status;
  String? timeSchool;
  String? timeAfterSchool;
  String? paymentMethod;
  String? taxiType;
  String? timestamp;
  CategoryClass category;
  List<RatingList>? ratingList;

  HistoryOrder({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.image,
    required this.plateNumber,
    required this.rating,
    required this.startCoordinate,
    required this.endCoordinate,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.total,
    required this.orderTime,
    required this.tip,
    required this.status,
    required this.timeSchool,
    required this.timeAfterSchool,
    required this.paymentMethod,
    required this.taxiType,
    required this.timestamp,
    required this.category,
    required this.ratingList,
    required this.extraTime,
    required this.extraTimePrice,
    required this.extraDistance,
    required this.extraDistancePrice,
  });

  factory HistoryOrder.fromJson(Map<String, dynamic> json) => HistoryOrder(
        id: json["id"] ?? '',
        driverId: json["driver_id"] ?? "",
        driverName: json["driver_name"] ?? "",
        image: json["image"] ?? '',
        plateNumber: json["plate_number"] ?? '',
        rating: json["rating"] ?? 0,
        tip: json["tip"] ?? 0,
        extraTime: json["extra_time"] ?? "0",
        extraTimePrice: json["extra_time_price"] ?? "0",
        extraDistance: json["extra_distance"] ?? "0",
        extraDistancePrice: json["extra_distance_price"] ?? "0",
        startCoordinate: json["start_coordinate"] ?? '',
        endCoordinate: json["end_coordinate"] ?? "",
        startAddress: json["start_address"] ?? "",
        endAddress: json["end_address"] ?? "",
        distance: json["distance"] ?? '',
        total: json["total"] ?? "",
        orderTime: DateTime.parse(json["order_time"]),
        status: json["status"] ?? 0,
        timeSchool: json["time_school"] ?? '6',
        timeAfterSchool: json["time_after_school"] ?? '',
        paymentMethod: json["payment_method"],
        taxiType: json["taxi_type"] ?? '1',
        timestamp: json["timestamp"] ?? '',
        category: CategoryClass.fromJson(json["category"]),
        ratingList: json["rating_list"] != null
            ? List<RatingList>.from(
                json["rating_list"].map((x) => RatingList.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver_id": driverId,
        "driver_name": driverName,
        "image": image,
        "plate_number": plateNumber,
        "rating": rating,
        "start_coordinate": startCoordinate,
        "end_coordinate": endCoordinate,
        "start_address": startAddress,
        "end_address": endAddress,
        "distance": distance,
        "total": total,
        "tip": tip,
        "order_time": orderTime.toIso8601String(),
        "status": status,
        "time_school": timeSchool,
        "time_after_school": timeAfterSchool,
        "payment_method": paymentMethod,
        "extraTime": extraTime,
        "extraTimePrice": extraTimePrice,
        "extraDistance": extraDistance,
        "extraDistancePrice": extraDistancePrice,
        "taxi_type": taxiType,
        "timestamp": timestamp,
        "category": category.toJson(),
        "rating_list": List<dynamic>.from(ratingList!.map((x) => x.toJson())),
      };
}

class CategoryClass {
  int id;
  String? category;
  double? priceKm;
  int? techFee;
  double? baseFare;
  int? distance;
  double? minKm;
  int? minPrice;
  int? extraKm;
  String? seat;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  CategoryClass({
    required this.id,
    required this.category,
    required this.priceKm,
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

  factory CategoryClass.fromJson(Map<String, dynamic> json) => CategoryClass(
        id: json["id"] ?? 0,
        category: json["category"] ?? '',
        priceKm: json["price_km"]?.toDouble(),
        techFee: json["tech_fee"],
        baseFare: json["base_fare"]?.toDouble(),
        distance: json["distance"],
        minKm: json["min_km"]?.toDouble(),
        minPrice: json["min_price"],
        extraKm: json["extra_km"],
        seat: json["seat"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
        "price_km": priceKm,
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

class RatingList {
  int id;
  int senderId;
  int receiverId;
  int orderId;
  String rating;
  String? review;
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
        id: json["id"] ?? 0,
        senderId: json["sender_id"] ?? 0,
        receiverId: json["receiver_id"] ?? 0,
        orderId: json["order_id"] ?? 0,
        rating: json["rating"] ?? "0.0",
        review: json["review"] ?? '',
        type: json["type"] ?? 1,
        status: json["status"] ?? 1,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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




































// class HistoryDataModel {
//   int success;
//   List<HistoryModel> historyModel;

//   HistoryDataModel({
//     required this.success,
//     required this.historyModel,
//   });

//   factory HistoryDataModel.fromJson(Map<String, dynamic> json) =>
//       HistoryDataModel(
//         success: json["success"],
//         historyModel: List<HistoryModel>.from(
//             json["history_order"].map((x) => HistoryModel.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "success": success,
//         "history_order":
//             List<dynamic>.from(historyModel.map((x) => x.toJson())),
//       };
// }

// class HistoryModel {
//   String? id;
//   String? driverId;
//   dynamic startCoordinate;
//   dynamic endCoordinate;
//   dynamic startAddress;
//   dynamic endAddress;
//   dynamic distance;
//   dynamic total;
//   DateTime? orderTime;
//   dynamic status;
//   dynamic name;
//   dynamic phone;
//   dynamic email;
//   dynamic paymentMethod;
//   dynamic taxiType;
//   String timestamp;
//   VehicleCategory vehicleCategory;

//   HistoryModel({
//     required this.id,
//     required this.driverId,
//     required this.startCoordinate,
//     required this.endCoordinate,
//     required this.startAddress,
//     required this.endAddress,
//     required this.distance,
//     required this.total,
//     required this.orderTime,
//     required this.status,
//     required this.name,
//     required this.phone,
//     required this.email,
//     required this.paymentMethod,
//     required this.taxiType,
//     required this.timestamp,
//     required this.vehicleCategory,
//   });

//   factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
//         id: json["id"] ?? '',
//         driverId: json["driver_id"] ?? '',
//         startCoordinate: json["start_coordinate"],
//         endCoordinate: json["end_coordinate"],
//         startAddress: json["start_address"] ?? '',
//         endAddress: json["end_address"] ?? '',
//         distance: json["distance"] ?? '',
//         total: json["total"] ?? 0,
//         orderTime: json["order_time"] != null
//             ? DateTime.parse(json["order_time"])
//             : DateTime.now(),
//         status: json["status"] ?? "7",
//         name: json["name"] ?? '',
//         phone: json["phone"] ?? '',
//         email: json["email"] ?? '',
//         paymentMethod: json["payment_method"] ?? 1,
//         taxiType: json["taxi_type"] ?? 1,
//         timestamp: json["timestamp"],
//         vehicleCategory: VehicleCategory.fromJson(json["vehicle_category"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id ?? '',
//         "driver_id": driverId ?? '',
//         "start_coordinate": startCoordinate,
//         "end_coordinate": endCoordinate,
//         "start_address": startAddress,
//         "end_address": endAddress,
//         "distance": distance,
//         "total": total,
//         "order_time": orderTime!.toIso8601String(),
//         "status": status,
//         "name": name,
//         "phone": phone,
//         "email": email,
//         "payment_method": paymentMethod,
//         "taxi_type": taxiType,
//         "timestamp": timestamp,
//         "vehicle_category": vehicleCategory.toJson(),
//       };
// }

// class VehicleCategory {
//   dynamic id;
//   dynamic category;
//   dynamic priceKm;
//   dynamic distance;
//   dynamic minKm;
//   dynamic minPrice;
//   dynamic extraKm;
//   dynamic seat;

//   VehicleCategory({
//     required this.id,
//     required this.category,
//     required this.priceKm,
//     required this.distance,
//     required this.minKm,
//     required this.minPrice,
//     required this.extraKm,
//     required this.seat,
//   });

//   factory VehicleCategory.fromJson(Map<String, dynamic> json) =>
//       VehicleCategory(
//         id: json["id"],
//         category: json["category"],
//         priceKm: json["price_km"],
//         distance: json["distance"],
//         minKm: json["min_km"],
//         minPrice: json["min_price"],
//         extraKm: json["extra_km"],
//         seat: json["seat"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "category": category,
//         "price_km": priceKm,
//         "distance": distance,
//         "min_km": minKm,
//         "min_price": minPrice,
//         "extra_km": extraKm,
//         "seat": seat,
//       };
// }
