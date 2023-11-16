import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/static/enums.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'helper.dart';

extension DynamicHeader on Dio {
  Dio withToken({String? token}) {
    if (token != null) {
      return this..options.headers.addAll({"Authorization": "Bearer $token"});
    }
    return this..options.headers.addAll({'required_token': true});
  }
}

// Font Families

extension CustomFontFamily on TextStyle {
  // TextStyle usePoppinsW3Font() {
  //   const String fontName = 'Poppins';
  //   return merge(
  //       const TextStyle(fontFamily: fontName, fontWeight: FontWeight.w300));
  // }

  TextStyle usePoppinsW6Font() {
    const String fontName = 'Poppins';
    return merge(
        const TextStyle(fontFamily: fontName, fontWeight: FontWeight.w600));
  }

  TextStyle usePoppinsW4Font() {
    const String fontName = 'Poppins';
    return merge(
        const TextStyle(fontFamily: fontName, fontWeight: FontWeight.w400));
  }
}

// extension LocalizationString on PaymentMethod {
//   String getString() {
//     switch (this) {
//       case PaymentMethod.cash:
//         return appLoc.cash.toUpperCase();
//       case PaymentMethod.creditCard:
//         return appLoc.creditdebit.toUpperCase();
//     }
//   }
// }

extension LocalizationStringOrder on OrderStatus {
  String getString() {
    switch (this) {
      case OrderStatus.lookingDriver:
        log("get string order status is 0");
        return appLoc.pending;
      case OrderStatus.cancel:
        log("get string order status is 8");
        return appLoc.cancel;
      case OrderStatus.driverAccept:
        log("get string order status is 1");
        return appLoc.departToCustomerPlace;
      case OrderStatus.departureToCustomerplace:
        log("get string order status is 2");
        return appLoc.arriveAtCustomerPlace;

      ///Same
      case OrderStatus.arriveAtCustomerPlace:
        log("get string order status is 3");
        return appLoc.departToDestination;

      ///Same
      // case OrderStatus.customerConfirmation:
      //   return appLoc.departToDestination;
      case OrderStatus.departureToDestination:
        log("get string order status is 5");
        return appLoc.arriveAtDestination;
      case OrderStatus.arriveAtDestination:
        log("get string order status is 6");
        return appLoc.endTrip;
      case OrderStatus.complete:
        log("get string order status is 7");
        return appLoc.endTrip;
    }
  }
}
