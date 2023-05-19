import 'package:appkey_taxiapp_driver/features/order/domain/entities/driver_detail.dart';

class DriverDetailModel extends DriverDetail {
  const DriverDetailModel({
    required String name,
    required String phone,
    required String model,
    required String plat,
  }) : super(
          name: name,
          phone: phone,
          model: model,
          plat: plat,
        );

  factory DriverDetailModel.fromJson(Map<String, dynamic> json) =>
      DriverDetailModel(
        name: json['nama_driver'],
        phone: json['telp_driver'],
        model: json['model_mobil'],
        plat: json['plat_mobil'],
      );

  @override
  Map<String, dynamic> toJson() => {
        "nama_driver": name,
        "telp_driver": phone,
        "model_mobil": model,
        "plat_mobil": plat,
      };
}
