import 'package:appkey_taxiapp_driver/core/presentation/widgets/reject_tile.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';

class RejectReasonBottomSheet extends StatelessWidget {
  const RejectReasonBottomSheet({Key? key, this.reject}) : super(key: key);
  final Function(String)? reject;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reason',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 24,
            ).usePoppinsW6Font(),
          ),
          Text(
            'Lorem ipsum dolor sit amet consectetur. ',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
            ).usePoppinsW5Font(),
          ),
          mediumVerticalSpacing(),
          RejectTile(
            title: 'Wrong address shown',
            onTap: () {
              ///TOdo: Update rejection on the server
              reject!('Wrong address shown');
            },
          ),
          RejectTile(
            title: 'Any Legal instructions violation',
            onTap: () {
              ///TOdo: Update rejection on the server
              reject!('Any Legal instructions violation');
            },
          ),
          RejectTile(
            title: 'Other',
            onTap: () {
              ///TOdo: Update rejection on the server
              reject!('Other');
            },
          ),
        ],
      ),
    );
  }
}
