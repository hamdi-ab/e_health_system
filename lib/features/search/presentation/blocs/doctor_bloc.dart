import 'package:e_health_system/features/search/data/repositories/doctor_repository.dart';
import 'package:e_health_system/models/doctor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'doctor_event.dart';
import 'doctor_state.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  final DoctorRepository doctorRepository;

  DoctorBloc({required this.doctorRepository}) : super(DoctorInitial()) {
    on<FetchDoctors>(_onFetchDoctors);
  }

  Future<void> _onFetchDoctors(
      FetchDoctors event, Emitter<DoctorState> emit) async {
    emit(DoctorLoading());
    try {
      List<Doctor> doctors;
      // If a specialityId is provided, use the filtered fetch method.
      if (event.specialityId != null && event.specialityId!.isNotEmpty) {
        doctors = await doctorRepository
            .fetchDoctorsBySpeciality(event.specialityId!);
      } else {
        doctors = await doctorRepository.fetchDoctors();
      }
      emit(DoctorLoaded(doctors: doctors));
    } catch (e) {
      emit(DoctorError(message: e.toString()));
    }
  }
}
