import 'package:e_health_system/features/chat/data/repositories/conversation_repository.dart';
import 'package:e_health_system/features/chat/domain/entities/conversation.dart';
import 'package:e_health_system/features/chat/domain/entities/conversation_membership.dart';
import 'package:e_health_system/features/chat/presentation/blocs/conversation_bloc.dart';
import 'package:e_health_system/features/chat/presentation/blocs/conversation_event.dart';
import 'package:e_health_system/features/chat/presentation/blocs/conversation_state.dart';
import 'package:e_health_system/features/chat/presentation/utils/chat_list_refresh_notifier.dart';
import 'package:flutter/material.dart';
import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:e_health_system/models/user.dart';
import 'package:e_health_system/shared/enums/gender.dart';
import 'package:e_health_system/shared/enums/role.dart';
// Adjust import as needed

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late ConversationBloc _conversationBloc;

  // Mock data for contacts
  final List<User> _contacts = [
    User(
      userId: 'doctor1',
      firstName: 'Dr. Sarah',
      lastName: 'Johnson',
      email: 'sarah.johnson@example.com',
      isEmailVerified: true,
      phone: '+1234567890',
      gender: Gender.Female,
      dateOfBirth: DateTime(1980, 5, 15),
      address: '123 Medical Center Blvd',
      role: Role.Doctor,
      profilePicture: 'assets/images/doctor1.jpg',
    ),
    User(
      userId: 'doctor2',
      firstName: 'Dr. Michael',
      lastName: 'Chen',
      email: 'michael.chen@example.com',
      isEmailVerified: true,
      phone: '+1987654321',
      gender: Gender.Male,
      dateOfBirth: DateTime(1975, 8, 22),
      address: '456 Health Clinic Ave',
      role: Role.Doctor,
      profilePicture: 'assets/images/doctor2.jpg',
    ),
    User(
      userId: 'nurse1',
      firstName: 'Emma',
      lastName: 'Williams',
      email: 'emma.williams@example.com',
      isEmailVerified: true,
      phone: '+1567890123',
      gender: Gender.Female,
      dateOfBirth: DateTime(1990, 3, 10),
      address: '789 Care Center St',
      role: Role.Doctor,
      profilePicture: 'assets/images/nurse1.jpg',
    ),
    User(
      userId: 'patient1',
      firstName: 'James',
      lastName: 'Smith',
      email: 'james.smith@example.com',
      isEmailVerified: true,
      phone: '+1678901234',
      gender: Gender.Male,
      dateOfBirth: DateTime(1985, 11, 28),
      address: '321 Patient Ln',
      role: Role.Patient,
      profilePicture: 'assets/images/patient1.jpg',
    ),
    User(
      userId: 'patient2',
      firstName: 'Sophia',
      lastName: 'Garcia',
      email: 'sophia.garcia@example.com',
      isEmailVerified: true,
      phone: '+1890123456',
      gender: Gender.Female,
      dateOfBirth: DateTime(1992, 7, 14),
      address: '654 Health Seeker Rd',
      role: Role.Patient,
      profilePicture: 'assets/images/patient2.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _conversationBloc = ConversationBloc(
      repository: RepositoryProvider.of<ConversationRepository>(context),
    );
    _loadConversations();
    
    // Subscribe to refresh notifications
    ChatListRefreshNotifier().refreshNotifier.addListener(_onRefreshNotified);
  }

  void _onRefreshNotified() {
    print('Refresh notification received, reloading conversations');
    _loadConversations();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    ChatListRefreshNotifier().refreshNotifier.removeListener(_onRefreshNotified);
    _conversationBloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadConversations();
    }
  }

  void _loadConversations() {
    print('Loading conversations');
    _conversationBloc.add(const LoadConversationsForUser("user1"));
  }

  /// Returns the display name for the conversation.
  /// Assumes the current user has id "user1" and picks the other member's name.
  String _getChatName(Conversation conversation) {
    const currentUserId = "user1";
    // If a membership has a non-null user with a 'name', select the other person.
    ConversationMembership? otherMember =
        conversation.conversationMemberships.firstWhere(
      (membership) =>
          membership.user != null && membership.user!.userId != currentUserId,
      orElse: () => conversation.conversationMemberships.first,
    );
    return otherMember.user?.firstName ?? "Unknown";
  }

  /// Returns the last message text if available.
  String _getLastMessage(Conversation conversation) {
    if (conversation.messages.isNotEmpty) {
      return conversation.messages.last.messageText ?? "";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    // Add a focus listener to refresh data when returning to this screen
    return Focus(
      onFocusChange: (hasFocus) {
        if (hasFocus) {
          print('Chat screen got focus, refreshing conversations');
          _loadConversations();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          width: double.infinity,
          color: AppColors.background,
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 12),
              Expanded(
                child: BlocProvider.value(
                  value: _conversationBloc,
                  child: BlocBuilder<ConversationBloc, ConversationState>(
                    builder: (context, state) {
                      print('Current state: ${state.runtimeType}');
                      if (state is ConversationLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ConversationError) {
                        return Center(child: Text("Error: ${state.error}"));
                      } else if (state is ConversationsLoaded) {
                        final conversations = state.conversations;
                        if (conversations.isEmpty) {
                          return const Center(child: Text("No chats available"));
                        }
                        return ListView.separated(
                          itemCount: conversations.length,
                          separatorBuilder: (context, index) => const Divider(
                            height: 2,
                            color: Colors.grey,
                          ),
                          itemBuilder: (context, index) {
                            final conversation = conversations[index];
                            final chatName = _getChatName(conversation);
                            final lastMessage = _getLastMessage(conversation);
                            // For demo purposes: mark it unread if last message sender is not "user1"
                            final unread = conversation.messages.isNotEmpty &&
                                conversation.messages.last.senderId != "user1";
                            return _buildChatListItem(
                              chatName: chatName,
                              lastMessage: lastMessage,
                              unread: unread,
                              conversationId: conversation.conversationId,
                              context: context,
                            );
                          },
                        );
                      }
                      return const Center(child: Text("No conversations found"));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  /// Builds the search bar.
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search Patients...",
          prefixIcon: Icon(Icons.search, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  /// Builds each individual chat list item.
  Widget _buildChatListItem({
    required String chatName,
    required String lastMessage,
    required bool unread,
    required String conversationId,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.primary.withOpacity(0.2),
          child: Text(
            chatName.isNotEmpty ? chatName[0] : "?",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        title: Text(
          chatName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          lastMessage,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            unread
                ? Container(
                    width: 12.5,
                    height: 12.5,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        onTap: () {
          // Navigate to a conversation page. Adjust navigation as needed.
          context.push('/conversation/$conversationId');
        },
      ),
    );
  }

  /// Builds the Floating Action Button for starting a new chat.
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: () {
        _showContactsBottomSheet(context);
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  /// Shows the contacts bottom sheet
  void _showContactsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 5),
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      'Contacts',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    // Search icon
                    IconButton(
                      icon: const Icon(Icons.search, color: AppColors.primary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              // Search field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search contacts...",
                      prefixIcon: Icon(Icons.search, color: AppColors.primary),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
              // Filter tabs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip('All', true),
                    const SizedBox(width: 10),
                    _buildFilterChip('Doctors', false),
                    const SizedBox(width: 10),
                    _buildFilterChip('Patients', false),
                  ],
                ),
              ),
              // Contacts list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    return _buildContactItem(contact);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContactItem(User contact) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: AppColors.primary.withOpacity(0.2),
        backgroundImage: contact.profilePicture != null
            ? AssetImage(contact.profilePicture!)
            : null,
        child: contact.profilePicture == null
            ? Text(
                "${contact.firstName[0]}${contact.lastName[0]}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              )
            : null,
      ),
      title: Text(
        "${contact.firstName} ${contact.lastName}",
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        contact.role.toString().split('.').last,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: ElevatedButton(
        onPressed: () {
          // Start a conversation with this contact
          Navigator.pop(context);
          // Here you would typically create a new conversation or navigate to an existing one
          // For demo purposes, we'll just navigate back
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text('Message'),
      ),
      onTap: () {
        // Navigate to contact details or start a chat
      },
    );
  }
}
