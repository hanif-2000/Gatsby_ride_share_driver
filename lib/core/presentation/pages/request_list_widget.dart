import 'package:appkey_taxiapp_driver/core/presentation/widgets/request_tile.dart';
import 'package:flutter/material.dart';

class RequestListWidget extends StatelessWidget {
  const RequestListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        RequestTile(),
        RequestTile(),
        RequestTile(),
        RequestTile(),
      ],
    );
  }
}
