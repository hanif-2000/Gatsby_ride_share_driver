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

  toJson() {}

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
