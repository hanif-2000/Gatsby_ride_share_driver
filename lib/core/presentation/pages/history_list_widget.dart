import 'package:appkey_taxiapp_driver/core/presentation/widgets/history_tile.dart';
import 'package:flutter/material.dart';

class HistoryListWidget extends StatelessWidget {
  const HistoryListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        HistoryTile(),
        HistoryTile(),
        HistoryTile(),
        HistoryTile(),
      ],
    );
  }
}
