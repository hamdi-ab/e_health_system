import 'package:e_health_system/features/appointment/domain/entities/appointment.dart';

abstract class AppointmentState {}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoaded extends AppointmentState {
  final List<Appointment> appointments;

  AppointmentLoaded({required this.appointments});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppointmentLoaded && other.appointments == appointments);

  @override
  int get hashCode => appointments.hashCode;
}

class AppointmentError extends AppointmentState {
  final String message;

  AppointmentError({required this.message});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppointmentError && other.message == message);

  @override
  int get hashCode => message.hashCode;
}
