import 'package:equatable/equatable.dart';
import '../../domain/entities/notification.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final String userId;
  
  const LoadNotifications({required this.userId});

  @override
  List<Object> get props => [userId];
}

class MarkNotificationAsRead extends NotificationEvent {
  final String notificationId;

  const MarkNotificationAsRead({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}

class MarkAllNotificationsAsRead extends NotificationEvent {
  final String userId;

  const MarkAllNotificationsAsRead({required this.userId});

  @override
  List<Object> get props => [userId];
}

class DeleteNotification extends NotificationEvent {
  final String notificationId;

  const DeleteNotification({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}

class NotificationReceived extends NotificationEvent {
  final Notification notification;

  const NotificationReceived({required this.notification});

  @override
  List<Object> get props => [notification];
} 