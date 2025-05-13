// File: lib/models/message.dart


import '../../../../models/file_model.dart';
import '../../../../models/user.dart';
import 'conversation.dart';

class Message {
  final String messageId;
  final String? messageText;
  final List<FileModel>? files;
  final String senderId;
  final User? sender;
  final String conversationId;
  final Conversation? conversation;

  Message({
    required this.messageId,
    this.messageText,
    this.files,
    required this.senderId,
    this.sender,
    required this.conversationId,
    this.conversation,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'] as String,
      messageText: json['messageText'] as String?,
      files: json['files'] != null
          ? (json['files'] as List)
          .map((item) =>
          FileModel.fromJson(item as Map<String, dynamic>))
          .toList()
          : null,
      senderId: json['senderId'] as String,
      sender: json['sender'] != null
          ? User.fromJson(json['sender'] as Map<String, dynamic>)
          : null,
      conversationId: json['conversationId'] as String,
      conversation: json['conversation'] != null
          ? Conversation.fromJson(json['conversation'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'messageText': messageText,
      'files': files?.map((file) => file.toJson()).toList(),
      'senderId': senderId,
      'sender': sender?.toJson(),
      'conversationId': conversationId,
      'conversation': conversation?.toJson(),
    };
  }
}
