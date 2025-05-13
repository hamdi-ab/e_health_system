// File: lib/models/conversation_membership.dart

import '../../../../models/user.dart';
import 'conversation.dart';

class ConversationMembership {
  final String userId;
  final User? user;
  final String conversationId;
  final Conversation? conversation;

  ConversationMembership({
    required this.userId,
    this.user,
    required this.conversationId,
    this.conversation,
  });

  factory ConversationMembership.fromJson(Map<String, dynamic> json) {
    return ConversationMembership(
      userId: json['userId'] as String,
      user: json['user'] != null ? User.fromJson(json['user'] as Map<String, dynamic>) : null,
      conversationId: json['conversationId'] as String,
      conversation: json['conversation'] != null
          ? Conversation.fromJson(json['conversation'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'user': user?.toJson(),
      'conversationId': conversationId,
      'conversation': conversation?.toJson(),
    };
  }
}
