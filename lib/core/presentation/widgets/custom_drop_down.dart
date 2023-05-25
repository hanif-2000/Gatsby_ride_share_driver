import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/dimens.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/features/create_profile/data/model/vehicle_type_respose_model.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown(
      {Key? key, this.values, this.selectedValue, this.onChange, this.hint})
      : super(key: key);
  final List<String>? values;
  final String? selectedValue;
  final String? hint;
  final Function(String)? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: sizeMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: grey7c7c7c),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedValue,
          hint: Text(
            hint!,
            style: const TextStyle(
              fontSize: 14,
              color: grey7D7979,
            ).usePoppinsW4Font(),
          ),
          icon: const Icon(
            Icons.expand_more_outlined,
            color: primaryColor,
          ),
          iconSize: 24,
          elevation: 16,
          underline: null,
          style: const TextStyle(
            color: grey7D7979,
          ).usePoppinsW4Font(),
          onChanged: (newValue) {
            onChange!(newValue!);
          },
          items: values!.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: formTextFieldStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CustomTypeDropDown extends StatelessWidget {
  const CustomTypeDropDown(
      {Key? key, this.values, this.selectedValue, this.onChange, this.hint})
      : super(key: key);
  final List<VehicleTypeDataModel>? values;
  final VehicleTypeDataModel? selectedValue;
  final String? hint;
  final Function(VehicleTypeDataModel)? onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: sizeMedium),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: grey7c7c7c),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<VehicleTypeDataModel>(
          isExpanded: true,
          value: selectedValue,
          hint: Text(
            hint!,
            style: const TextStyle(
              fontSize: 14,
              color: grey7D7979,
            ).usePoppinsW4Font(),
          ),
          icon: const Icon(
            Icons.expand_more_outlined,
            color: primaryColor,
          ),
          iconSize: 24,
          elevation: 16,
          underline: null,
          style: const TextStyle(
            color: grey7D7979,
          ).usePoppinsW4Font(),
          onChanged: (newValue) {
            onChange!(newValue!);
          },
          items: values!.map<DropdownMenuItem<VehicleTypeDataModel>>(
              (VehicleTypeDataModel value) {
            return DropdownMenuItem<VehicleTypeDataModel>(
              value: value,
              child: Text(
                value.category,
                style: formTextFieldStyle.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
