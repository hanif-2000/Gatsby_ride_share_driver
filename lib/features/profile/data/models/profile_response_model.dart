import 'package:equatable/equatable.dart';

class ProfileResponseModel extends Equatable {
  final ProfileDataModel data;
  final num? success;

  const ProfileResponseModel({
    required this.data,
    this.success,
  });

  @override
  List<Object?> get props => [data, success];

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      ProfileResponseModel(
        data: ProfileDataModel.fromJson(json["driver"]),
        success: json['success'] ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'driver': data.toJson(),
        'success': success ?? '',
      };
}

class ProfileDataModel extends Equatable {
  final String? driverId;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final int? status;
  final String? image;
  final String? statusOrder;
  final String? plateNumber;
  final String? carModel;
  final String? vehicleName;
  final String? insuranceNumber;
  final CategoryModel vehicleCategory;
  final BankDetails bankDetails;
  // final List<dynamic> bankDetails;

  const ProfileDataModel(
      {required this.driverId,
      required this.name,
      required this.email,
      required this.vehicleName,
      required this.insuranceNumber,
      required this.phoneNumber,
      required this.status,
      required this.statusOrder,
      required this.plateNumber,
      required this.vehicleCategory,
      required this.carModel,
      required this.bankDetails,
      required this.image});

  @override
  List<Object?> get props => [
        driverId,
        name,
        email,
        phoneNumber,
        status,
        image,
        statusOrder,
        carModel,
        vehicleCategory,
        vehicleCategory,
        bankDetails,
      ];

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) =>
      ProfileDataModel(
          driverId: json['id'] ?? '',
          name: json['name'] ?? '',
          email: json['email'] ?? '',
          phoneNumber: json['phone'] ?? '',
          image: json['image'] ?? '',
          vehicleName: json['vehicle_name'] ?? '',
          insuranceNumber: json['insurance_number'] ?? '',
          statusOrder: json['order_status'] ?? '',
          plateNumber: json['plate_number'] ?? '',
          carModel: json['car_model'] ?? '',
          bankDetails: BankDetails.fromMap(json["bank_details"]),
          // bankDetails: List<dynamic>.from(json["bank_details"].map((x) => x)),
          vehicleCategory: CategoryModel.fromJson(json["vehicle_category"]),
          status: json['status'] ?? '');

  Map<String, dynamic> toJson() => {
        'id': driverId,
        'name': name,
        'email': email,
        'phone': phoneNumber,
        'image': image,
        'order_status': statusOrder,
        'status': status,
        'vehicle_name': vehicleName,
        'insurance_number': insuranceNumber,
        'vehicle_category': vehicleCategory.toJson(),
        'plate_number': plateNumber,
        'car_model': carModel,
        "bank_details": bankDetails.toMap(),
        // "bank_details": List<dynamic>.from(bankDetails.map((x) => x)),
      };
}

class CategoryModel extends Equatable {
  final num categoryId;
  final num priceKm;
  final num priceMin;
  final String categoryName;
  final dynamic seat;

  const CategoryModel({
    required this.categoryName,
    required this.seat,
    required this.priceKm,
    required this.categoryId,
    required this.priceMin,
  });

  @override
  List<Object?> get props => [
        categoryName,
        priceKm,
        categoryId,
        priceMin,
        seat,
      ];

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categoryName: json['category'],
        seat: json['seat'] ?? '',
        categoryId: json['id'],
        priceMin: json['min_km'],
        priceKm: json['price_km'],
      );

  Map<String, dynamic> toJson() => {
        'category': categoryName,
        'id': categoryId,
        'min_km': priceMin,
        'price_km': priceKm,
        'seat': seat,
      };
}

class BankDetails {
  int id;
  int driverId;
  String accountHolderName;
  String bankName;
  String accountNumber;
  // String ifscCode;
  String transitNumber;
  String institutionNumber;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  BankDetails({
    required this.id,
    required this.driverId,
    required this.accountHolderName,
    required this.bankName,
    required this.accountNumber,
    // required this.ifscCode,
    required this.transitNumber,
    required this.institutionNumber,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BankDetails.fromMap(Map<String, dynamic> json) => BankDetails(
        id: json["id"],
        driverId: json["driver_id"],
        accountHolderName: json["account_holder_name"] ?? '',
        bankName: json["bank_name"] ?? '',
        accountNumber: json["account_number"] ?? "",
        // ifscCode: json["ifsc_code"] ?? "",
        transitNumber: json["transit_number"] ?? "",
        institutionNumber: json["institution_number"] ?? '',
        status: json["status"] ?? "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "driver_id": driverId,
        "account_holder_name": accountHolderName,
        "bank_name": bankName,
        "account_number": accountNumber,
        "transit_number": transitNumber,
        "institution_number": institutionNumber,
        // "ifsc_code": ifscCode,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}











// // To parse this JSON data, do
// //
// //     final mapListResponseModal = mapListResponseModalFromJson(jsonString);

// import 'dart:convert';

// MapListResponseModal mapListResponseModalFromJson(String str) => MapListResponseModal.fromJson(json.decode(str));

// String mapListResponseModalToJson(MapListResponseModal data) => json.encode(data.toJson());

// class MapListResponseModal {
//     int success;
//     Driver driver;

//     MapListResponseModal({
//         required this.success,
//         required this.driver,
//     });

//     factory MapListResponseModal.fromJson(Map<String, dynamic> json) => MapListResponseModal(
//         success: json["success"],
//         driver: Driver.fromJson(json["driver"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "success": success,
//         "driver": driver.toJson(),
//     };
// }

// class Driver {
//     String id;
//     String name;
//     String email;
//     String phone;
//     String plateNumber;
//     String carModel;
//     String vehicleName;
//     String insuranceNumber;
//     int status;
//     String orderStatus;
//     String image;
//     VehicleCategory vehicleCategory;
//     BankDetails bankDetails;

//     Driver({
//         required this.id,
//         required this.name,
//         required this.email,
//         required this.phone,
//         required this.plateNumber,
//         required this.carModel,
//         required this.vehicleName,
//         required this.insuranceNumber,
//         required this.status,
//         required this.orderStatus,
//         required this.image,
//         required this.vehicleCategory,
//         required this.bankDetails,
//     });

//     factory Driver.fromJson(Map<String, dynamic> json) => Driver(
//         id: json["id"],
//         name: json["name"],
//         email: json["email"],
//         phone: json["phone"],
//         plateNumber: json["plate_number"],
//         carModel: json["car_model"],
//         vehicleName: json["vehicle_name"],
//         insuranceNumber: json["insurance_number"],
//         status: json["status"],
//         orderStatus: json["order_status"],
//         image: json["image"],
//         vehicleCategory: VehicleCategory.fromJson(json["vehicle_category"]),
//         bankDetails: BankDetails.fromJson(json["bank_details"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "phone": phone,
//         "plate_number": plateNumber,
//         "car_model": carModel,
//         "vehicle_name": vehicleName,
//         "insurance_number": insuranceNumber,
//         "status": status,
//         "order_status": orderStatus,
//         "image": image,
//         "vehicle_category": vehicleCategory.toJson(),
//         "bank_details": bankDetails.toJson(),
//     };
// }

// class BankDetails {
//     int id;
//     int driverId;
//     String accountHolderName;
//     String bankName;
//     String accountNumber;
//     String transitNumber;
//     String institutionNumber;
//     int status;
//     DateTime createdAt;
//     DateTime updatedAt;

//     BankDetails({
//         required this.id,
//         required this.driverId,
//         required this.accountHolderName,
//         required this.bankName,
//         required this.accountNumber,
//         required this.transitNumber,
//         required this.institutionNumber,
//         required this.status,
//         required this.createdAt,
//         required this.updatedAt,
//     });

//     factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
//         id: json["id"],
//         driverId: json["driver_id"],
//         accountHolderName: json["account_holder_name"],
//         bankName: json["bank_name"],
//         accountNumber: json["account_number"],
//         transitNumber: json["transit_number"],
//         institutionNumber: json["institution_number"],
//         status: json["status"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "driver_id": driverId,
//         "account_holder_name": accountHolderName,
//         "bank_name": bankName,
//         "account_number": accountNumber,
//         "transit_number": transitNumber,
//         "institution_number": institutionNumber,
//         "status": status,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//     };
// }

// class VehicleCategory {
//     int id;
//     String category;
//     double priceKm;
//     double priceMin;
//     int techFee;
//     int baseFare;
//     int distance;
//     double minKm;
//     int minPrice;
//     int extraKm;
//     String seat;
//     DateTime createdAt;
//     DateTime updatedAt;
//     dynamic deletedAt;

//     VehicleCategory({
//         required this.id,
//         required this.category,
//         required this.priceKm,
//         required this.priceMin,
//         required this.techFee,
//         required this.baseFare,
//         required this.distance,
//         required this.minKm,
//         required this.minPrice,
//         required this.extraKm,
//         required this.seat,
//         required this.createdAt,
//         required this.updatedAt,
//         required this.deletedAt,
//     });

//     factory VehicleCategory.fromJson(Map<String, dynamic> json) => VehicleCategory(
//         id: json["id"],
//         category: json["category"],
//         priceKm: json["price_km"]?.toDouble(),
//         priceMin: json["price_min"]?.toDouble(),
//         techFee: json["tech_fee"],
//         baseFare: json["base_fare"],
//         distance: json["distance"],
//         minKm: json["min_km"]?.toDouble(),
//         minPrice: json["min_price"],
//         extraKm: json["extra_km"],
//         seat: json["seat"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         deletedAt: json["deleted_at"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "category": category,
//         "price_km": priceKm,
//         "price_min": priceMin,
//         "tech_fee": techFee,
//         "base_fare": baseFare,
//         "distance": distance,
//         "min_km": minKm,
//         "min_price": minPrice,
//         "extra_km": extraKm,
//         "seat": seat,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//         "deleted_at": deletedAt,
//     };
// }

