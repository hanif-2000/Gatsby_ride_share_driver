import 'package:appkey_taxiapp_driver/core/static/colors.dart';
import 'package:appkey_taxiapp_driver/core/static/styles.dart';
import 'package:appkey_taxiapp_driver/core/types/fonts.dart';
import 'package:appkey_taxiapp_driver/core/utility/helper.dart';
import 'package:appkey_taxiapp_driver/features/chat/presendtation/widget/receiver_tile.dart';
import 'package:appkey_taxiapp_driver/features/chat/presendtation/widget/sender_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({Key? key}) : super(key: key);
  static const routeName = '/ChatPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyEFEDED,
      body: Column(
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
                        icon: SvgPicture.asset('assets/icons/auth/ic_back.svg'),
                      ),
                      smallHorizontalSpacing(),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: redD03B3B,
                        ),
                      ),
                      mediumHorizontalSpacing(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Johan Green',
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    mediumVerticalSpacing(),
                    const SenderTile(
                      title: 'Hello, are you nearby?',
                    ),
                    const ReceiverTile(
                      title: 'I will be there in a few mins',
                    ),
                    const SenderTile(
                      title: 'Okay, I am waiting at my location',
                    ),
                    const ReceiverTile(
                      title:
                          'Sorry, I am stuck in traffic. Please give me a more time',
                    ),
                    const SenderTile(
                      title: 'Okay, I am waiting at my location',
                    ),
                    const ReceiverTile(
                      title:
                          'Sorry, I am stuck in traffic. Please give me a more time',
                    ),
                    const SenderTile(
                      title: 'Okay, I am waiting at my location',
                    ),
                    const ReceiverTile(
                      title:
                          'Sorry, I am stuck in traffic. Please give me a more time',
                    ),
                  ],
                ),
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
                SvgPicture.asset('assets/icons/home/ic_send.svg'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
