import 'package:equatable/equatable.dart';

class OrderDetail extends Equatable {
  final dynamic totalPrice, pendingAmount, newTotal;
  final int orderId, userId, driverId, orderStatus;
  final String startCoordinate,
      endCoordinate,
      distance,
      startAddress,
      endAddress;

  const OrderDetail({
    required this.orderId,
    required this.totalPrice,
    required this.userId,
    required this.driverId,
    required this.distance,
    required this.orderStatus,
    required this.startCoordinate,
    required this.endCoordinate,
    required this.startAddress,
    required this.endAddress,
    required this.pendingAmount,
    required this.newTotal,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'totalPrice': totalPrice,
      'userId': userId,
      'driverId': driverId,
      'distance': distance,
      'orderStatus': orderStatus,
      'startCoordinate': startCoordinate,
      'endCoordinate': endCoordinate,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'pendingAmount': pendingAmount,
      'newTotal': newTotal,
    };
  }

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderId: json['orderId'],
      totalPrice: json['totalPrice'],
      userId: json['userId'],
      driverId: json['driverId'],
      distance: json['distance'],
      orderStatus: json['orderStatus'],
      startCoordinate: json['startCoordinate'],
      endCoordinate: json['endCoordinate'],
      startAddress: json['startAddress'],
      endAddress: json['endAddress'],
      pendingAmount: json['pendingAmount'],
      newTotal: json['newTotal'],
    );
  }

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [
        orderId,
        totalPrice,
        userId,
        distance,
        driverId,
        orderStatus,
        startCoordinate,
        endCoordinate,
        startAddress,
        endAddress,
        pendingAmount,
        newTotal
      ];
}
