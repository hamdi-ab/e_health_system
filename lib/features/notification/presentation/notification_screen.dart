import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final bool isDoctor;
  const NotificationScreen({super.key, required this.isDoctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Header with a back arrow and "Mark all as read"
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Appointments"),
            _buildAppointmentsSection(context),
            const SizedBox(height: 16),
            _buildSectionTitle("Messages"),
            _buildMessagesSection(context),
            const SizedBox(height: 16),
            _buildSectionTitle("Blog & Social"),
            _buildBlogSocialSection(context),
            const SizedBox(height: 16),
            _buildSectionTitle("Payments"),
            _buildPaymentsSection(context),
            const SizedBox(height: 16),
            _buildSectionTitle("System"),
            _buildSystemSection(context),
          ],
        ),
      ),
    );
  }

  // AppBar that shows a back arrow and "Mark all as read" action.
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        "Notifications",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Replace with your mark-all-as-read logic
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("All notifications marked as read")),
            );
          },
          child: const Text(
            "Mark all as read",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  // Generic Notification Card Builder.
  Widget _buildNotificationCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String message,
    required String time,
    required List<Widget> actions,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Icon, title/message and time stamp.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 28),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(message, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                Text(time,
                    style:
                    const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            // Actions Row (right aligned)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }

  // Appointments Section
  Widget _buildAppointmentsSection(BuildContext context) {
    return Column(
      children: [
        // New Booking Notification
        _buildNotificationCard(
          context: context,
          icon: Icons.calendar_today,
          title: "New Booking",
          message: isDoctor
              ? "2 new requests pending approval."
              : "Your booking request is pending approval.",
          time: "5 min ago",
          actions: isDoctor
              ? [
            TextButton(
              onPressed: () {
                // View Queue for doctor
              },
              child: const Text("View Queue"),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                // Decline All for doctor
              },
              child: const Text("Decline All"),
            ),
          ]
              : [
            TextButton(
              onPressed: () {
                // Patient view: View Details action
              },
              child: const Text("View Details"),
            ),
          ],
        ),
        // Patient Check-In Notification
        _buildNotificationCard(
          context: context,
          icon: Icons.check_circle,
          title: "Patient Check-In",
          message: isDoctor
              ? "Abel has checked in for 9:00 AM."
              : "You have successfully checked in for your appointment.",
          time: "10 min ago",
          actions: isDoctor
              ? [
            TextButton(
              onPressed: () {
                // Doctor: View Patient action
              },
              child: const Text("View Patient"),
            ),
          ]
              : [
            TextButton(
              onPressed: () {
                // Patient: View Appointment action
              },
              child: const Text("View Appointment"),
            ),
          ],
        ),
      ],
    );
  }

  // Messages Section remains the same.
  Widget _buildMessagesSection(BuildContext context) {
    return _buildNotificationCard(
      context: context,
      icon: Icons.chat,
      title: "Chat Message",
      message: "New message from Yonas.",
      time: "1 hr ago",
      actions: [
        TextButton(
          onPressed: () {
            // TODO: Reply action.
          },
          child: const Text("Reply"),
        ),
      ],
    );
  }

  // Blog & Social Section with conditional text for doctor vs patient.
  Widget _buildBlogSocialSection(BuildContext context) {
    return _buildNotificationCard(
      context: context,
      icon: Icons.comment, // Using a comment icon
      title: isDoctor ? "Comment" : "Comment Reaction",
      message: isDoctor
          ? "Selam commented on your blog."
          : "Your comment was liked by Selam.",
      time: "Yesterday",
      actions: [
        TextButton(
          onPressed: () {
            // For doctor: View Blog, for patient: View Comment
          },
          child: Text(isDoctor ? "View Blog" : "View Comment"),
        ),
      ],
    );
  }

  // Payments Section with conditional content.
  Widget _buildPaymentsSection(BuildContext context) {
    return _buildNotificationCard(
      context: context,
      icon: Icons.credit_card,
      title: isDoctor ? "Payment Received" : "Payment Made",
      message: isDoctor
          ? "500 ETB received for April 29."
          : "500 ETB paid on April 29.",
      time: "Apr 29, 2025",
      actions: [
        TextButton(
          onPressed: () {
            // TODO: View History action.
          },
          child: const Text("View History"),
        ),
      ],
    );
  }

  // System Section remains unchanged.
  Widget _buildSystemSection(BuildContext context) {
    return _buildNotificationCard(
      context: context,
      icon: Icons.settings,
      title: "Maintenance",
      message: "Scheduled tonight at 12:00 AM.",
      time: "2 days ago",
      actions: [
        TextButton(
          onPressed: () {
            // TODO: Details action.
          },
          child: const Text("Details"),
        ),
      ],
    );
  }
}
