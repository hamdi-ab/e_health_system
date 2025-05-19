// lib/features/search/data/repositories/doctor_repository.dart

import 'dart:async';

import 'package:e_health_system/features/auth/data/repositories/user_repository.dart';
import 'package:e_health_system/models/doctor_speciality.dart';
import 'package:e_health_system/models/doctos_availability.dart';
import 'package:e_health_system/models/education.dart';
import 'package:e_health_system/models/experience.dart';
import 'package:e_health_system/models/review.dart';
import 'package:e_health_system/models/user.dart';
import 'package:e_health_system/shared/enums/day_of_week.dart';
import 'package:e_health_system/shared/enums/gender.dart';
import 'package:e_health_system/shared/enums/role.dart';
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

  // New method: Search doctors by query and filters
  Future<List<Doctor>> searchDoctors({
    required String query,
    String? category,
    Map<String, dynamic>? filters,
  }) async {
    final doctors = await fetchDoctors();

    return doctors.where((doctor) {
      // Search by name
      final nameMatch =
          doctor.user.firstName.toLowerCase().contains(query.toLowerCase()) ||
              doctor.user.lastName.toLowerCase().contains(query.toLowerCase());

      // Search by specialty
      final specialtyMatch = doctor.doctorSpecialities.any((specialty) =>
          specialty.specialityId.toLowerCase().contains(query.toLowerCase()));

      // Search by qualifications
      final qualificationsMatch =
          doctor.qualifications.toLowerCase().contains(query.toLowerCase());

      // Search by biography
      final biographyMatch =
          doctor.biography.toLowerCase().contains(query.toLowerCase());

      // Apply filters if provided
      if (filters != null) {
        final specialtyFilter = filters['specialty'] as String?;
        final ratingFilter = filters['rating'] as int?;
        final availabilityFilter = filters['availability'] as String?;

        if (specialtyFilter != null) {
          final hasSpecialty = doctor.doctorSpecialities.any((specialty) =>
              specialty.specialityId.toLowerCase() ==
              specialtyFilter.toLowerCase());
          if (!hasSpecialty) return false;
        }

        if (ratingFilter != null) {
          final averageRating = doctor.reviews.isEmpty
              ? 0.0
              : doctor.reviews
                      .map((r) => r.starRating)
                      .reduce((a, b) => a + b) /
                  doctor.reviews.length;
          if (averageRating < ratingFilter) return false;
        }

        if (availabilityFilter != null) {
          final now = DateTime.now();
          final hasAvailability =
              doctor.doctorAvailabilities.any((availability) {
            if (availabilityFilter == 'today') {
              return availability.availableDay ==
                  DayOfWeek.values[now.weekday - 1];
            } else if (availabilityFilter == 'week') {
              return true; // For now, just return true if they have any availability
            }
            return false;
          });
          if (!hasAvailability) return false;
        }
      }

      return nameMatch ||
          specialtyMatch ||
          qualificationsMatch ||
          biographyMatch;
    }).toList();
  }
}

List<Doctor> mockDoctors = [
  // Cardiology - sp1
  Doctor(
    doctorId: "doc1",
    userId: "user1",
    qualifications: "MD, Cardiology",
    biography:
        "Senior Cardiologist with 15 years of experience specializing in heart health and preventive care.",
    doctorStatus: DoctorStatus.Active,
    isVerified: true,
    doctorPreferenceId: "pref1",
    doctorPreference: null,
    cvId: "cv1",
    cv: null,
    user: mockUsers[0], // Hamdi Ahmed
    doctorSpecialities: [
      DoctorSpeciality(
        doctorId: "doc1",
        specialityId: "sp1", // Cardiology
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

  // Neurology - sp4
  Doctor(
    doctorId: "doc2",
    userId: "user2",
    qualifications: "MD, Neurology",
    biography:
        "Expert Neurologist specializing in epilepsy and stroke treatment with cutting-edge techniques.",
    doctorStatus: DoctorStatus.Active,
    isVerified: true,
    doctorPreferenceId: "pref2",
    doctorPreference: null,
    cvId: "cv2",
    cv: null,
    user: mockUsers[1], // Sophia Williams
    doctorSpecialities: [
      DoctorSpeciality(
        doctorId: "doc2",
        specialityId: "sp4", // Neurology
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
        starRating: 4.5,
        reviewText: "Very knowledgeable and professional.",
        doctor: null,
        patient: null,
      ),
    ],
  ),

  // Pediatrics - sp2
  Doctor(
    doctorId: "doc3",
    userId: "user3",
    qualifications: "MD, Pediatrics",
    biography:
        "Compassionate pediatrician with a focus on newborn care and childhood development.",
    doctorStatus: DoctorStatus.Active,
    isVerified: true,
    doctorPreferenceId: "pref3",
    doctorPreference: null,
    cvId: "cv3",
    cv: null,
    user: User(
      userId: "user3",
      firstName: "Michael",
      lastName: "Lee",
      email: "m.lee@hospital.com",
      isEmailVerified: true,
      phone: "+1234567890",
      gender: Gender.Male,
      dateOfBirth: DateTime(1980, 5, 15),
      address: "Chicago, USA",
      role: Role.Doctor,
    ),
    doctorSpecialities: [
      DoctorSpeciality(
        doctorId: "doc3",
        specialityId: "sp2", // Pediatrics
      ),
    ],
    doctorAvailabilities: [
      DoctorAvailability(
        doctorAvailabilityId: "avail-003",
        doctorId: "doc3",
        availableDay: DayOfWeek.tuesday,
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 0),
        doctor: null,
      ),
    ],
    appointments: [],
    educations: [
      Education(
        educationId: "edu3",
        degree: "Doctor of Medicine",
        institution: "Stanford University",
        startDate: DateTime(2003, 1, 1),
        endDate: DateTime(2009, 12, 31),
        doctorId: "doc3",
        doctor: null,
      ),
    ],
    experiences: [
      Experience(
        experienceId: "exp3",
        institution: "Children's Hospital",
        startDate: DateTime(2010, 1, 1),
        endDate: null,
        description: "Pediatrician specializing in infant and child care.",
        doctorId: "doc3",
        doctor: null,
      ),
    ],
    reviews: [
      Review(
        reviewId: "rev3",
        doctorId: "doc3",
        patientId: "patient3",
        starRating: 4.8,
        reviewText: "Great with kids, very patient and thorough.",
        doctor: null,
        patient: null,
      ),
    ],
  ),

  // Dermatology - sp3
  Doctor(
    doctorId: "doc4",
    userId: "user4",
    qualifications: "MD, Dermatology",
    biography:
        "Board certified dermatologist specializing in skin disorders and cosmetic procedures.",
    doctorStatus: DoctorStatus.Active,
    isVerified: true,
    doctorPreferenceId: "pref4",
    doctorPreference: null,
    cvId: "cv4",
    cv: null,
    user: User(
      userId: "user4",
      firstName: "Emily",
      lastName: "Garcia",
      email: "e.garcia@hospital.com",
      isEmailVerified: true,
      phone: "+1234567891",
      gender: Gender.Female,
      dateOfBirth: DateTime(1985, 8, 10),
      address: "Miami, USA",
      role: Role.Doctor,
    ),
    doctorSpecialities: [
      DoctorSpeciality(
        doctorId: "doc4",
        specialityId: "sp3", // Dermatology
      ),
    ],
    doctorAvailabilities: [
      DoctorAvailability(
        doctorAvailabilityId: "avail-004",
        doctorId: "doc4",
        availableDay: DayOfWeek.friday,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
        doctor: null,
      ),
    ],
    appointments: [],
    educations: [
      Education(
        educationId: "edu4",
        degree: "Doctor of Medicine",
        institution: "Yale School of Medicine",
        startDate: DateTime(2006, 1, 1),
        endDate: DateTime(2012, 12, 31),
        doctorId: "doc4",
        doctor: null,
      ),
    ],
    experiences: [
      Experience(
        experienceId: "exp4",
        institution: "Dermatology Clinic",
        startDate: DateTime(2013, 1, 1),
        endDate: null,
        description: "Specializing in cosmetic and medical dermatology.",
        doctorId: "doc4",
        doctor: null,
      ),
    ],
    reviews: [
      Review(
        reviewId: "rev4",
        doctorId: "doc4",
        patientId: "patient4",
        starRating: 4.9,
        reviewText: "Excellent results with my skin treatment.",
        doctor: null,
        patient: null,
      ),
    ],
  ),

  // Orthopedics - sp5
  Doctor(
    doctorId: "doc5",
    userId: "user5",
    qualifications: "MD, Orthopedic Surgery",
    biography:
        "Specializing in joint replacements and sports injuries with minimally invasive techniques.",
    doctorStatus: DoctorStatus.Active,
    isVerified: true,
    doctorPreferenceId: "pref5",
    doctorPreference: null,
    cvId: "cv5",
    cv: null,
    user: User(
      userId: "user5",
      firstName: "David",
      lastName: "Wilson",
      email: "d.wilson@hospital.com",
      isEmailVerified: true,
      phone: "+1234567892",
      gender: Gender.Male,
      dateOfBirth: DateTime(1975, 3, 20),
      address: "Boston, USA",
      role: Role.Doctor,
    ),
    doctorSpecialities: [
      DoctorSpeciality(
        doctorId: "doc5",
        specialityId: "sp5", // Orthopedics
      ),
    ],
    doctorAvailabilities: [
      DoctorAvailability(
        doctorAvailabilityId: "avail-005",
        doctorId: "doc5",
        availableDay: DayOfWeek.thursday,
        startTime: const TimeOfDay(hour: 8, minute: 0),
        endTime: const TimeOfDay(hour: 16, minute: 0),
        doctor: null,
      ),
    ],
    appointments: [],
    educations: [
      Education(
        educationId: "edu5",
        degree: "Doctor of Medicine",
        institution: "Cornell University",
        startDate: DateTime(2000, 1, 1),
        endDate: DateTime(2006, 12, 31),
        doctorId: "doc5",
        doctor: null,
      ),
    ],
    experiences: [
      Experience(
        experienceId: "exp5",
        institution: "Sports Medicine Center",
        startDate: DateTime(2007, 1, 1),
        endDate: null,
        description: "Orthopedic surgeon specializing in sports injuries.",
        doctorId: "doc5",
        doctor: null,
      ),
    ],
    reviews: [
      Review(
        reviewId: "rev5",
        doctorId: "doc5",
        patientId: "patient5",
        starRating: 4.7,
        reviewText: "Excellent surgeon, my knee replacement went perfectly.",
        doctor: null,
        patient: null,
      ),
    ],
  ),

  // Oncology - sp6
  Doctor(
    doctorId: "doc6",
    userId: "user6",
    qualifications: "MD, PhD, Oncology",
    biography:
        "Cancer specialist with focus on innovative treatment approaches and clinical research.",
    doctorStatus: DoctorStatus.Active,
    isVerified: true,
    doctorPreferenceId: "pref6",
    doctorPreference: null,
    cvId: "cv6",
    cv: null,
    user: User(
      userId: "user6",
      firstName: "Sarah",
      lastName: "Johnson",
      email: "s.johnson@hospital.com",
      isEmailVerified: true,
      phone: "+1234567893",
      gender: Gender.Female,
      dateOfBirth: DateTime(1978, 11, 5),
      address: "Seattle, USA",
      role: Role.Doctor,
    ),
    doctorSpecialities: [
      DoctorSpeciality(
        doctorId: "doc6",
        specialityId: "sp6", // Oncology
      ),
    ],
    doctorAvailabilities: [
      DoctorAvailability(
        doctorAvailabilityId: "avail-006",
        doctorId: "doc6",
        availableDay: DayOfWeek.monday,
        startTime: const TimeOfDay(hour: 10, minute: 0),
        endTime: const TimeOfDay(hour: 18, minute: 0),
        doctor: null,
      ),
    ],
    appointments: [],
    educations: [
      Education(
        educationId: "edu6",
        degree: "MD, PhD",
        institution: "University of California",
        startDate: DateTime(2002, 1, 1),
        endDate: DateTime(2010, 12, 31),
        doctorId: "doc6",
        doctor: null,
      ),
    ],
    experiences: [
      Experience(
        experienceId: "exp6",
        institution: "Cancer Research Center",
        startDate: DateTime(2011, 1, 1),
        endDate: null,
        description:
            "Leading oncologist conducting clinical trials for new cancer treatments.",
        doctorId: "doc6",
        doctor: null,
      ),
    ],
    reviews: [
      Review(
        reviewId: "rev6",
        doctorId: "doc6",
        patientId: "patient6",
        starRating: 5.0,
        reviewText: "Dr. Johnson saved my life. Eternally grateful.",
        doctor: null,
        patient: null,
      ),
    ],
  ),

  // Gynecology - sp7
  Doctor(
    doctorId: "doc7",
    userId: "user7",
    qualifications: "MD, Obstetrics & Gynecology",
    biography:
        "Specialized in women's health, prenatal care, and minimally invasive gynecological procedures.",
    doctorStatus: DoctorStatus.Active,
    isVerified: true,
    doctorPreferenceId: "pref7",
    doctorPreference: null,
    cvId: "cv7",
    cv: null,
    user: User(
      userId: "user7",
      firstName: "Maria",
      lastName: "Rodriguez",
      email: "m.rodriguez@hospital.com",
      isEmailVerified: true,
      phone: "+1234567894",
      gender: Gender.Female,
      dateOfBirth: DateTime(1982, 7, 15),
      address: "San Francisco, USA",
      role: Role.Doctor,
    ),
    doctorSpecialities: [
      DoctorSpeciality(
        doctorId: "doc7",
        specialityId: "sp7", // Gynecology
      ),
    ],
    doctorAvailabilities: [
      DoctorAvailability(
        doctorAvailabilityId: "avail-007",
        doctorId: "doc7",
        availableDay: DayOfWeek.wednesday,
        startTime: const TimeOfDay(hour: 9, minute: 0),
        endTime: const TimeOfDay(hour: 17, minute: 0),
        doctor: null,
      ),
    ],
    appointments: [],
    educations: [
      Education(
        educationId: "edu7",
        degree: "Doctor of Medicine",
        institution: "Columbia University",
        startDate: DateTime(2004, 1, 1),
        endDate: DateTime(2010, 12, 31),
        doctorId: "doc7",
        doctor: null,
      ),
    ],
    experiences: [
      Experience(
        experienceId: "exp7",
        institution: "Women's Health Center",
        startDate: DateTime(2011, 1, 1),
        endDate: null,
        description: "OB/GYN focusing on comprehensive women's health.",
        doctorId: "doc7",
        doctor: null,
      ),
    ],
    reviews: [
      Review(
        reviewId: "rev7",
        doctorId: "doc7",
        patientId: "patient7",
        starRating: 4.9,
        reviewText:
            "Dr. Rodriguez is amazing, made me feel comfortable throughout my pregnancy.",
        doctor: null,
        patient: null,
      ),
    ],
  ),
];
