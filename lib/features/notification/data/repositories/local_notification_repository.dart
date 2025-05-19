import 'package:e_health_system/features/notification/domain/entities/notification.dart';
import 'package:e_health_system/features/notification/domain/repositories/notification_repository.dart';
import 'package:e_health_system/shared/enums/notification_type.dart';

class LocalNotificationRepository implements NotificationRepository {
  // Mock data storage
  final List<Notification> _notifications = [
    Notification(
      notificationId: '1',
      userId: 'user1',
      notificationType: NotificationType.AppointmentReminder,
      message: 'Your appointment with Dr. Smith is scheduled for tomorrow at 10:00 AM',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Notification(
      notificationId: '2',
      userId: 'user1',
      notificationType: NotificationType.MessageReceived,
      message: 'New message from Dr. Johnson regarding your test results',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Notification(
      notificationId: '3',
      userId: 'user1',
      notificationType: NotificationType.PaymentConfirmation,
      message: 'Payment of \$150 for consultation has been confirmed',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Notification(
      notificationId: '4',
      userId: 'user1',
      notificationType: NotificationType.SystemUpdate,
      message: 'New features have been added to the app. Check them out!',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Future<List<Notification>> getNotifications(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _notifications.where((n) => n.userId == userId).toList();
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _notifications.indexWhere((n) => n.notificationId == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  @override
  Future<void> markAllNotificationsAsRead(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (var i = 0; i < _notifications.length; i++) {
      if (_notifications[i].userId == userId) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _notifications.removeWhere((n) => n.notificationId == notificationId);
  }

  @override
  Future<void> addNotification(Notification notification) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _notifications.insert(0, notification);
  }
} 