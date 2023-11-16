// import 'package:appkey_taxiapp_driver/features/chat/data/model/chat_model.dart';
// import 'package:flutter/cupertino.dart';

// class ChatProvider extends ChangeNotifier {
//   static final ChatProvider chatProvider = ChatProvider._internal();

//   factory ChatProvider() {
//     return chatProvider;
//   }

//   ChatProvider._internal();

//   final chatController = TextEditingController();

//   List<ChatModel> _chatMessagesList = [];

//   List<ChatModel> get chatMessageList => _chatMessagesList;

//   clearChatList() {
//     _chatMessagesList.clear();
//     _chatMessagesList = [];
//     notifyListeners();
//   }

//   addChatAll(List<ChatModel> list) {
//     _chatMessagesList = list;
//     notifyListeners();
//   }

//   addSingleChat(ChatModel chat) {
//     _chatMessagesList.insert(0, chat);
//     notifyListeners();
//   }
// }
