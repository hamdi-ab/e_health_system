import 'package:e_health_system/features/chat/presentation/screens/chat_conversation_screen.dart';
import 'package:flutter/material.dart';
import 'package:e_health_system/core/constants/app_colors.dart'; // Adjust import as needed

class ChatScreen extends StatelessWidget {
   ChatScreen({super.key});

  // Dummy chat data to simulate recent chats.
  final List<Map<String, dynamic>> _chats = const [
    {
      "name": "John Doe",
      "lastMessage": "Hey, how are you?",
      "timestamp": "09:30 AM",
      "unread": true,
    },
    {
      "name": "Mary Smith",
      "lastMessage": "Let's meet tomorrow.",
      "timestamp": "08:15 AM",
      "unread": false,
    },
    {
      "name": "David Lee",
      "lastMessage": "I sent you the files.",
      "timestamp": "Yesterday",
      "unread": true,
    },
    {
      "name": "Alice Brown",
      "lastMessage": "Thanks a lot!",
      "timestamp": "Yesterday",
      "unread": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
     // appBar: _buildAppBar(),
      body: Container(
        // Increased container dimensions and padding to give a larger feel.
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        width: double.infinity,
        // Use the same background color from your overall theme.
        color: AppColors.background,
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 12),
            Expanded(child: _buildChatList(context)),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }


  /// Builds the search bar with a magnifying glass icon and matching theming.
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

  /// Builds the chat list using a ListView with custom chat items.
  Widget _buildChatList(BuildContext context) {
    return ListView.separated(
      itemCount: _chats.length,
      separatorBuilder: (context, index) => const Divider(
        height: 2,
        color: Colors.grey,
      ),
      itemBuilder: (context, index) =>
          _buildChatListItem(chat: _chats[index], context: context),
    );
  }

  /// Builds each individual chat item.
  Widget _buildChatListItem({required Map<String, dynamic> chat , required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: AppColors.primary.withOpacity(0.2),
          child: Text(
            chat["name"][0],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
        title: Text(
          chat["name"],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          chat["lastMessage"],
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              chat["timestamp"],
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 10),
            chat["unread"]
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
          // TODO: Navigate to chat details, if required.
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatConversationScreen()));
        },
      ),
    );
  }

  /// Builds the Floating Action Button to start a new chat.
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.primary,
      onPressed: () {
        // TODO: Handle new chat creation.
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
