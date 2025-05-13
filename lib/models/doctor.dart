import 'package:e_health_system/features/appointment/domain/entities/appointment.dart';
import 'package:e_health_system/models/doctos_availability.dart';
import 'package:e_health_system/shared/enums/doctor_status.dart';

import 'user.dart';
import 'doctor_preference.dart';
import 'file_model.dart';
import 'doctor_speciality.dart';

import 'education.dart';
import 'experience.dart';
import 'review.dart';

class Doctor {
  final String doctorId;
  final String userId;
  final String qualifications;
  final String biography;
  final DoctorStatus doctorStatus;
  final bool isVerified;
  final String doctorPreferenceId;
  final DoctorPreference? doctorPreference;
  final String cvId;
  final FileModel? cv;
  final User user;
  final List<DoctorSpeciality> doctorSpecialities;
  final List<DoctorAvailability> doctorAvailabilities;
  final List<Appointment> appointments;
  final List<Education> educations;
  final List<Experience> experiences;
  final List<Review> reviews;

  Doctor({
    String? doctorId,
    required this.userId,
    required this.qualifications,
    required this.biography,
    this.doctorStatus = DoctorStatus.Active,
    this.isVerified = false,
    required this.doctorPreferenceId,
    this.doctorPreference,
    required this.cvId,
    this.cv,
    required this.user,
    List<DoctorSpeciality>? doctorSpecialities,
    List<DoctorAvailability>? doctorAvailabilities,
    List<Appointment>? appointments,
    List<Education>? educations,
    List<Experience>? experiences,
    List<Review>? reviews,
  })  : doctorId = doctorId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        // const Uuid().v4(),
        doctorSpecialities = doctorSpecialities ?? [],
        doctorAvailabilities = doctorAvailabilities ?? [],
        appointments = appointments ?? [],
        educations = educations ?? [],
        experiences = experiences ?? [],
        reviews = reviews ?? [];

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctorId: json['doctorId'] as String?,
      userId: json['userId'] as String,
      qualifications: json['qualifications'] as String,
      biography: json['biography'] as String,
      doctorStatus: DoctorStatus.values.firstWhere(
        (e) => e.name == json['doctorStatus'],
        orElse: () => DoctorStatus.Active,
      ),
      isVerified: json['isVerified'] as bool? ?? false,
      doctorPreferenceId: json['doctorPreferenceId'] as String,
      doctorPreference: json['doctorPreference'] != null
          ? DoctorPreference.fromJson(
              json['doctorPreference'] as Map<String, dynamic>)
          : null,
      cvId: json['cvId'] as String,
      cv: json['cv'] != null
          ? FileModel.fromJson(json['cv'] as Map<String, dynamic>)
          : null,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      doctorSpecialities: (json['doctorSpecialities'] as List<dynamic>?)
          ?.map((e) => DoctorSpeciality.fromJson(e as Map<String, dynamic>))
          .toList(),
      doctorAvailabilities: (json['doctorAvailabilities'] as List<dynamic>?)
          ?.map((e) => DoctorAvailability.fromJson(e as Map<String, dynamic>))
          .toList(),
      appointments: (json['appointments'] as List<dynamic>?)
          ?.map((e) => Appointment.fromJson(e as Map<String, dynamic>))
          .toList(),
      educations: (json['educations'] as List<dynamic>?)
          ?.map((e) => Education.fromJson(e as Map<String, dynamic>))
          .toList(),
      experiences: (json['experiences'] as List<dynamic>?)
          ?.map((e) => Experience.fromJson(e as Map<String, dynamic>))
          .toList(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': doctorId,
      'userId': userId,
      'qualifications': qualifications,
      'biography': biography,
      'doctorStatus': doctorStatus.name,
      'isVerified': isVerified,
      'doctorPreferenceId': doctorPreferenceId,
      'doctorPreference': doctorPreference?.toJson(),
      'cvId': cvId,
      'cv': cv?.toJson(),
      'user': user.toJson(),
      'doctorSpecialities': doctorSpecialities.map((e) => e.toJson()).toList(),
      'doctorAvailabilities':
          doctorAvailabilities.map((e) => e.toJson()).toList(),
      'appointments': appointments.map((e) => e.toJson()).toList(),
      'educations': educations.map((e) => e.toJson()).toList(),
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }
}
