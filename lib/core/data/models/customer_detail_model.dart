import 'package:equatable/equatable.dart';

class CustomerDetailModel extends Equatable {
  final CustomerDataModel data;
  final num? success;

  const CustomerDetailModel({
    required this.data,
    this.success,
  });

  @override
  List<Object?> get props => [data, success];

  factory CustomerDetailModel.fromJson(Map<String, dynamic> json) =>
      CustomerDetailModel(
        data: CustomerDataModel.fromJson(json['data']),
        success: json['success'] ?? 1,
      );
  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
        'success': success ?? 1,
      };
}

class CustomerDataModel extends Equatable {
  final String name;
  final String phoneNumber;
  final String photo;

  const CustomerDataModel({
    required this.name,
    required this.phoneNumber,
    required this.photo,
  });

  @override
  List<Object?> get props => [
        name,
        phoneNumber,
        photo,
      ];

  factory CustomerDataModel.fromJson(Map<String, dynamic> json) =>
      CustomerDataModel(
        name: json['name'],
        phoneNumber: json['phone'],
        photo: json['image'] ?? '',
      );
  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phoneNumber,
        'image': phoneNumber,
      };
}
