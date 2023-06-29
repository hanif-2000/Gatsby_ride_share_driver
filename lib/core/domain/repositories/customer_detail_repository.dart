import 'package:dartz/dartz.dart';

import '../../data/models/customer_detail_model.dart';
import '../../error/failure.dart';

abstract class CustomerDetailRepository {
  Future<Either<Failure, CustomerDetailModel>> getCustomerDetail(String userId);
}
