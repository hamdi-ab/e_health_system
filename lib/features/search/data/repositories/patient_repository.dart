import 'dart:async';

import 'package:e_health_system/features/auth/data/repositories/user_repository.dart';
import 'package:e_health_system/models/patient.dart';

class PatientRepository {
  // Simulates fetching a list of doctors after a delay.
  Future<List<Patient>> fetchPatinets() async {
    // Simulate network delay.
    await Future.delayed(const Duration(seconds: 1));

    // Return dummy data.
    return mockPatients;
  }

  // New method: Fetch a single doctor for a given userId.
  Future<Patient> fetchPatientForUser(String userId) async {
    final doctors = await fetchPatinets();
    // If no doctor is found, throw an error (or adjust as needed).
    return doctors.firstWhere(
      (doctor) => doctor.userId == userId,
      orElse: () => throw Exception("Doctor not found for userId: $userId"),
    );
  }
}

final List<Patient> mockPatients = [
  Patient(
    patientId: "pat-001",
    userId: "user3", // Corresponds to mockUsers[2]
    user: mockUsers[2], // Maps to Ali Khan
    medicalHistory: "Hypertension, Diabetes",
    emergencyContactName: "Alice Johnson",
    emergencyContactPhone: "+251911223344",
  ),
  Patient(
    patientId: "pat-002",
    userId: "user4", // Corresponds to mockUsers[3]
    user: mockUsers[3], // Maps to Aisha Mohammed
    medicalHistory: "Asthma",
    emergencyContactName: "Robert Smith",
    emergencyContactPhone: "+251922334455",
  ),
];
