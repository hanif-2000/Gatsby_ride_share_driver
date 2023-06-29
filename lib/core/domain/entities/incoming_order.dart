import 'package:equatable/equatable.dart';

class IncomingOrderDetail extends Equatable {
  final String title, body, orderId, clickAction;

  const IncomingOrderDetail({
    required this.title,
    required this.body,
    required this.orderId,
    required this.clickAction,
  });

  @override
  List<Object?> get props => [
        title,
        body,
        orderId,
        clickAction,
      ];
}
