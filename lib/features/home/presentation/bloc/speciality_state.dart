import 'package:e_health_system/models/speciality.dart';
import 'package:equatable/equatable.dart';

abstract class SpecialityState extends Equatable {
  @override
  List<Object?> get props => [];
}

// Initial state before loading anything
class SpecialityInitial extends SpecialityState {}

// Loading state when fetching data
class SpecialityLoading extends SpecialityState {}

// Loaded state containing all specialities
class SpecialityLoaded extends SpecialityState {
  final List<Speciality> specialities;

  SpecialityLoaded({required this.specialities});

  @override
  List<Object?> get props => [specialities];
}

// Loaded state containing a single speciality
class SpecialityByIdLoaded extends SpecialityState {
  final Speciality speciality;

  SpecialityByIdLoaded({required this.speciality});

  @override
  List<Object?> get props => [speciality];
}

// Error state when fetching or modifying specialities fails
class SpecialityError extends SpecialityState {
  final String message;

  SpecialityError({required this.message});

  @override
  List<Object?> get props => [message];
}
