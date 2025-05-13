// File: lib/models/education.dart

import 'doctor.dart';

class Education {
  final String educationId;
  final String degree;
  final String institution;
  final DateTime startDate;
  final DateTime endDate;
  final String doctorId;
  final Doctor? doctor;

  Education({
    required this.educationId,
    required this.degree,
    required this.institution,
    required this.startDate,
    required this.endDate,
    required this.doctorId,
    this.doctor,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      educationId: json['educationId'] as String,
      degree: json['degree'] as String,
      institution: json['institution'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      doctorId: json['doctorId'] as String,
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'educationId': educationId,
      'degree': degree,
      'institution': institution,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'doctorId': doctorId,
      'doctor': doctor?.toJson(),
    };
  }
}
