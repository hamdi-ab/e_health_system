// File: lib/models/doctor_availability.dart

import 'doctor.dart';
import '../shared/enums/day_of_week.dart'; // Adjust the path as needed

class DoctorAvailability {
  final String doctorAvailabilityId;
  final String doctorId;
  final DayOfWeek availableDay;
  final String startTime; // Stored as HH:mm, e.g., "06:00"
  final String endTime; // Stored as HH:mm, e.g., "18:00"
  final Doctor? doctor;

  DoctorAvailability({
    required this.doctorAvailabilityId,
    required this.doctorId,
    required this.availableDay,
    required this.startTime,
    required this.endTime,
    this.doctor,
  });

  factory DoctorAvailability.fromJson(Map<String, dynamic> json) {
    return DoctorAvailability(
      doctorAvailabilityId: json['doctorAvailabilityId'] as String,
      doctorId: json['doctorId'] as String,
      availableDay: DayOfWeek.values.firstWhere(
        (e) =>
            e.toString().split('.').last.toLowerCase() ==
            (json['availableDay'] as String).toLowerCase(),
      ),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      doctor: Doctor.fromJson(json['doctor'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorAvailabilityId': doctorAvailabilityId,
      'doctorId': doctorId,
      'availableDay': availableDay.toString().split('.').last,
      'startTime': startTime,
      'endTime': endTime,
      'doctor': doctor?.toJson(),
    };
  }
}
