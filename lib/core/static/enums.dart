import 'package:dio/dio.dart';

extension DynamicHeader on Dio {
  Dio withToken() {
    return this..options.headers.addAll({'required_token': true});
  }

  Dio withFcmAuthorization(String key) {
    return this..options.headers.addAll({'Authorization': 'key=$key'});
  }
}

enum AddressType { origin, destination }

enum ProjectType {requests, history}

enum TypeField {
  email,
  phone,
  password,
  confirmPassword,
  name,
}

enum OrderStatus {
  lookingDriver,
  driverAccept,
  departureToCustomerplace,
  arriveAtCustomerPlace,
  customerConfirmation,
  departureToDestination,
  arriveAtDestination,
  complete,
  cancel,
}

enum PaymentMethod {
  cash,
  creditCard,
}

enum dialogStyle { style1, style2 }
