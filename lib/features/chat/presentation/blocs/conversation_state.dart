// lib/blocs/conversation_state.dart
import 'package:e_health_system/features/chat/domain/entities/conversation.dart';
import 'package:equatable/equatable.dart';

abstract class ConversationState extends Equatable {
  const ConversationState();

  @override
  List<Object?> get props => [];
}

class ConversationInitial extends ConversationState {}

class ConversationLoading extends ConversationState {}

class ConversationLoaded extends ConversationState {
  final Conversation conversation;
  const ConversationLoaded({required this.conversation});

  @override
  List<Object?> get props => [conversation];
}

class ConversationError extends ConversationState {
  final String error;
  const ConversationError({required this.error});

  @override
  List<Object?> get props => [error];
}

class ConversationsLoaded extends ConversationState {
  final List<Conversation> conversations;
  const ConversationsLoaded({required this.conversations});

  @override
  List<Object?> get props => [conversations];
}
