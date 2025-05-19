// File: lib/models/notification.dart


import '../../../../models/user.dart';
import '../../../../shared/enums/notification_type.dart';

class Notification {
  final String notificationId; // GUID represented as a String
  final String userId;         // Foreign key: User's GUID
  final NotificationType notificationType;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final User? user;            // Optional navigation property

  Notification({
    required this.notificationId,
    required this.userId,
    required this.notificationType,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.user,
  });

  Notification copyWith({
    String? notificationId,
    String? userId,
    NotificationType? notificationType,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    User? user,
  }) {
    return Notification(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      notificationType: notificationType ?? this.notificationType,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      user: user ?? this.user,
    );
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notificationId: json['notificationId'] as String,
      userId: json['userId'] as String,
      notificationType: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last.toLowerCase() ==
            (json['notificationType'] as String).toLowerCase(),
        orElse: () => NotificationType.SystemUpdate,
      ),
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'notificationType': notificationType.toString().split('.').last,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
      'user': user?.toJson(),
    };
  }
}
