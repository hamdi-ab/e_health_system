import '../entities/notification.dart';

abstract class NotificationRepository {
  Future<List<Notification>> getNotifications(String userId);
  Future<void> markNotificationAsRead(String notificationId);
  Future<void> markAllNotificationsAsRead(String userId);
  Future<void> deleteNotification(String notificationId);
  Future<void> addNotification(Notification notification);
} 