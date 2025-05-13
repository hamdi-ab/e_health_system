// File: lib/models/doctor_speciality.dart
import 'package:e_health_system/models/speciality.dart';

import 'doctor.dart';

class DoctorSpeciality {
  final String doctorId;
  final Doctor? doctor;
  final String specialityId;
  final Speciality? speciality;

  DoctorSpeciality({
    required this.doctorId,
    this.doctor,
    required this.specialityId,
    this.speciality,
  });

  factory DoctorSpeciality.fromJson(Map<String, dynamic> json) {
    return DoctorSpeciality(
      doctorId: json['doctorId'] as String,
      specialityId: json['specialityId'] as String,
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
      speciality: json['speciality'] != null
          ? Speciality.fromJson(json['speciality'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'specialityId': specialityId,
      'doctor': doctor?.toJson(),
      'speciality': speciality?.toJson(),
    };
  }
}
