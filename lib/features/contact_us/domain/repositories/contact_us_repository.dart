import 'package:appkey_taxiapp_driver/features/contact_us/data/model/contact_us_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';


abstract class ContactUsRepository {
  Future<Either<Failure, ContactUsResponseModel>> doContactUs(String url,
      FormData formData);

}
