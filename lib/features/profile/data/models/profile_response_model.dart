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
  final String driverId;
  final String name;
  final String email;
  final String phoneNumber;
  final int status;
  final String image;
  final String statusOrder;
  final String plateNumber;
  final String carModel;
  final String vehicleName;
  final String insuranceNumber;
  final CategoryModel vehicleCategory;

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
        vehicleCategory
      ];

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) =>
      ProfileDataModel(
          driverId: json['id'],
          name: json['name'] ?? '',
          email: json['email'] ?? '',
          phoneNumber: json['phone'] ?? '',
          image: json['image'] ?? '',
          vehicleName: json['vehicle_name'] ?? '',
          insuranceNumber: json['insurance_number'] ?? '',
          statusOrder: json['order_status'] ?? '',
          plateNumber: json['plate_number'] ?? '',
          carModel: json['car_model'] ?? '',
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
      };
}

class CategoryModel extends Equatable {
  final num categoryId;
  final num priceKm;
  final num priceMin;
  final String categoryName;
  final int seat;

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
        seat: json['seat'],
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
