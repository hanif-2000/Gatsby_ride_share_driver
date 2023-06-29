import '../domain/entities/incoming_order.dart';
import '../presentation/providers/fcm_provider.dart';
import 'injection.dart';

class NotificationHandler {
  static handleNotificationAction(IncomingOrderDetail incomingOrderDetail) {
    final _fcmProvider = locator<FcmProvider>();

    _fcmProvider.setIncomingOrder = incomingOrderDetail;
  }
}
