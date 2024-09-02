import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/presentation/provider/create_profile_provider.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomStepper extends StatelessWidget {
  const CustomStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateProfileProvider>(builder: (context, provider, _) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                stepTile(title: '1', isSelected: provider.currentStep >= 1),
                Expanded(child: filledLine()),
                provider.currentStep > 1
                    ? Expanded(child: filledLine())
                    : Expanded(child: dottedLine()),
                stepTile(title: '2', isSelected: provider.currentStep >= 2),
                provider.currentStep > 1
                    ? Expanded(child: filledLine())
                    : Expanded(child: dottedLine()),
                provider.currentStep > 2
                    ? Expanded(child: filledLine())
                    : Expanded(child: dottedLine()),
                stepTile(title: '3', isSelected: provider.currentStep >= 3),
              ],
            ),
          ),
          smallVerticalSpacing(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appLoc.personalDetail,
                    textAlign: TextAlign.center,
                    style: formTextFieldStyle.copyWith(fontSize: 10)),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    appLoc.vehicleDetail,
                    textAlign: TextAlign.center,
                    style: formTextFieldStyle.copyWith(
                      fontSize: 10,
                      color: provider.currentStep > 1 ? blackColor : grey7D7979,
                    ),
                  ),
                ),
                Text(
                  appLoc.bankDetail,
                  textAlign: TextAlign.center,
                  style: formTextFieldStyle.copyWith(
                    fontSize: 10,
                    color: provider.currentStep > 2 ? blackColor : grey7D7979,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  dottedLine() {
    return const Padding(
      padding: EdgeInsets.only(left: 1),
      child: DottedLine(
        dashColor: grey7c7c7c,
      ),
    );
  }

  filledLine() {
    return Container(
      height: 2,
      color: primaryColor,
    );
  }

  stepTile({title, isSelected}) {
    return Container(
      height: 30,
      width: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? primaryColor : Colors.transparent,
        shape: BoxShape.circle,
        border:
            Border.all(color: isSelected ? primaryColor : grey7D7979, width: 1),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : grey7D7979,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}
