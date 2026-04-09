import 'package:appkey_taxiapp_driver/features/order/domain/entities/order_detail.dart';
import 'package:appkey_taxiapp_driver/features/order/domain/entities/order_detail_response.dart';

import 'detail_order_model.dart';

class OrderDetailResponseModel extends OrderDetailResponse {
  const OrderDetailResponseModel({
    required int success,
    required OrderDetail data,
  }) : super(
          success: success,
          data: data,
        );

  factory OrderDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailResponseModel(
          success: json['success'] ?? 0,
          data: DetailOrderModel.fromJson(json["order"] ?? json["data"] ?? {}));
  @override
  Map<String, dynamic> toJson() => {
        'success': success,
        'order': data.toJson(),
      };
}
