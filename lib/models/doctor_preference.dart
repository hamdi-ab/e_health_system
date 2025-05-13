// File: lib/models/doctor_preference.dart

import 'doctor.dart'; // Adjust the import path as needed.

class DoctorPreference {
  final String doctorId;
  final Doctor? doctor;
  final double onlineAppointmentFee;
  final double inPersonAppointmentFee;

  DoctorPreference({
    required this.doctorId,
    this.doctor,
    required this.onlineAppointmentFee,
    required this.inPersonAppointmentFee,
  });

  factory DoctorPreference.fromJson(Map<String, dynamic> json) {
    return DoctorPreference(
      doctorId: json['doctorId'] as String,
      doctor: json['doctor'] != null
          ? Doctor.fromJson(json['doctor'] as Map<String, dynamic>)
          : null,
      onlineAppointmentFee:
      (json['onlineAppointmentFee'] as num).toDouble(),
      inPersonAppointmentFee:
      (json['inPersonAppointmentFee'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'doctor': doctor?.toJson(),
      'onlineAppointmentFee': onlineAppointmentFee,
      'inPersonAppointmentFee': inPersonAppointmentFee,
    };
  }
}
