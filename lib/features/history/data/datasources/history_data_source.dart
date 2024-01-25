import 'package:appkey_taxiapp_driver/core/utility/extension.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:dio/dio.dart';
import '../../../../core/utility/injection.dart';
import '../../../../core/utility/session_helper.dart';
import '../models/history_response_model.dart';

abstract class HistoryDataSource {
  Future<List<HistoryOrder>> getHistory();
}

class HistoryDataSourceImplementation implements HistoryDataSource {
  final Dio dio;

  HistoryDataSourceImplementation({required this.dio});

  @override
  Future<List<HistoryOrder>> getHistory() async {
    final session = locator<Session>();
    String userId = session.userId;
    String url = 'api/webservice/driver/order';
    dio.withToken();
    try {
      final response = await dio.get(
        url,
      );
      print("========>>>response$response");
      final model = HistoryResponseModel.fromJson(response.data);
      print("========>>>success${model.success}");
      if (model.success == 1) {
        print("========>>>historyOrder${model.historyOrder}");
        return model.historyOrder;
      } else if (response.data["message"] == "Account Suspended") {
        showToast(message: "Account Suspended");

        return response.data["message"];
      } else {
        return [];
      }
    } catch (e, s) {
      print("========>>>error$e, $s");
      rethrow;
    }
  }
}
