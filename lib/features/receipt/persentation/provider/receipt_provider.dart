import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/utility/app_settings.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/receipt/domain/usercases/do_contact_us.dart';
import 'package:appkey_taxiapp_driver/features/receipt/persentation/provider/receipt_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/presentation/pages/home_page/home_page.dart';
import '../../../../core/presentation/providers/form_provider.dart';
import '../../../../core/utility/helper.dart';
import 'dart:developer' as dev;

class ReceiptProvider extends FormProvider {
  final DoReceipt doReceipt;

  ReceiptProvider({required this.doReceipt});

  var session = locator<Session>();

  var dio = Dio();

  String paymentConfirmationUrl =
      "${BASE_URL}api/webservice/driver/payment/confirmation";

  Stream<ReceiptState> getReceiptAPI() async* {
    dev.log("distance:${session.estimatedDistance}");
    dev.log("distance:${session.estimatedTime}");

    yield ReceiptLoading();

    final loginResult = await doReceipt.call(session.runningOrderId.toString(),
        session.estimatedTime, session.estimatedDistance.toString());
    yield* loginResult.fold((statusCode) async* {
      logMe(statusCode);
      yield ReceiptFailure(failure: statusCode.message);
    }, (result) async* {
      yield ReceiptSuccess(data: result);
    });
  }

  paymentConfirmation(
      {required String paymentStatus, required BuildContext context}) async {
    showLoading();

    FormData data = FormData.fromMap({
      'payment_status': paymentStatus,
      'order_id': session.runningOrderId,
    });
    // var body = {
    //   'payment_status': paymentStatus,
    //   'order_id': session.runningOrderId,
    // };

    log(data.toString());
    log("session token :${session.sessionToken}");

    try {
      var response = await dio.request(
        '${BASE_URL}api/webservice/driver/payment/confirmation',
        data: data,
        options: Options(
            headers: {"Authorization": "Bearer ${session.sessionToken}"}),
      );

      log("res is:${response.data}");

      if (response.statusCode == 200) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomePage.routeName, (route) => false);
      } else {
        dismissLoading();

        showToast(message: "Something went wrong ,Please try again");
      }
    } catch (e) {
      dismissLoading();

      showToast(message: e.toString());

      log(e.toString());
    }
  }
}
