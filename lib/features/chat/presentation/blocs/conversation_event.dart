// lib/blocs/conversation_event.dart
import 'package:e_health_system/features/chat/domain/entities/message.dart';
import 'package:equatable/equatable.dart';

abstract class ConversationEvent extends Equatable {
  const ConversationEvent();

  @override
  List<Object?> get props => [];
}

// Event to load a conversation by its ID.
class LoadConversation extends ConversationEvent {
  final String conversationId;
  const LoadConversation(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

// Event to send a new message.
class SendMessageEvent extends ConversationEvent {
  final Message message;
  const SendMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class LoadConversationsForUser extends ConversationEvent {
  final String userId;
  const LoadConversationsForUser(this.userId);

  @override
  List<Object?> get props => [userId];
}
