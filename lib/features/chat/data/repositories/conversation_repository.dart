// lib/repositories/conversation_repository.dart
import 'dart:async';

import 'package:e_health_system/features/chat/domain/entities/conversation.dart';
import 'package:e_health_system/features/chat/domain/entities/conversation_membership.dart';
import 'package:e_health_system/features/chat/domain/entities/message.dart';

/// A repository that simulates backend operations for fetching and sending conversations
/// using an in-memory data store.
class ConversationRepository {
  // In-memory data store mapping conversation IDs to Conversation objects.
  final Map<String, Conversation> _conversations = {};

  ConversationRepository() {
    // Initialize a sample conversation with pre-populated messages and memberships.
    final conversation = Conversation(
      conversationId: 'c1',
      messages: [
        Message(
          messageId: 'm1',
          messageText: 'Hello!',
          senderId: 'user2',
          conversationId: 'c1',
        ),
        Message(
          messageId: 'm2',
          messageText: 'Hi! How are you?',
          senderId: 'user1',
          conversationId: 'c1',
        ),
      ],
      conversationMemberships: [
        ConversationMembership(
          userId: 'user1',
          conversationId: 'c1',
        ),
        ConversationMembership(
          userId: 'user2',
          conversationId: 'c1',
        ),
      ],
    );

    // Store the sample conversation.
    _conversations[conversation.conversationId] = conversation;
  }

  /// Simulates fetching a conversation by its [conversationId].
  ///
  /// Returns a [Future] that completes with the matching [Conversation]
  /// after a simulated network delay.
  /// Throws an [Exception] if the conversation is not found.
  Future<Conversation> fetchConversation(String conversationId) async {
    await Future.delayed(
        const Duration(seconds: 1)); // Simulated network delay.
    if (_conversations.containsKey(conversationId)) {
      return _conversations[conversationId]!;
    } else {
      throw Exception("Conversation not found: $conversationId");
    }
  }

  /// Simulates sending a [message] by appending it to the corresponding conversation's message list.
  ///
  /// Returns a [Future] that completes after a simulated delay.
  /// Throws an [Exception] if the conversation is not found.
  Future<void> sendMessage(Message message) async {
    // Shorter delay for better responsiveness
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (_conversations.containsKey(message.conversationId)) {
      final conversation = _conversations[message.conversationId]!;
      final updatedMessages = List<Message>.from(conversation.messages)..add(message);
      _conversations[message.conversationId] = conversation.copyWith(messages: updatedMessages);
      
      // Print confirmation for debugging
      print('Message added to conversation ${message.conversationId}');
      print('Total messages now: ${_conversations[message.conversationId]!.messages.length}');
    } else {
      throw Exception("Conversation not found: ${message.conversationId}");
    }
  }

  Future<List<Conversation>> fetchConversations() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulated delay.
    return _conversations.values.toList();
  }

  Future<List<Conversation>> fetchConversationsForUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulated delay.
    // Filter conversations where the user is a member.
    return _conversations.values.where((conversation) {
      return conversation.conversationMemberships
          .any((membership) => membership.userId == userId);
    }).toList();
  }
}
