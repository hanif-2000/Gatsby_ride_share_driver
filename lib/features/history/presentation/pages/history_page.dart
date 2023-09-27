import 'package:appkey_taxiapp_driver/core/presentation/widgets/custom_app_title_bar.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
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
    // return Consumer<HistoryProvider>(
    //   builder: (context, provider, _) {
    //     return StreamBuilder<HistoryState>(
    //       stream: context.read<HistoryProvider>().fetchHistory(),
    //       builder: (context, state) {
    //         logMe('Fetch history builder Data loaded ---> ');
    //         switch (state.data.runtimeType) {
    //           case HistoryLoading:
    //             return const Center(child: CircularProgressIndicator());
    //           case HistoryFailure:
    //             final failure = (state.data as HistoryFailure).failure;
    //             showToast(message: failure);
    //             return const SizedBox.shrink();
    //           case HistoryLoaded:
    //             final _data = (state.data as HistoryLoaded).data;
    //             logMe('Data loaded ---> ${_data.length}');
    //             if (_data.isEmpty) {
    //               return Center(
    //                 child: Text(
    //                   appLoc.therearenopastorders,
    //                   style: formLabelHeaderStyle,
    //                 ),
    //               );
    //             }
    //             return Column(
    //               children: List.generate(
    //                 _data.length,
    //                 (index) => Padding(
    //                   padding: const EdgeInsets.all(10.0),
    //                   child: HistoryItem(data: _data[index]),
    //                 ),
    //               ),
    //             );
    //
    //             return ListView.builder(
    //               itemCount: _data.length,
    //               physics: const NeverScrollableScrollPhysics(),
    //               itemBuilder: (context, index) {
    //                 return Padding(
    //                   padding: const EdgeInsets.all(10.0),
    //                   child: HistoryItem(data: _data[index]),
    //                 );
    //               },
    //             );
    //         }
    //         return const SizedBox.shrink();
    //       },
    //     );
    //   },
    // );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: greyColor,
      appBar: CustomAppTtitleBar(
        centerTitle: true,
        canBack: true,
        title: appLoc.history.toUpperCase(),
        hideShadow: true,
      ),
      body: SafeArea(
        child: Consumer<HistoryProvider>(
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
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          // child: HistoryItem(data: _data[index]),
                          child: Text(_data[index].userName!),
                        );
                      },
                    );
                }
                return const SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
