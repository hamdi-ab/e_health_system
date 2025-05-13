// File: lib/models/notification.dart


import '../../../../models/user.dart';
import '../../../../shared/enums/notification_type.dart';

class Notification {
  final String notificationId; // GUID represented as a String
  final String userId;         // Foreign key: User's GUID
  final NotificationType notificationType;
  final String message;
  final User? user;            // Optional navigation property

  Notification({
    required this.notificationId,
    required this.userId,
    required this.notificationType,
    required this.message,
    this.user,
  });

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notificationId: json['notificationId'] as String,
      userId: json['userId'] as String,
      notificationType: NotificationType.values.firstWhere(
            (e) => e.toString().split('.').last.toLowerCase() ==
            (json['notificationType'] as String).toLowerCase(),
        // Fallback option if necessary; adjust as needed
        orElse: () => NotificationType.SystemUpdate,
      ),
      message: json['message'] as String,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'notificationType': notificationType.toString().split('.').last,
      'message': message,
      'user': user?.toJson(),
    };
  }
}
