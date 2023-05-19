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
  TextStyle useHiraginoKakuW3Font() {
    const String fontName = 'Hiragino Kaku';
    return merge(
        const TextStyle(fontFamily: fontName, fontWeight: FontWeight.w300));
  }

  TextStyle useHiraginoKakuW6Font() {
    const String fontName = 'Hiragino Kaku';
    return merge(
        const TextStyle(fontFamily: fontName, fontWeight: FontWeight.w600));
  }

  TextStyle useHiraginoMaruW4Font() {
    const String fontName = 'Hiragino Maru';
    return merge(
        const TextStyle(fontFamily: fontName, fontWeight: FontWeight.w400));
  }
}

extension LocalizationString on PaymentMethod {
  String getString() {
    switch (this) {
      case PaymentMethod.cash:
        return appLoc.cash.toUpperCase();
      case PaymentMethod.creditCard:
        return appLoc.creditdebit.toUpperCase();
    }
  }
}

extension LocalizationStringOrder on OrderStatus {
  String getString() {
    switch (this) {
      case OrderStatus.lookingDriver:
        return appLoc.pending;
      case OrderStatus.cancel:
        return appLoc.cancel;
      case OrderStatus.driverAccept:
        return appLoc.departToCustomerPlace;
      case OrderStatus.departureToCustomerplace:
        return appLoc.arriveAtCustomerPlace;
      case OrderStatus.arriveAtCustomerPlace:
        return appLoc.arriveAtCustomerPlace;
      case OrderStatus.customerConfirmation:
        return appLoc.departToDestination;
      case OrderStatus.departureToDestination:
        return appLoc.arriveAtDestination;
      case OrderStatus.arriveAtDestination:
        return appLoc.complete;
      case OrderStatus.complete:
        return appLoc.complete;
    }
  }
}
