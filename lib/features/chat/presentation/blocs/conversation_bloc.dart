// lib/blocs/conversation_bloc.dart
import 'package:e_health_system/features/chat/data/repositories/conversation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'conversation_event.dart';
import 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  final ConversationRepository repository;

  ConversationBloc({required this.repository}) : super(ConversationInitial()) {
    on<LoadConversation>(_onLoadConversation);
    on<SendMessageEvent>(_onSendMessage);
    on<LoadConversationsForUser>(_onLoadConversationsForUser);
  }

  Future<void> _onLoadConversation(
      LoadConversation event, Emitter<ConversationState> emit) async {
    emit(ConversationLoading());
    try {
      final conversation =
          await repository.fetchConversation(event.conversationId);
      emit(ConversationLoaded(conversation: conversation));
    } catch (e) {
      emit(ConversationError(error: e.toString()));
    }
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ConversationState> emit) async {
    if (state is ConversationLoaded) {
      final currentState = state as ConversationLoaded;
      try {
        // Create new messages list with the added message
        final newMessages = List.of(currentState.conversation.messages)
          ..add(event.message);

        // Create a new conversation instance with updated messages
        final updatedConversation = currentState.conversation.copyWith(
          messages: newMessages,
        );

        // Immediately emit updated state for optimistic UI update
        emit(ConversationLoaded(conversation: updatedConversation));

        // Send message to repository
        await repository.sendMessage(event.message);
      } catch (e) {
        // On error, revert to previous state and show error
        emit(ConversationError(error: 'Message send failed: ${e.toString()}'));
        emit(currentState);
      }
    }
  }

  Future<void> _onLoadConversationsForUser(
      LoadConversationsForUser event, Emitter<ConversationState> emit) async {
    emit(ConversationLoading());
    try {
      final conversations =
          await repository.fetchConversationsForUser(event.userId);
      emit(ConversationsLoaded(conversations: conversations));
    } catch (e) {
      emit(ConversationError(error: e.toString()));
    }
  }
}
