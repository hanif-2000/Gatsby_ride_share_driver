import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/data/datasources/price_category_datasource.dart';
import 'package:appkey_taxiapp_driver/core/domain/entities/currency.dart';
import 'package:appkey_taxiapp_driver/core/domain/entities/price_category_list.dart';
import 'package:appkey_taxiapp_driver/core/domain/repositories/price_category_repository.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/currency_repository.dart';
import '../../error/failure.dart';
import '../../network/network_info.dart';
import '../datasources/currency_datasource.dart';

class PriceCategoryRepositoryImplementation implements PriceCategoryRepository {
  final PriceCategoryDataSource dataSource;
  final NetworkInfo networkInfo;

  PriceCategoryRepositoryImplementation({
    required this.dataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, PriceCategoryList>> getPriceCategoryList() async {
    if (!await networkInfo.isConnected) {
      return const Left(ConnectionFailure());
    }

    try {
      final response = await dataSource.getPriceCategoryList();
      return Right(response);
    } catch (e) {
      return const Left(ServerFailure());
    }
  }
}
