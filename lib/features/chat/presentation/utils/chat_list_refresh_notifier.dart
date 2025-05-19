import 'package:flutter/foundation.dart';

class ChatListRefreshNotifier {
  static final ChatListRefreshNotifier _instance = ChatListRefreshNotifier._internal();
  
  factory ChatListRefreshNotifier() {
    return _instance;
  }

  ChatListRefreshNotifier._internal();

  final ValueNotifier<void> refreshNotifier = ValueNotifier<void>(null);

  void notifyRefresh() {
    refreshNotifier.value = null;
  }
} 