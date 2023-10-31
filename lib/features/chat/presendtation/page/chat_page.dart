import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/presentation/providers/socket_provider.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/button_order.dart';
import 'package:appkey_taxiapp_driver/core/presentation/widgets/cache_network_widget.dart';
import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/core/utility/injection.dart';
import 'package:appkey_taxiapp_driver/core/utility/session_helper.dart';
import 'package:appkey_taxiapp_driver/features/chat/presendtation/widget/receiver_tile.dart';
import 'package:appkey_taxiapp_driver/features/chat/presendtation/widget/sender_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, this.chatDetail}) : super(key: key);
  final ChatDetail? chatDetail;
  static const routeName = '/ChatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  var socketProvider = locator<SocketProvider>();
  // var chatProvider = locator<ChatProvider>();
  var sessionProvider = locator<Session>();

  @override
  void initState() {
    super.initState();
    socketProvider.joinExitRoom(receiverId: widget.chatDetail!.userId);
    WidgetsBinding.instance.addObserver(this);
    socketProvider.markMessageAsRead(receiverId: widget.chatDetail!.userId);
    // socketProvider.listenRequests();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log(" app lifecycle state is ------>>>>>>>   $state");
    if (state == AppLifecycleState.paused) {
      socketProvider.joinExitRoom(
          receiverId: widget.chatDetail!.userId, type: 'unJoin');
    } else if (state == AppLifecycleState.resumed) {
      socketProvider.joinExitRoom(receiverId: widget.chatDetail!.userId);
    }
  }

  @override
  void dispose() {
    socketProvider.getTotalUnreadCount(widget.chatDetail!.userId);
    super.dispose();
    Future.delayed(const Duration(seconds: 1), () {
      // socketProvider.clearChatList();
      socketProvider.joinExitRoom(
          receiverId: widget.chatDetail!.userId, type: 'unJoin');

      WidgetsBinding.instance.removeObserver(this);

      socketProvider.disconnectSocket();
      socketProvider.connectToSocket();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyEFEDED,
      body: Consumer<SocketProvider>(builder: (context, provider, _) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: SvgPicture.asset(
                            'assets/icons/auth/ic_back.svg',
                          ),
                        ),
                        smallHorizontalSpacing(),

                        CustomCacheNetworkImage(
                            img: widget.chatDetail!.userPhoto!, size: 50),
                        // Container(
                        //   height: 50,
                        //   width: 50,
                        //   decoration: BoxDecoration(
                        //     shape: BoxShape.circle,
                        //     color: redD03B3B,
                        //     image: DecorationImage(
                        //         image: NetworkImage(
                        //           '$BASE_URL${widget.chatDetail!.userPhoto}',
                        //         ),
                        //         fit: BoxFit.cover),
                        //   ),
                        // ),
                        mediumHorizontalSpacing(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.chatDetail!.userName}',
                              textAlign: TextAlign.center,
                              style: titleStyle
                                  .copyWith(
                                    fontSize: 16,
                                  )
                                  .usePoppinsW5Font(),
                            ),
                            // Text(
                            //   'Active now',
                            //   textAlign: TextAlign.center,
                            //   style: titleStyle
                            //       .copyWith(fontSize: 12, color: greyB6B6B6)
                            //       .usePoppinsW4Font(),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: provider.chatMessageList.isEmpty
                      ? const Center(
                          child: Text('No messages'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: provider.chatMessageList.length,
                          itemBuilder: (context, index) {
                            return provider.chatMessageList[index].senderType ==
                                    'Customer'
                                ? ReceiverTile(
                                    title:
                                        provider.chatMessageList[index].message,
                                  )
                                : SenderTile(
                                    title:
                                        provider.chatMessageList[index].message,
                                  );
                          },
                        ),
                  // child: Column(
                  //   children: [
                  //     mediumVerticalSpacing(),
                  //     const SenderTile(
                  //       title: 'Hello, are you nearby?',
                  //     ),
                  //     const ReceiverTile(
                  //       title: 'I will be there in a few mins',
                  //     ),
                  //     const SenderTile(
                  //       title: 'Okay, I am waiting at my location',
                  //     ),
                  //     const ReceiverTile(
                  //       title:
                  //           'Sorry, I am stuck in traffic. Please give me a more time',
                  //     ),
                  //     const SenderTile(
                  //       title: 'Okay, I am waiting at my location',
                  //     ),
                  //     const ReceiverTile(
                  //       title:
                  //           'Sorry, I am stuck in traffic. Please give me a more time',
                  //     ),
                  //     const SenderTile(
                  //       title: 'Okay, I am waiting at my location',
                  //     ),
                  //     const ReceiverTile(
                  //       title:
                  //           'Sorry, I am stuck in traffic. Please give me a more time',
                  //     ),
                  //   ],
                  // ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: provider.chatController,
                      decoration: InputDecoration(
                        hintText: 'Enter message...',
                        hintStyle: titleStyle
                            .copyWith(
                              fontSize: 14,
                              color: blackColor,
                            )
                            .usePoppinsW4Font(),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (provider.chatController.text.trim() == '') {
                        showToast(message: "Please Enter your message");
                      } else {
                        socketProvider.sendChatMessage(
                            message: provider.chatController.text.trim(),
                            receiverId: widget.chatDetail!.userId);
                        provider.chatController.text = '';
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        'assets/icons/home/ic_send.svg',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
