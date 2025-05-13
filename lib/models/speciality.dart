// File: lib/models/speciality.dart
import 'doctor_speciality.dart';

class Speciality {
  final String specialityId;
  late final String specialityName;
  final DateTime createdAt;
  late final DateTime updatedAt;
  final List<DoctorSpeciality>? doctorSpecialities;

  Speciality({
    required this.specialityId,
    required this.specialityName,
    required this.createdAt,
    required this.updatedAt,
    this.doctorSpecialities,
  });

  factory Speciality.fromJson(Map<String, dynamic> json) {
    return Speciality(
      specialityId: json['specialityId'] as String,
      specialityName: json['specialityName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      doctorSpecialities: json['doctorSpecialities'] != null
          ? (json['doctorSpecialities'] as List)
              .map((item) =>
                  DoctorSpeciality.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'specialityId': specialityId,
      'specialityName': specialityName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'doctorSpecialities':
          doctorSpecialities?.map((ds) => ds.toJson()).toList(),
    };
  }
}
