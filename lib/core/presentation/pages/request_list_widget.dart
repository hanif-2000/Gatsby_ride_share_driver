import 'package:appkey_taxiapp_driver/core/presentation/providers/home_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/providers/request_list_state.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/request_tile.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestListWidget extends StatelessWidget {
  const RequestListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, _) {
        return StreamBuilder<RequestListState>(
          stream: context.read<HomeProvider>().getRequestListData(),
          builder: (context, state) {
            switch (state.data.runtimeType) {
              case RequestListLoading:
                return const Center(child: CircularProgressIndicator());
              case RequestListFailure:
                final failure = (state.data as RequestListFailure).failure;
                showToast(message: failure.message);
                return const SizedBox.shrink();
              case RequestListLoaded:
                final _data = (state.data as RequestListLoaded).data;
                return Column(
                  children: List.generate(
                    _data.length,
                    (index) => RequestTile(
                      request: _data[index],
                    ),
                  ),
                );
            }
            return const SizedBox.shrink();
          },
          // builder: (context, state) {
          //   if (state is RequestListLoaded) {
          //     return const Center(
          //         child: CircularProgressIndicator(
          //       color: primaryColor,
          //     ));
          //   } else if (state is RequestListLoaded) {
          //     return Column(
          //       children: const [
          //         RequestTile(),
          //         RequestTile(),
          //         RequestTile(),
          //         RequestTile(),
          //       ],
          //     );
          //   } else {
          //     return Column(
          //       children: const [
          //         RequestTile(),
          //         RequestTile(),
          //         RequestTile(),
          //         RequestTile(),
          //       ],
          //     );
          //   }
          // },
        );
      },
    );
  }
}
