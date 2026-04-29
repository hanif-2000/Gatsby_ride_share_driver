import 'dart:developer';

import 'package:appkey_taxiapp_driver/core/presentation/providers/latest_socket_provider.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, this.chatDetail});
  final ChatDetail? chatDetail;
  static const routeName = '/ChatPage';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
 late LatestSocketProvider socketProvider;
  var sessionProvider = locator<Session>();

  @override
  void initState() {
    super.initState();
     socketProvider = context.read<LatestSocketProvider>();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      socketProvider.joinExitRoom(receiverId: widget.chatDetail!.userId, type: 'Join');
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    log("didChangeAppLifecycleState  >>>>>>>>>>>------->>>>>>>>>>>>>>   $state");
    if(context.mounted){
    //  final socketProvider = context.read<LatestSocketProvider>();
      if (state == AppLifecycleState.paused) {
        socketProvider.joinExitRoom(receiverId: widget.chatDetail!.userId, type: 'unJoin');
      } else if (state == AppLifecycleState.resumed) {
        socketProvider.joinExitRoom(receiverId: widget.chatDetail!.userId, type: "Join");
      }
    }
  }

  @override
  void dispose() {
   // final socketProvider = context.read<LatestSocketProvider>();
    socketProvider.joinExitRoom(receiverId: widget.chatDetail!.userId, type: 'unJoin');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: greyEFEDED,
        body: Consumer<LatestSocketProvider>(builder: (context, latestSocketProvider, _) {
          final socketProvider = context.read<LatestSocketProvider>();
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
                              Text(
                                'Active now',
                                textAlign: TextAlign.center,
                                style: titleStyle
                                    .copyWith(fontSize: 12, color: greyB6B6B6)
                                    .usePoppinsW4Font(),
                              ),
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
                    child: Visibility(
                      visible: socketProvider.isLoading == false,
                      replacement: const Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CupertinoActivityIndicator(
                            color: black15141FColor,
                          ),
                        ),
                      ),
                      child: socketProvider.chatMessageList.isEmpty
                          ? Center(
                              child: Lottie.asset(
                                  'assets/lottie_animation/chat_empty_animation.json'))
                          // ? const Text('No messages')
                          // )
                          : ListView.builder(
                              reverse: true,
                              itemCount: socketProvider.chatMessageList.length,
                              itemBuilder: (context, index) {
                                final msg = socketProvider.chatMessageList[index];
                                final customerUserId = widget.chatDetail!.userId.toString();
final isCustomer =
                                    msg.senderType?.toLowerCase() == 'customer' ||
                                    msg.sourceUserId == customerUserId;
                                return isCustomer
                                    ? ReceiverTile(title: msg.message)
                                    : SenderTile(title: msg.message);
                              },
                            ),
                    ),
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: socketProvider.chatController,
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
                        if (socketProvider.chatController.text.trim() == '') {
                          showToast(message: "Please Enter your message");
                        } else {
                          final socketProvider = context.read<LatestSocketProvider>();
                          socketProvider.sendChatMessage(
                              message: socketProvider.chatController.text.trim(),
                              receiverId: widget.chatDetail!.userId);
                          socketProvider.chatController.text = '';
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
      ),
    );
  }
}
