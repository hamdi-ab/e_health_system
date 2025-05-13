import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/local_appointment_repository.dart';
import 'appointment_event.dart';
import 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final LocalAppointmentRepository appointmentRepository;

  AppointmentBloc({required this.appointmentRepository})
      : super(AppointmentInitial()) {
    on<LoadAppointments>((event, emit) async {
      emit(AppointmentLoading());
      try {
        final appointments = await appointmentRepository.getAppointments();
        emit(AppointmentLoaded(appointments: appointments));
      } catch (e) {
        emit(AppointmentError(message: e.toString()));
      }
    });

    on<LoadAppointmentsByDoctor>((event, emit) async {
      emit(AppointmentLoading());
      try {
        final appointments = await appointmentRepository
            .getAppointmentsByDoctorId(event.doctorId);
        emit(AppointmentLoaded(appointments: appointments));
      } catch (e) {
        emit(AppointmentError(message: e.toString()));
      }
    });

    on<LoadAppointmentsByPatient>((event, emit) async {
      emit(AppointmentLoading());
      try {
        final appointments = await appointmentRepository
            .getAppointmentsByPatientId(event.patientId);
        emit(AppointmentLoaded(appointments: appointments));
      } catch (e) {
        emit(AppointmentError(message: e.toString()));
      }
    });

    on<CreateAppointment>((event, emit) async {
      emit(AppointmentLoading());
      try {
        await appointmentRepository.createAppointment(
          event.doctorId,
          event.patientId,
          event.appointmentDate,
          event.appointmentTime,
          event.appointmentType,
        );
        final appointments = await appointmentRepository.getAppointments();
        emit(AppointmentLoaded(appointments: appointments));
      } catch (e) {
        emit(AppointmentError(message: e.toString()));
      }
    });
  }
}
