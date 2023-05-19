import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';

import '../../../../core/presentation/widgets/dynamic_network_image.dart';
import '../../../../core/static/assets.dart';
import '../../data/models/profile_response_model.dart';

class TopProfile extends StatefulWidget {
  final ProfileDataModel data;

  const TopProfile({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<TopProfile> createState() => _TopProfileState();
}

class _TopProfileState extends State<TopProfile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              width: 160,
              height: 160,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(80),
                  child: DynamicCachedNetworkImage(
                      imageUrl: mergePhotoUrl(widget.data.image))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              widget.data.name,
              style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(widget.data.email,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(widget.data.phoneNumber,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(widget.data.plateNumber,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(mergeTypeTaxiProfile(widget.data.vehicleCategory),
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(widget.data.carModel,
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
