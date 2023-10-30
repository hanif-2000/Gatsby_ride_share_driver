class ReceiptDataModel {
  int success;
  List<OrderReceipt> orderReceipt;

  ReceiptDataModel({
    required this.success,
    required this.orderReceipt,
  });

  factory ReceiptDataModel.fromJson(Map<String, dynamic> json) =>
      ReceiptDataModel(
        success: json["success"],
        orderReceipt: List<OrderReceipt>.from(
            json["Order receipt"].map((x) => OrderReceipt.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "Order receipt":
            List<dynamic>.from(orderReceipt.map((x) => x.toJson())),
      };
}

class OrderReceipt {
  String id;
  String driverId;
  String distance;
  String total;
  DateTime orderTime;
  DateTime? startTime;
  DateTime? endTime;
  String grandTotal;
  String extraTime;
  String extraKmPrice;
  String extraDistance;
  String extraDistancePrice;
  dynamic tip;

  String status;
  String? image;
  String userName;
  String userPhone;
  double? rating;
  int paymentMethod;
  String timestamp;

  OrderReceipt({
    required this.id,
    required this.driverId,
    required this.distance,
    required this.total,
    required this.orderTime,
    this.startTime,
    this.endTime,
    required this.grandTotal,
    required this.extraTime,
    required this.extraKmPrice,
    required this.extraDistance,
    required this.extraDistancePrice,
    required this.status,
    required this.image,
    required this.userName,
    required this.userPhone,
    required this.rating,
    required this.tip,
    required this.paymentMethod,
    required this.timestamp,
  });

  factory OrderReceipt.fromJson(Map<String, dynamic> json) => OrderReceipt(
        id: json["id"],
        driverId: json["driver_id"],
        distance: json["distance"],
        total: json["total"],
        orderTime: DateTime.parse(json["order_time"]),
        startTime: json["start_time"] != null
            ? DateTime.parse(json["start_time"])
            : DateTime.parse(json["end_time"]),
        endTime: json["end_time"] != null
            ? DateTime.parse(json["end_time"])
            : DateTime.parse(json["start_time"]),
        status: json["status"],
        image: json["image"] ?? '',
        tip: json["tip"] ?? 0,
        userName: json["user_name"],
        userPhone: json["user_phone"],
        grandTotal: json["grand_total"] ?? "0",
        extraTime: json["extra_time"] ?? '0',
        extraKmPrice: json["extra_km_price"] ?? '0',
        extraDistance: json["extra_distance"] ?? '0',
        extraDistancePrice: json["extra_distance_price"] ?? '0',
        rating: json["rating"] != null
            ? double.tryParse(json["rating"].toString())
            : 0.0,
        paymentMethod: json["payment_method"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "driver_id": driverId,
        "distance": distance,
        "total": total,
        "grand_total": grandTotal,
        "extra_time": extraTime,
        "extra_km_price": extraKmPrice,
        "extra_distance": extraDistance,
        "extra_distance_price": extraDistancePrice,
        "order_time": orderTime.toIso8601String(),
        "end_time": endTime!.toIso8601String(),
        "start_time": endTime!.toIso8601String(),
        "status": status,
        "image": image,
        "user_name": userName,
        "user_phone": userPhone,
        "rating": rating,
        "tip": tip,
        "payment_method": paymentMethod,
        "timestamp": timestamp,
      };
}
