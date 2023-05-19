import 'package:appkey_taxiapp_driver/core/domain/entities/incoming_order.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/incoming_order.dart';

class FcmProvider with ChangeNotifier {
  IncomingOrderDetail? _incomingOrderDetail;

  set setIncomingOrder(val) {
    _incomingOrderDetail = val;
    notifyListeners();
  }

  IncomingOrderDetail? get incomingOrderDetail => _incomingOrderDetail;

  FcmProvider();
}
