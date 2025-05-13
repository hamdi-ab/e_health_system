// File: lib/models/review.dart

import 'doctor.dart';
import 'patient.dart';

class Review {
  final String reviewId;
  final String doctorId;
  final String patientId;
  final double starRating;
  final String reviewText;
  final Doctor? doctor;
  final Patient? patient;

  Review({
    required this.reviewId,
    required this.doctorId,
    required this.patientId,
    required this.starRating,
    required this.reviewText,
    this.doctor,
    this.patient,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['reviewId'] as String,
      doctorId: json['doctorId'] as String,
      patientId: json['patientId'] as String,
      starRating: (json['starRating'] as num).toDouble(),
      reviewText: json['reviewText'] as String,
      doctor: json['doctor'] != null
          ? Doctor.fromJson(json['doctor'] as Map<String, dynamic>)
          : null,
      patient: json['patient'] != null
          ? Patient.fromJson(json['patient'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'doctorId': doctorId,
      'patientId': patientId,
      'starRating': starRating,
      'reviewText': reviewText,
      'doctor': doctor?.toJson(),
      'patient': patient?.toJson(),
    };
  }
}
