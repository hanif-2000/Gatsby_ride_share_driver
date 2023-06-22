import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/domain/usercases/do_contact_us.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/persentation/provider/contact_us_state.dart';
import 'package:appkey_taxiapp_driver/features/receipt/domain/usercases/do_contact_us.dart';
import 'package:appkey_taxiapp_driver/features/receipt/persentation/provider/receipt_state.dart';
import 'package:dio/dio.dart';
import '../../../../core/presentation/providers/form_provider.dart';
import '../../../../core/utility/helper.dart';

class ReceiptProvider extends FormProvider {
  final DoReceipt doReceipt;

  ReceiptProvider({required this.doReceipt});

  var session = locator<Session>();

  Stream<ReceiptState> getReceiptAPI() async* {
    yield ReceiptLoading();

    final loginResult = await doReceipt.call(session.runningOrderId.toString());
    yield* loginResult.fold((statusCode) async* {
      logMe(statusCode);
      yield ReceiptFailure(failure: statusCode.message);
    }, (result) async* {
      if (result != null) {
        yield ReceiptSuccess(data: result);
      } else {
        yield ReceiptFailure(failure: appLoc.loginfailure);
      }
    });
  }
}
