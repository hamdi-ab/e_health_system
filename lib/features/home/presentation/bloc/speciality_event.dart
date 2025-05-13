import 'package:equatable/equatable.dart';

abstract class SpecialityEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event to load all specialities
class LoadSpecialities extends SpecialityEvent {}

// Event to load a speciality by ID
class LoadSpecialityById extends SpecialityEvent {
  final String specialityId;

  LoadSpecialityById({required this.specialityId});

  @override
  List<Object?> get props => [specialityId];
}

// Event to add a new speciality
class AddSpeciality extends SpecialityEvent {
  final String specialityName;

  AddSpeciality({required this.specialityName});

  @override
  List<Object?> get props => [specialityName];
}

// Event to update a speciality
class UpdateSpeciality extends SpecialityEvent {
  final String specialityId;
  final String newName;

  UpdateSpeciality({required this.specialityId, required this.newName});

  @override
  List<Object?> get props => [specialityId, newName];
}

// Event to delete a speciality
class DeleteSpeciality extends SpecialityEvent {
  final String specialityId;

  DeleteSpeciality({required this.specialityId});

  @override
  List<Object?> get props => [specialityId];
}
