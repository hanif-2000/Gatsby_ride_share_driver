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
  // final BankDetails bankDetails;
  final List<dynamic> bankDetails;

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
          // bankDetails: BankDetails.fromMap(json["bank_details"]),
          bankDetails: List<dynamic>.from(json["bank_details"].map((x) => x)),
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
        // "bank_details": bankDetails.toMap(),
        "bank_details": List<dynamic>.from(bankDetails.map((x) => x)),
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
  String ifscCode;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  BankDetails({
    required this.id,
    required this.driverId,
    required this.accountHolderName,
    required this.bankName,
    required this.accountNumber,
    required this.ifscCode,
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
        ifscCode: json["ifsc_code"] ?? "",
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
        "ifsc_code": ifscCode,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
