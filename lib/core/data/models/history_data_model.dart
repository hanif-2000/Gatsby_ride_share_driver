class HistoryDataModel {
  int success;
  List<HistoryModel> historyModel;

  HistoryDataModel({
    required this.success,
    required this.historyModel,
  });

  factory HistoryDataModel.fromJson(Map<String, dynamic> json) =>
      HistoryDataModel(
        success: json["success"],
        historyModel: List<HistoryModel>.from(
            json["history_order"].map((x) => HistoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "history_order":
            List<dynamic>.from(historyModel.map((x) => x.toJson())),
      };
}

class HistoryModel {
  String id;
  String driverId;
  String startCoordinate;
  String endCoordinate;
  String startAddress;
  String endAddress;
  String distance;
  int total;
  DateTime orderTime;
  String status;
  String name;
  String phone;
  String email;
  int paymentMethod;
  int taxiType;
  String timestamp;
  VehicleCategory vehicleCategory;

  HistoryModel({
    required this.id,
    required this.driverId,
    required this.startCoordinate,
    required this.endCoordinate,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.total,
    required this.orderTime,
    required this.status,
    required this.name,
    required this.phone,
    required this.email,
    required this.paymentMethod,
    required this.taxiType,
    required this.timestamp,
    required this.vehicleCategory,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        id: json["id"],
        driverId: json["driver_id"],
        startCoordinate: json["start_coordinate"],
        endCoordinate: json["end_coordinate"],
        startAddress: json["start_address"],
        endAddress: json["end_address"],
        distance: json["distance"],
        total: json["total"],
        orderTime: DateTime.parse(json["order_time"]),
        status: json["status"],
        name: json["name"],
        phone: json["phone"],
        email: json["email"],
        paymentMethod: json["payment_method"],
        taxiType: json["taxi_type"],
        timestamp: json["timestamp"],
        vehicleCategory: VehicleCategory.fromJson(json["vehicle_category"]),
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
        "status": status,
        "name": name,
        "phone": phone,
        "email": email,
        "payment_method": paymentMethod,
        "taxi_type": taxiType,
        "timestamp": timestamp,
        "vehicle_category": vehicleCategory.toJson(),
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

  factory VehicleCategory.fromJson(Map<String, dynamic> json) =>
      VehicleCategory(
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

  Map<String, dynamic> toJson() => {
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
