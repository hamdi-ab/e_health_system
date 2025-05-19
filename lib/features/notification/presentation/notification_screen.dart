import 'package:e_health_system/features/notification/domain/repositories/notification_repository.dart';
import 'package:e_health_system/features/notification/domain/entities/notification.dart'
    as notic;
import 'package:e_health_system/shared/enums/notification_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/notification_bloc.dart';
import 'bloc/notification_event.dart';
import 'bloc/notification_state.dart';

class NotificationScreen extends StatelessWidget {
  final bool isDoctor;
  final String userId;

  const NotificationScreen({
    super.key,
    required this.isDoctor,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repository = context.read<NotificationRepository>();
        return NotificationBloc(repository: repository)
          ..add(LoadNotifications(userId: userId));
      },
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<NotificationBloc>().add(
                          LoadNotifications(userId: userId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is NotificationsLoaded) {
              return _buildNotificationList(context, state);
            }

            return const Center(child: Text('No notifications'));
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        "Notifications",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationsLoaded && state.unreadCount > 0) {
              return TextButton(
                onPressed: () {
                  context.read<NotificationBloc>().add(
                        MarkAllNotificationsAsRead(userId: userId),
                      );
                },
                child: const Text(
                  "Mark all as read",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildNotificationList(
      BuildContext context, NotificationsLoaded state) {
    if (state.notifications.isEmpty) {
      return const Center(child: Text('No notifications yet'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.notifications.length,
      itemBuilder: (context, index) {
        final notification = state.notifications[index];
        return _buildNotificationCard(context, notification);
      },
    );
  }

  Widget _buildNotificationCard(
      BuildContext context, notic.Notification notification) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: _getNotificationIcon(notification.notificationType),
        title: Text(
          notification.message,
          style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Text(_getTimeAgo(notification.timestamp)),
        trailing: PopupMenuButton<String>(
          onSelected: (value) =>
              _handleNotificationAction(context, value, notification),
          itemBuilder: (context) => [
            if (!notification.isRead)
              const PopupMenuItem(
                value: 'mark_read',
                child: Text('Mark as read'),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
        onTap: () => _handleNotificationTap(context, notification),
      ),
    );
  }

  Icon _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.AppointmentReminder:
        return const Icon(Icons.calendar_today);
      case NotificationType.MessageReceived:
        return const Icon(Icons.message);
      case NotificationType.PaymentConfirmation:
        return const Icon(Icons.payment);
      case NotificationType.SystemUpdate:
        return const Icon(Icons.system_update);
      default:
        return const Icon(Icons.notifications);
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  void _handleNotificationAction(
      BuildContext context, String action, notic.Notification notification) {
    switch (action) {
      case 'mark_read':
        context.read<NotificationBloc>().add(
              MarkNotificationAsRead(
                  notificationId: notification.notificationId),
            );
        break;
      case 'delete':
        context.read<NotificationBloc>().add(
              DeleteNotification(notificationId: notification.notificationId),
            );
        break;
    }
  }

  void _handleNotificationTap(
      BuildContext context, notic.Notification notification) {
    // TODO: Implement navigation based on notification type
    switch (notification.notificationType) {
      case NotificationType.AppointmentReminder:
        // Navigate to appointment details
        break;
      case NotificationType.MessageReceived:
        // Navigate to chat
        break;
      case NotificationType.PaymentConfirmation:
        // Navigate to payment details
        break;
      case NotificationType.SystemUpdate:
        // Show system update details
        break;
    }
  }
}
