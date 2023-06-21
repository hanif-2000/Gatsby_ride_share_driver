import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/history/presentation/widgets/history_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/static/styles.dart';
import '../providers/history_state.dart';
import '../providers/history_provider.dart';

class HistoryPage extends StatefulWidget {
  static const String routeName = "HistoryPage";

  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryProvider>(
      builder: (context, provider, _) {
        return StreamBuilder<HistoryState>(
          stream: context.read<HistoryProvider>().fetchHistory(),
          builder: (context, state) {
            switch (state.data.runtimeType) {
              case HistoryLoading:
                return const Center(child: CircularProgressIndicator());
              case HistoryFailure:
                final failure = (state.data as HistoryFailure).failure;
                showToast(message: failure);
                return const SizedBox.shrink();
              case HistoryLoaded:
                final _data = (state.data as HistoryLoaded).data;
                if (_data.isEmpty) {
                  return Center(
                    child: Text(
                      appLoc.therearenopastorders,
                      style: formLabelHeaderStyle,
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: _data.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: HistoryItem(data: _data[index]),
                    );
                  },
                );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );

    // return Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   backgroundColor: greyColor,
    //   appBar: CustomAppTtitleBar(
    //     centerTitle: true,
    //     canBack: true,
    //     title: appLoc.history.toUpperCase(),
    //     hideShadow: true,
    //   ),
    //   body: SafeArea(
    //     child: Consumer<HistoryProvider>(
    //       builder: (context, provider, _) {
    //         return StreamBuilder<HistoryState>(
    //           stream: context.read<HistoryProvider>().fetchHistory(),
    //           builder: (context, state) {
    //             switch (state.data.runtimeType) {
    //               case HistoryLoading:
    //                 return const Center(child: CircularProgressIndicator());
    //               case HistoryFailure:
    //                 final failure = (state.data as HistoryFailure).failure;
    //                 showToast(message: failure);
    //                 return const SizedBox.shrink();
    //               case HistoryLoaded:
    //                 final _data = (state.data as HistoryLoaded).data;
    //                 if (_data.isEmpty) {
    //                   return Center(
    //                     child: Text(
    //                       appLoc.therearenopastorders,
    //                       style: formLabelHeaderStyle,
    //                     ),
    //                   );
    //                 }
    //                 return ListView.builder(
    //                   itemCount: _data.length,
    //                   physics: NeverScrollableScrollPhysics(),
    //                   itemBuilder: (context, index) {
    //                     return Padding(
    //                       padding: const EdgeInsets.all(10.0),
    //                       child: HistoryItem(data: _data[index]),
    //                     );
    //                   },
    //                 );
    //             }
    //             return const SizedBox.shrink();
    //           },
    //         );
    //       },
    //     ),
    //   ),
    // );
  }
}
