import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import '../../../../core/presentation/providers/form_provider.dart';
import '../../data/models/history_response_model.dart';
import '../../domain/usecases/get_history.dart';
import 'history_state.dart';

class HistoryProvider extends FormProvider {
  final GetHistory getHistory;

  HistoryOrder? _history;
  HistoryOrder? get history => _history;

  HistoryProvider({required this.getHistory});

  Stream<HistoryState> fetchHistory() async* {
    logMe('Fetching History data  ---> ');
    yield HistoryLoading();
    final result = await getHistory();
    yield* result.fold((failure) async* {
      logMe("error");
      logMe(failure);
      yield HistoryFailure(failure: failure.message);
    }, (data) async* {
      logMe("loadedd $data");
      yield HistoryLoaded(data: data);
    });
  }
}
