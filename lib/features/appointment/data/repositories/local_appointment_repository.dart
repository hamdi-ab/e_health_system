import 'dart:async';

import 'package:e_health_system/features/appointment/domain/entities/appointment.dart';
import 'package:e_health_system/features/search/data/repositories/doctor_repository.dart';
import 'package:e_health_system/features/search/data/repositories/patient_repository.dart';
import 'package:e_health_system/shared/enums/appointment_type.dart';
import 'package:flutter/material.dart' show TimeOfDay;

class LocalAppointmentRepository {
  late final DoctorRepository doctorRepository;
  late final PatientRepository patientRepository;

  LocalAppointmentRepository({
    required this.doctorRepository,
    required this.patientRepository,
  });

  // Counter to generate unique appointment IDs
  int _appointmentCounter = 0;

  /// Create a new appointment and associate it with the doctor and patient repositories.
  Future<Appointment> createAppointment(
      String doctorId,
      String patientId,
      DateTime appointmentDate,
      TimeOfDay appointmentTime,
      AppointmentType appointmentType) async {
    _appointmentCounter++;
    final appointmentId = 'apt_$_appointmentCounter';

    final appointment = Appointment(
      appointmentId: appointmentId,
      doctorId: doctorId,
      patientId: patientId,
      appointmentDate: appointmentDate,
      appointmentTime: appointmentTime,
      appointmentType: appointmentType,
    );

    // Add appointment to the local list
    appointments.add(appointment);

    // Associate appointment with the doctor
    try {
      final doctor = await doctorRepository.fetchDoctorForUser(doctorId);
      doctor.appointments.add(appointment);
    } catch (e) {
      print('Warning: Doctor not found for ID: $doctorId');
    }

    // Associate appointment with the patient
    try {
      final patient = await patientRepository.fetchPatientForUser(patientId);
      patient.appointments.add(appointment);
    } catch (e) {
      print('Warning: Patient not found for ID: $patientId');
    }

    return appointment;
  }

  /// Retrieve an appointment by ID
  Future<Appointment?> getAppointmentById(String appointmentId) async {
    try {
      return appointments.firstWhere(
          (appointment) => appointment.appointmentId == appointmentId);
    } catch (e) {
      return null; // Return `null` safely if no appointment matches
    }
  }

  /// Retrieve all appointments
  Future<List<Appointment>> getAppointments() async {
    return appointments;
  }

  /// Retrieve all appointments for a specific doctor
  Future<List<Appointment>> getAppointmentsByDoctorId(String doctorId) async {
    return appointments
        .where((appointment) => appointment.doctorId == doctorId)
        .toList();
  }

  /// Retrieve all appointments for a specific patient
  Future<List<Appointment>> getAppointmentsByPatientId(String patientId) async {
    return appointments
        .where((appointment) => appointment.patientId == patientId)
        .toList();
  }

  /// Update an existing appointment
  // Future<void> updateAppointment(String appointmentId,
  //     {DateTime? appointmentDate,
  //     DateTime? appointmentTime,
  //     String? appointmentType}) async {
  //   final appointment = await getAppointmentById(appointmentId);
  //   if (appointment == null) {
  //     throw Exception("Appointment not found: $appointmentId");
  //   }

  //   if (appointmentDate != null) {
  //     appointment.appointmentDate = appointmentDate;
  //   }
  //   if (appointmentTime != null) {
  //     appointment.appointmentTime = appointmentTime;
  //   }
  //   if (appointmentType != null) {
  //     appointment.appointmentType = appointmentType;
  //   }
  // }

  /// Delete an appointment
  Future<void> deleteAppointment(String appointmentId) async {
    appointments.removeWhere(
        (appointment) => appointment.appointmentId == appointmentId);
  }
}

final List<Appointment> appointments = [
  Appointment(
    appointmentId: "apt1",
    doctorId: "doc1",
    patientId: "pat1",
    appointmentDate: DateTime(2025, 5, 12),
    appointmentTime: const TimeOfDay(hour: 9, minute: 30), // 9:30 AM
    appointmentType: AppointmentType.Consultation,
  ),
  Appointment(
    appointmentId: "apt2",
    doctorId: "doc1",
    patientId: "pat2",
    appointmentDate: DateTime(2025, 5, 13),
    appointmentTime: const TimeOfDay(hour: 4, minute: 30), // 2:00 PM
    appointmentType: AppointmentType.FollowUp,
  ),
  Appointment(
    appointmentId: "apt3",
    doctorId: "doc2",
    patientId: "pat1",
    appointmentDate: DateTime(2025, 5, 14),
    appointmentTime: const TimeOfDay(hour: 10, minute: 30), // 10:15 AM
    appointmentType: AppointmentType.Surgery,
  ),
  Appointment(
    appointmentId: "apt4",
    doctorId: "doc2",
    patientId: "pat2",
    appointmentDate: DateTime(2025, 5, 15),
    appointmentTime: const TimeOfDay(hour: 6, minute: 30), // 4:45 PM
    appointmentType: AppointmentType.Consultation,
  ),
];
