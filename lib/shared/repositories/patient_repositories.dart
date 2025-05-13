// File: lib/shared/repositories/patient_repository.dart

import 'dart:async';

import '../../models/patient.dart';
import '../../models/user.dart';
import '../../shared/enums/gender.dart';
import '../../shared/enums/role.dart';

class PatientRepository {
  // Simulates fetching a Patient record based on the user's ID.
  Future<Patient> fetchPatientByUserId(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Create a dummy user that belongs to the patient.
    final dummyUser = User(
      userId: userId,
      auth0Id: "auth0_dummy_id",
      auth0AccessToken: "dummy_access_token",
      auth0RefreshToken: "dummy_refresh_token",
      firstName: "Jane",
      lastName: "Doe",
      email: "jane.doe@example.com",
      isEmailVerified: true,
      otp: null,
      phone: "+251911223344",
      gender: Gender.Female,
      dateOfBirth: DateTime(1990, 1, 1),
      profilePicture: "https://example.com/jane_doe.jpg",
      address: "Addis Ababa, Ethiopia",
      role: Role.Patient,
    );

    // Return the dummy patient record.
    return Patient(
      patientId: "patient_dummy_1",
      userId: userId,
      medicalHistory: "No current medical issues",
      emergencyContactName: "John Doe",
      emergencyContactPhone: "+251900112233",
      user: dummyUser,
    );
  }
}
