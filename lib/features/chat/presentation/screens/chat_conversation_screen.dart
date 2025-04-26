import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ChatConversationScreen extends StatelessWidget {
  const ChatConversationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App Bar with Patient Name and Call, Video, Options icons.
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        titleSpacing: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(
            "Patient Name",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, size: 28, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon:
            const Icon(Icons.videocam, size: 28, color: Colors.black87),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, size: 28, color: Colors.black87),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Expanded list of chat messages (scrollable).
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                // Optional Date Separator
                Center(
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Today 3:00 PM",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // "You" message (right aligned)
                _buildMyMessage("You: Hello, how are you feeling today?"),
                const SizedBox(height: 24),
                // "Patient" message (left aligned, with avatar)
                _buildPatientMessage("(🧑) I'm feeling better, doctor."),
                const SizedBox(height: 24),
                // Another "You" message.
                _buildMyMessage("You: Good to hear! Please take your meds."),
              ],
            ),
          ),
          // Message Input Bar
          _buildInputBar(),
        ],
      ),
    );
  }

  /// Builds a chat bubble for messages sent by "You" (right aligned).
  Widget _buildMyMessage(String message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.only(left: 60),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a chat bubble for messages sent by the patient (left aligned with avatar).
  Widget _buildPatientMessage(String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar for patient
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.shade200,
          child: const Text(
            "P", // This can be the patient's initial(s)
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: const EdgeInsets.only(right: 60),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds the message input area at the bottom.
  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Emoji button
          Icon(
            Icons.emoji_emotions,
            size: 32,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          // Expanded text field
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Attachment icon
          Icon(
            Icons.attach_file,
            size: 32,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 12),
          // Microphone icon
          Icon(
            Icons.mic,
            size: 32,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}
