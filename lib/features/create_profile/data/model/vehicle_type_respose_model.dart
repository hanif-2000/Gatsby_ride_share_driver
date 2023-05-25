class VehicleTypeResponseModel {
  int? success;
  String? message;
  List<VehicleTypeDataModel> data;

  VehicleTypeResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VehicleTypeResponseModel.fromMap(Map<String, dynamic> json) =>
      VehicleTypeResponseModel(
        success: json["success"],
        message: json["message"],
        data: List<VehicleTypeDataModel>.from(
          json["data"].map(
            (x) => VehicleTypeDataModel.fromMap(x),
          ),
        ),
      );

  Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(
          data.map(
            (x) => x.toMap(),
          ),
        ),
      };
}

class VehicleTypeDataModel {
  int id;
  String category;

  VehicleTypeDataModel({
    required this.id,
    required this.category,
  });

  factory VehicleTypeDataModel.fromMap(Map<String, dynamic> json) =>
      VehicleTypeDataModel(
        id: json["id"],
        category: json["category"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "category": category,
      };
}
