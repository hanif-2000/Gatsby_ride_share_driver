import 'package:appkey_taxiapp_driver/features/contact_us/domain/usercases/do_contact_us.dart';
import 'package:appkey_taxiapp_driver/features/contact_us/persentation/provider/contact_us_state.dart';
import 'package:appkey_taxiapp_driver/features/login/domain/usecases/do_login.dart';
import 'package:dio/dio.dart';

import '../../../../core/presentation/providers/form_provider.dart';
import '../../../../core/utility/helper.dart';

class ContactUsProvider extends FormProvider {
  final DoContactUs doContactUs;

  ContactUsProvider({required this.doContactUs});

  Stream<ContactUsState> doContactUsAPI(
      {String? email, String? message}) async* {
    yield ContactUsLoading();

    final loginResult = await doContactUs.call('api/webservice/contactUs',
        FormData.fromMap({'email': email, 'message': message}));
    yield* loginResult.fold((statusCode) async* {
      logMe(statusCode);
      yield ContactUsFailure(failure: statusCode.message);
    }, (result) async* {
      if (result != null) {
        yield ContactUsSuccess(data: result);
      } else {
        yield ContactUsFailure(failure: appLoc.loginfailure);
      }
    });
  }
}
