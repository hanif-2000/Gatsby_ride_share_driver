import 'package:appkey_taxiapp_driver/core/data/models/customer_detail_model.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/customer_detail_repository.dart';
import '../../error/failure.dart';
import '../../network/network_info.dart';
import '../datasources/customer_detail_datasource.dart';

class CustomerDetailRepositoryImplementation
    implements CustomerDetailRepository {
  final CustomerDetailDataSource dataSource;
  final NetworkInfo networkInfo;

  CustomerDetailRepositoryImplementation({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, CustomerDetailModel>> getCustomerDetail(
      String userId) async {
    if (!await networkInfo.isConnected) {
      return const Left(ConnectionFailure());
    }

    try {
      final response = await dataSource.getCustomerDetail(userId);
      return Right(response);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
