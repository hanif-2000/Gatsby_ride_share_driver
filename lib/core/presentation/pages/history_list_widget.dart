import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/presentation/widgets/history_tile.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/history/presentation/providers/history_provider.dart';
import 'package:appkey_taxiapp_driver/features/history/presentation/providers/history_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryListWidget extends StatelessWidget {
  const HistoryListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (context, provider, _) {
        return StreamBuilder<HistoryState>(
          stream: context.read<HistoryProvider>().fetchHistory(),
          builder: (context, state) {
            switch (state.data.runtimeType) {
              case HistoryLoading:
                log("History Loading");
                return const Center(
                    child: CircularProgressIndicator(
                  color: blackColor,
                ));
              case HistoryFailure:
                log("History Failure");

                final failure = (state.data as HistoryFailure).failure;
                showToast(message: "Network slow Please try again");
                return const SizedBox.shrink();
              case HistoryLoaded:
                log("History Loaded");

                final _data = (state.data as HistoryLoaded).data;
                logMe('History length --> ${_data.length}');
                if (_data.isEmpty) {
                  return Center(
                    child: Text(
                      appLoc.therearenopastorders,
                      style: formLabelHeaderStyle,
                    ),
                  );
                }
                return Column(
                  children: List.generate(
                    _data.length,
                    (index) => HistoryTile(
                      order: _data[index],
                    ),
                  ),
                );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
