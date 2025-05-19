// File: lib/models/conversation.dart

import 'conversation_membership.dart';
import 'message.dart';

class Conversation {
  final String conversationId;
  final List<Message> messages;
  final List<ConversationMembership> conversationMemberships;

  Conversation({
    required this.conversationId,
    List<Message>? messages,
    List<ConversationMembership>? conversationMemberships,
  })  : messages = messages ?? [],
        conversationMemberships = conversationMemberships ?? [];

  // Add copyWith method here
  Conversation copyWith({
    String? conversationId,
    List<Message>? messages,
    List<ConversationMembership>? conversationMemberships,
  }) {
    return Conversation(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      conversationMemberships:
          conversationMemberships ?? this.conversationMemberships,
    );
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversationId: json['conversationId'] as String,
      messages: json['messages'] != null
          ? (json['messages'] as List)
              .map((item) => Message.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
      conversationMemberships: json['conversationMemberships'] != null
          ? (json['conversationMemberships'] as List)
              .map((item) =>
                  ConversationMembership.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversationId': conversationId,
      'messages': messages.map((item) => item.toJson()).toList(),
      'conversationMemberships':
          conversationMemberships.map((item) => item.toJson()).toList(),
    };
  }
}
