import 'package:flutter/material.dart';
import '../../../../models/doctor.dart';
import '../../../../models/patient.dart';
import '../../../../shared/enums/appointment_status.dart';
import '../../../../shared/enums/appointment_type.dart';

class Appointment {
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final DateTime appointmentDate; // Stores only date
  final TimeOfDay appointmentTime; // Stores only time
  final Duration appointmentTimeSpan;
  final AppointmentType appointmentType;
  final AppointmentStatus status;
  final Doctor? doctor; // Optional navigation property
  final Patient? patient; // Optional navigation property

  Appointment({
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    required this.appointmentDate,
    required this.appointmentTime,
    this.appointmentTimeSpan = const Duration(minutes: 30),
    required this.appointmentType,
    this.status = AppointmentStatus.Scheduled,
    this.doctor,
    this.patient,
  });

  // Factory constructor for JSON deserialization
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointmentId'] as String,
      doctorId: json['doctorId'] as String,
      patientId: json['patientId'] as String,
      appointmentDate: DateTime.parse(json['appointmentDate']),
      appointmentTime: TimeOfDay(
        hour: int.parse(json['appointmentTime'].split(':')[0]),
        minute: int.parse(json['appointmentTime'].split(':')[1]),
      ), // Corrected: Extracts hour and minute from JSON
      appointmentTimeSpan:
          Duration(minutes: (json['appointmentTimeSpan'] as int?) ?? 30),
      appointmentType: AppointmentType.values.firstWhere(
        (e) =>
            e.name.toLowerCase() ==
            (json['appointmentType'] as String).toLowerCase(),
      ),
      status: AppointmentStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == (json['status'] as String).toLowerCase(),
        orElse: () => AppointmentStatus.Scheduled,
      ),
      doctor: json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null,
      patient:
          json['patient'] != null ? Patient.fromJson(json['patient']) : null,
    );
  }

  // Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'patientId': patientId,
      'appointmentDate': appointmentDate.toIso8601String(),
      'appointmentTime':
          "${appointmentTime.hour}:${appointmentTime.minute}", // Corrected time format
      'appointmentTimeSpan': appointmentTimeSpan.inMinutes,
      'appointmentType':
          appointmentType.name, // Uses enum `.name` (cleaner approach)
      'status': status.name, // Uses enum `.name`
      'doctor': doctor?.toJson(),
      'patient': patient?.toJson(),
    };
  }
}
