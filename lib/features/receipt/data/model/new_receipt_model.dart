// To parse this JSON data, do
//
//     final newReceiptModel = newReceiptModelFromJson(jsonString);

// NewReceiptModel newReceiptModelFromJson(String str) =>
//     NewReceiptModel.fromJson(json.decode(str));

// String newReceiptModelToJson(NewReceiptModel data) =>
//     json.encode(data.toJson());

class NewReceiptModel {
  dynamic response;
  String message;
  String type;
  int orderId;
  ReceiptData receiptData;

  NewReceiptModel({
    required this.response,
    required this.message,
    required this.type,
    required this.orderId,
    required this.receiptData,
  });

  factory NewReceiptModel.fromJson(Map<String, dynamic> json) =>
      NewReceiptModel(
        response: json["Response"],
        message: json["message"],
        type: json["type"],
        orderId: json["OrderID"],
        receiptData: ReceiptData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "Response": response,
        "message": message,
        "type": type,
        "OrderID": orderId,
        "data": receiptData.toJson(),
      };
}

class ReceiptData {
  dynamic id;
  String startAddress;
  String endAddress;
  dynamic distance;
  dynamic paymentMethod;
  dynamic estimatedTime;
  dynamic actualTime;
  DateTime createdAt;
  dynamic total;
  dynamic pendingAmount;
  dynamic customerId;
  String? name;
  String? image;
  dynamic longitude;
  dynamic latitude;
  dynamic phone;
  dynamic priceKm;
  dynamic priceMin;
  dynamic baseFare;
  dynamic techFee;

  dynamic minKm;
  dynamic minPrice;
  dynamic customerRating;
  dynamic orderTime;
  dynamic extraTime;
  dynamic extraDistance;
  dynamic extraDistancePrice;
  dynamic extraTimePrice;
  dynamic newTotal;
  dynamic tip;
  dynamic distance1;

  ReceiptData({
    required this.id,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.paymentMethod,
    required this.estimatedTime,
    required this.actualTime,
    required this.total,
    required this.pendingAmount,
    required this.customerId,
    required this.name,
    required this.image,
    required this.longitude,
    required this.latitude,
    required this.phone,
    required this.createdAt,
    required this.priceKm,
    required this.priceMin,
    required this.baseFare,
    required this.minKm,
    required this.minPrice,
    required this.customerRating,
    required this.orderTime,
    required this.extraDistance,
    required this.extraDistancePrice,
    required this.extraTime,
    required this.extraTimePrice,
    required this.newTotal,
    required this.tip,
    required this.distance1,
    required this.techFee,
  });

  factory ReceiptData.fromJson(Map<String, dynamic> json) => ReceiptData(
        id: json["id"] ?? '',
        startAddress: json["start_address"] ?? '',
        endAddress: json["end_address"] ?? "",
        distance: json["distance"] ?? '',
        distance1: json["distance1"] ?? '',
        paymentMethod: json["payment_method"] ?? 1,
        estimatedTime: json["estimated_time"] ?? '',
        actualTime: json["actual_time"],
        total: json["total"] ?? "",
        pendingAmount: json["pending_amount"] ?? "",
        customerId: json["customerID"] ?? "",
        name: json["name"] ?? "",
        image: json["image"] ?? "",
        longitude: json["Longitude"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        latitude: json["Latitude"] ?? "",
        phone: json["phone"] ?? "",
        priceKm: json["price_km"] ?? "",
        priceMin: json["price_min"] ?? '',
        baseFare: json["base_fare"] ?? '',
        techFee: json["tech_fee"] ?? json["techFee"] ?? '0.0',
        minKm: json["min_km"] ?? '',
        minPrice: json["min_price"] ?? "",
        customerRating: json["CustomerRating"] ?? "0",
        orderTime: json["orderTime"] ?? DateTime.now(),
        extraDistance: json["extra_distance"] ?? "",
        extraDistancePrice: json["extra_distance_price"] ?? "",
        extraTime: json["extra_time"] ?? "",
        extraTimePrice: json["extra_time_price"] ?? "",
        newTotal: json["new_total"]??json["newTotal"] ?? "",
        tip: json["tip"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start_address": startAddress,
        "end_address": endAddress,
        "distance": distance,
        "payment_method": paymentMethod,
        "estimated_time": estimatedTime,
        "actual_time": actualTime.split(',')[0],
        "total": total,
        "pending_amount": pendingAmount,
        "customerID": customerId,
        "name": name,
        "image": image,
        "Longitude": longitude,
        "Latitude": latitude,
        "created_at": createdAt.toIso8601String(),
        "phone": phone,
        "price_km": priceKm,
        "price_min": priceMin,
        "base_fare": baseFare,
        "min_km": minKm,
        "min_price": minPrice,
        "CustomerRating": customerRating,
        "extraDistance": extraDistance,
        "extraDistancePrice": extraDistancePrice,
        "extraTime": extraTime,
        "extraTimePrice": extraTimePrice,
        "newTotal": newTotal,
        "tip": tip,
        "distance1": distance1,
        "techFee": techFee,
      };
}
