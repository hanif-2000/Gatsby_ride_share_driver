
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/history_response_model.dart';

abstract class HistoryRepository {
  Future<Either<Failure, List<HistoryOrder>>> getHistory();
}
