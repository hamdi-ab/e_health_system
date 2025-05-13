// File: lib/models/experience.dart

import 'doctor.dart';

class Experience {
  final String experienceId;
  final String institution;
  final DateTime startDate;
  final DateTime? endDate; // Nullable: if null, then still working at the institute.
  final String? description;
  final String doctorId;
  final Doctor? doctor; // Optional navigation property.

  Experience({
    required this.experienceId,
    required this.institution,
    required this.startDate,
    this.endDate,
    this.description,
    required this.doctorId,
    this.doctor,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      experienceId: json['experienceId'] as String,
      institution: json['institution'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      description: json['description'] as String?,
      doctorId: json['doctorId'] as String,
      doctor: json['doctor'] != null
          ? Doctor.fromJson(json['doctor'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'experienceId': experienceId,
      'institution': institution,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'description': description,
      'doctorId': doctorId,
      'doctor': doctor?.toJson(),
    };
  }
}
