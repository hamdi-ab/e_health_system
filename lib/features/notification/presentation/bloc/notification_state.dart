import 'package:equatable/equatable.dart';
import '../../domain/entities/notification.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<Notification> notifications;
  final int unreadCount;

  const NotificationsLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object> get props => [notifications, unreadCount];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError({required this.message});

  @override
  List<Object> get props => [message];
}

class NotificationMarkedAsRead extends NotificationState {
  final String notificationId;

  const NotificationMarkedAsRead({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
}

class AllNotificationsMarkedAsRead extends NotificationState {}

class NotificationDeleted extends NotificationState {
  final String notificationId;

  const NotificationDeleted({required this.notificationId});

  @override
  List<Object> get props => [notificationId];
} 