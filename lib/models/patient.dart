import 'package:e_health_system/features/appointment/domain/entities/appointment.dart';
import 'user.dart';
import 'review.dart';

class Patient {
  final String patientId;
  final String userId;
  final String? medicalHistory;
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final User user;
  final List<Appointment> appointments;
  final List<Review> reviews;

  Patient({
    String? patientId,
    required this.userId,
    required this.user,
    this.medicalHistory,
    this.emergencyContactName,
    this.emergencyContactPhone,
    List<Appointment>? appointments,
    List<Review>? reviews,
  })  : patientId =
            patientId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        appointments = appointments ?? [],
        reviews = reviews ?? [];

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      patientId: json['patientId'] as String?,
      userId: json['userId'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      medicalHistory: json['medicalHistory'] as String?,
      emergencyContactName: json['emergencyContactName'] as String?,
      emergencyContactPhone: json['emergencyContactPhone'] as String?,
      appointments: (json['appointments'] as List<dynamic>?)
          ?.map((e) => Appointment.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'patientId': patientId,
        'userId': userId,
        'user': user.toJson(),
        'medicalHistory': medicalHistory,
        'emergencyContactName': emergencyContactName,
        'emergencyContactPhone': emergencyContactPhone,
        'appointments': appointments.map((e) => e.toJson()).toList(),
        'reviews': reviews.map((e) => e.toJson()).toList(),
      };

  Patient copyWith({
    String? patientId,
    String? userId,
    User? user,
    String? medicalHistory,
    String? emergencyContactName,
    String? emergencyContactPhone,
    List<Appointment>? appointments,
    List<Review>? reviews,
  }) {
    return Patient(
      patientId: patientId ?? this.patientId,
      userId: userId ?? this.userId,
      user: user ?? this.user,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      appointments: appointments ?? this.appointments,
      reviews: reviews ?? this.reviews,
    );
  }
}
