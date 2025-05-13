// File: lib/models/payment.dart

import '../../../../models/user.dart' show User;
import '../../../../shared/enums/payment_provider.dart';
import '../../../../shared/enums/payment_status.dart';
import '../../../../shared/enums/payment_type.dart';

class Payment {
  final String paymentId;
  final String transactionReference;
  final String? senderId;
  final String? receiverId;
  final String senderName;
  final String senderEmail;
  final String receiverName;
  final String receiverEmail;
  final double amount;
  final PaymentStatus paymentStatus;
  final PaymentProvider paymentProvider;
  final PaymentType paymentType;
  final User? sender;
  final User? receiver;

  Payment({
    required this.paymentId,
    required this.transactionReference,
    this.senderId,
    this.receiverId,
    required this.senderName,
    required this.senderEmail,
    required this.receiverName,
    required this.receiverEmail,
    required this.amount,
    required this.paymentStatus,
    required this.paymentProvider,
    required this.paymentType,
    this.sender,
    this.receiver,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['paymentId'] as String,
      transactionReference: json['transactionReference'] as String,
      senderId: json['senderId'] as String?,
      receiverId: json['receiverId'] as String?,
      senderName: json['senderName'] as String,
      senderEmail: json['senderEmail'] as String,
      receiverName: json['receiverName'] as String,
      receiverEmail: json['receiverEmail'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentStatus: PaymentStatus.values.firstWhere(
            (e) =>
        e.toString().split('.').last.toLowerCase() ==
            (json['paymentStatus'] as String).toLowerCase(),
        orElse: () => PaymentStatus.Pending,
      ),
      paymentProvider: PaymentProvider.values.firstWhere(
            (e) =>
        e.toString().split('.').last.toLowerCase() ==
            (json['paymentProvider'] as String).toLowerCase(),
      ),
      paymentType: PaymentType.values.firstWhere(
            (e) =>
        e.toString().split('.').last.toLowerCase() ==
            (json['paymentType'] as String).toLowerCase(),
      ),
      sender:
      json['sender'] != null ? User.fromJson(json['sender'] as Map<String, dynamic>) : null,
      receiver: json['receiver'] != null
          ? User.fromJson(json['receiver'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'transactionReference': transactionReference,
      'senderId': senderId,
      'receiverId': receiverId,
      'senderName': senderName,
      'senderEmail': senderEmail,
      'receiverName': receiverName,
      'receiverEmail': receiverEmail,
      'amount': amount,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'paymentProvider': paymentProvider.toString().split('.').last,
      'paymentType': paymentType.toString().split('.').last,
      'sender': sender?.toJson(),
      'receiver': receiver?.toJson(),
    };
  }
}
