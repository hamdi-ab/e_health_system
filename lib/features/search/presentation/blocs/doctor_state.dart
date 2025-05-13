import 'package:equatable/equatable.dart';

abstract class DoctorEvent extends Equatable {
  const DoctorEvent();
  @override
  List<Object?> get props => [];
}

/// Event to fetch doctors. If [specialityId] is provided, only doctors
/// with the given specialty will be returned.
class FetchDoctors extends DoctorEvent {
  final String? specialityId;

  const FetchDoctors({this.specialityId});

  @override
  List<Object?> get props => [specialityId];
}
