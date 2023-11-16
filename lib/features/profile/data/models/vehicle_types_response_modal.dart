// To parse this JSON data, do
//
//     final vehicleTypesResponseModal = vehicleTypesResponseModalFromJson(jsonString);

import 'dart:convert';

VehicleTypesResponseModal vehicleTypesResponseModalFromJson(String str) =>
    VehicleTypesResponseModal.fromJson(json.decode(str));

String vehicleTypesResponseModalToJson(VehicleTypesResponseModal data) =>
    json.encode(data.toJson());

class VehicleTypesResponseModal {
  int success;
  String message;
  List<Datum> data;

  VehicleTypesResponseModal({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VehicleTypesResponseModal.fromJson(Map<String, dynamic> json) =>
      VehicleTypesResponseModal(
        success: json["success"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String category;

  Datum({
    required this.id,
    required this.category,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category": category,
      };
}
