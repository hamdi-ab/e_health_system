// lib/features/search/data/repositories/doctor_repository.dart

import 'dart:async';

import 'package:e_health_system/features/auth/data/repositories/user_repository.dart';
import 'package:e_health_system/models/doctor_speciality.dart';
import 'package:e_health_system/models/doctos_availability.dart';
import 'package:e_health_system/models/education.dart';
import 'package:e_health_system/models/experience.dart';
import 'package:e_health_system/models/review.dart';
import 'package:e_health_system/shared/enums/day_of_week.dart';
import 'package:flutter/material.dart' show TimeOfDay;

import '../../../../models/doctor.dart';
import '../../../../shared/enums/doctor_status.dart';

class DoctorRepository {
  // Simulates fetching a list of doctors after a delay.
  Future<List<Doctor>> fetchDoctors() async {
    // Simulate network delay.
    await Future.delayed(const Duration(seconds: 1));

    // Return dummy data.
    return mockDoctors;
  }

  // New method: Fetch a single doctor for a given userId.
  Future<Doctor> fetchDoctorForUser(String userId) async {
    final doctors = await fetchDoctors();
    // If no doctor is found, throw an error (or adjust as needed).
    return doctors.firstWhere(
      (doctor) => doctor.userId == userId,
      orElse: () => throw Exception("Doctor not found for userId: $userId"),
    );
  }

  // New method: Fetch doctors by a specific speciality id.
  Future<List<Doctor>> fetchDoctorsBySpeciality(String specialityId) async {
    final doctors = await fetchDoctors();
    final filtered = doctors.where((doctor) {
      // If the doctor has specialties, check if any has the matching specialityId.
      return doctor.doctorSpecialities
          .any((ds) => ds.specialityId == specialityId);
    }).toList();
    return filtered;
  }
}

List<Doctor> mockDoctors = [
  Doctor(
    doctorId: "doc1",
    userId: "user1",
    qualifications: "MD, Cardiology",
    biography: "Senior Cardiologist with 15 years of experience.",
    doctorStatus: DoctorStatus.Active,
    isVerified: true,
    doctorPreferenceId: "pref1",
    doctorPreference: null, // Placeholder for real preference data
    cvId: "cv1",
    cv: null, // Placeholder for a file model (CV upload)
    user: mockUsers[0], // Corresponds to "Hamdi Ahmed" in UserRepository
    doctorSpecialities: [
      DoctorSpeciality(
        doctorId: "doc1",
        specialityId: "cardio-001",
      ),
    ],
    doctorAvailabilities: [
      DoctorAvailability(
        doctorAvailabilityId: "avail-001",
        doctorId: "doc1",
        availableDay: DayOfWeek.monday,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
        doctor: null,
      ),
    ],
    appointments: [],
    educations: [
      Education(
        educationId: "edu1",
        degree: "Doctor of Medicine",
        institution: "Harvard Medical School",
        startDate: DateTime(2005, 1, 1),
        endDate: DateTime(2011, 12, 31),
        doctorId: "doc1",
        doctor: null,
      ),
    ],
    experiences: [
      Experience(
        experienceId: "exp1",
        institution: "General Hospital",
        startDate: DateTime(2012, 1, 1),
        endDate: DateTime(2024, 12, 31),
        description: "Senior Cardiologist providing expert cardiac care.",
        doctorId: "doc1",
        doctor: null,
      ),
    ],
    reviews: [
      Review(
        reviewId: "rev1",
        doctorId: "doc1",
        patientId: "patient1",
        starRating: 5.0,
        reviewText: "Excellent service and care!",
        doctor: null,
        patient: null,
      ),
    ],
  ),
  Doctor(
    doctorId: "doc2",
    userId: "user2",
    qualifications: "MD, Neurology",
    biography:
        "Expert Neurologist specializing in epilepsy and stroke treatment.",
    doctorStatus: DoctorStatus.Active,
    isVerified: true,
    doctorPreferenceId: "pref2",
    doctorPreference: null,
    cvId: "cv2",
    cv: null,
    user: mockUsers[1],
    doctorSpecialities: [
      DoctorSpeciality(
        doctorId: "doc2",
        specialityId: "neuro-001",
      ),
    ],
    doctorAvailabilities: [
      DoctorAvailability(
        doctorAvailabilityId: "avail-002",
        doctorId: "doc2",
        availableDay: DayOfWeek.wednesday,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 18, minute: 0),
        doctor: null,
      ),
    ],
    appointments: [],
    educations: [
      Education(
        educationId: "edu2",
        degree: "Doctor of Medicine",
        institution: "Johns Hopkins School of Medicine",
        startDate: DateTime(2007, 1, 1),
        endDate: DateTime(2013, 12, 31),
        doctorId: "doc2",
        doctor: null,
      ),
    ],
    experiences: [
      Experience(
        experienceId: "exp2",
        institution: "Neurology Institute",
        startDate: DateTime(2014, 1, 1),
        endDate: null, // Still working here
        description: "Lead Neurologist specializing in epilepsy treatment.",
        doctorId: "doc2",
        doctor: null,
      ),
    ],
    reviews: [
      Review(
        reviewId: "rev2",
        doctorId: "doc2",
        patientId: "patient2",
        starRating: 4.0,
        reviewText: "Very knowledgeable and professional.",
        doctor: null,
        patient: null,
      ),
    ],
  ),
];
