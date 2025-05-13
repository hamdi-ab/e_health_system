import 'package:e_health_system/shared/enums/appointment_type.dart';
import 'package:flutter/material.dart' show TimeOfDay;

abstract class AppointmentEvent {}

class LoadAppointments extends AppointmentEvent {}

class LoadAppointmentsByDoctor extends AppointmentEvent {
  final String doctorId;

  LoadAppointmentsByDoctor({required this.doctorId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoadAppointmentsByDoctor && other.doctorId == doctorId);

  @override
  int get hashCode => doctorId.hashCode;
}

class LoadAppointmentsByPatient extends AppointmentEvent {
  final String patientId;

  LoadAppointmentsByPatient({required this.patientId});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoadAppointmentsByPatient && other.patientId == patientId);

  @override
  int get hashCode => patientId.hashCode;
}

class CreateAppointment extends AppointmentEvent {
  final String doctorId;
  final String patientId;
  final DateTime appointmentDate;
  final TimeOfDay appointmentTime;
  final AppointmentType appointmentType;

  CreateAppointment({
    required this.doctorId,
    required this.patientId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.appointmentType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreateAppointment &&
          other.doctorId == doctorId &&
          other.patientId == patientId &&
          other.appointmentDate == appointmentDate &&
          other.appointmentTime == appointmentTime &&
          other.appointmentType == appointmentType);

  @override
  int get hashCode =>
      doctorId.hashCode ^
      patientId.hashCode ^
      appointmentDate.hashCode ^
      appointmentTime.hashCode ^
      appointmentType.hashCode;
}
