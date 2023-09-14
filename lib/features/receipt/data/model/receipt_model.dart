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
  dynamic total;
  DateTime orderTime;
  DateTime? startTime;
  DateTime? endTime;
  String status;
  String image;
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
    required this.status,
    required this.image,
    required this.userName,
    required this.userPhone,
    required this.rating,
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
            : null,
        endTime:
            json["end_time"] != null ? DateTime.parse(json["end_time"]) : null,
        status: json["status"],
        image: json["image"],
        userName: json["user_name"],
        userPhone: json["user_phone"],
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
        "order_time": orderTime.toIso8601String(),
        "end_time": endTime!.toIso8601String(),
        "start_time": endTime!.toIso8601String(),
        "status": status,
        "image": image,
        "user_name": userName,
        "user_phone": userPhone,
        "rating": rating,
        "payment_method": paymentMethod,
        "timestamp": timestamp,
      };
}
