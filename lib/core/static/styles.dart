import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/dimens.dart';
import 'package:flutter/material.dart';
import '../types/fonts.dart';

TextStyle labelAppBar = const TextStyle(
        fontSize: 25.0, color: Colors.white, fontWeight: FontWeight.bold)
    .usePoppinsW4Font();

TextStyle labelTitleAppBar = const TextStyle(
        fontSize: 9.0, color: Colors.white, fontWeight: FontWeight.normal)
    .usePoppinsW4Font();

TextStyle distanceTextStyle = const TextStyle(
        fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.normal)
    .usePoppinsW4Font();

TextStyle selectPaymentStyle = const TextStyle(
        fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w300)
    .usePoppinsW4Font();

TextStyle paymentLabelStyle = const TextStyle(
        fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.bold)
    .usePoppinsW4Font();

TextStyle txtButtonStyle = const TextStyle(
        fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.w400)
    .usePoppinsW6Font();
TextStyle txtButtonCancelStyle = const TextStyle(
        fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold)
    .usePoppinsW6Font();
TextStyle txtButtonProfileStyle = const TextStyle(
        fontSize: 18.0, color: whiteColor, fontWeight: FontWeight.bold)
    .usePoppinsW6Font();

TextStyle searchBarInputTextStyle =
    const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)
        .usePoppinsW4Font();

TextStyle searchBarHintTextStyle =
    const TextStyle(fontSize: 14.0).usePoppinsW4Font();

TextStyle priceTextStyle = const TextStyle(
        fontSize: 20.0, fontWeight: FontWeight.bold, color: primaryColor)
    .usePoppinsW6Font();

TextStyle formLabelStyle = const TextStyle(
        fontSize: fontMedium, color: Colors.black, fontWeight: FontWeight.bold)
    .usePoppinsW4Font();

TextStyle formTextFieldStyle =
    const TextStyle(fontSize: 14, color: Colors.black).usePoppinsW6Font();

TextStyle blactStyle =
    const TextStyle(fontSize: 12, color: Colors.black).usePoppinsW6Font();

TextStyle titleStyle = const TextStyle(
        fontSize: fontExtraLarge,
        color: Colors.black,
        fontWeight: FontWeight.bold)
    .usePoppinsW6Font();

TextStyle appBarStyle(Color? textColor) =>
    TextStyle(fontSize: 16.0, color: textColor ?? Colors.white)
        .usePoppinsW6Font();
TextStyle formLabelHeaderStyle = const TextStyle(
        fontSize: fontMedium, color: Colors.black, fontWeight: FontWeight.bold)
    .usePoppinsW6Font();
TextStyle versionAppHeadTextStyle = const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: blackColor)
    .usePoppinsW6Font();
TextStyle versionAppTextStyle = const TextStyle(
        fontSize: 16.0, fontWeight: FontWeight.bold, color: greyBlackColor)
    .usePoppinsW6Font();
TextStyle titlePlatStyle =
    const TextStyle(fontSize: 16, color: Colors.black).usePoppinsW6Font();

TextStyle titleModelStyle =
    const TextStyle(fontSize: 14, color: Colors.black).usePoppinsW6Font();

TextStyle titleNameStyle =
    const TextStyle(fontSize: 13, color: Colors.black).usePoppinsW4Font();
