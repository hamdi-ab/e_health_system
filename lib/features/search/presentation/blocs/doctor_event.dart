import 'package:e_health_system/models/doctor.dart';
import 'package:equatable/equatable.dart'; // Adjust the path as needed.

abstract class DoctorState extends Equatable {
  const DoctorState();

  @override
  List<Object?> get props => [];
}

/// The initial state before any action.
class DoctorInitial extends DoctorState {}

/// State when doctors are being loaded.
class DoctorLoading extends DoctorState {}

/// State when doctors have been loaded successfully.
class DoctorLoaded extends DoctorState {
  final List<Doctor> doctors;

  const DoctorLoaded({required this.doctors});

  @override
  List<Object?> get props => [doctors];
}

/// State when an error occurs while fetching doctors.
class DoctorError extends DoctorState {
  final String message;

  const DoctorError({required this.message});

  @override
  List<Object?> get props => [message];
}
