import 'package:e_health_system/features/home/data/repositories/local_specialtity_repository.dart';
import 'package:e_health_system/models/speciality.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'speciality_event.dart';
import 'speciality_state.dart';

class SpecialityBloc extends Bloc<SpecialityEvent, SpecialityState> {
  final LocalSpecialityRepository specialityRepository;

  SpecialityBloc({required this.specialityRepository})
      : super(SpecialityInitial()) {
    on<LoadSpecialities>((event, emit) async {
      emit(SpecialityLoading());
      try {
        final specialities = await specialityRepository.getSpecialities();
        emit(SpecialityLoaded(specialities: specialities));
      } catch (e) {
        emit(SpecialityError(message: e.toString()));
      }
    });

    on<LoadSpecialityById>((event, emit) async {
      emit(SpecialityLoading());
      try {
        final speciality =
            await specialityRepository.getSpecialityById(event.specialityId);
        if (speciality != null) {
          emit(SpecialityByIdLoaded(speciality: speciality));
        } else {
          emit(SpecialityError(message: "Speciality not found"));
        }
      } catch (e) {
        emit(SpecialityError(message: e.toString()));
      }
    });

    on<AddSpeciality>((event, emit) async {
      try {
        await specialityRepository.addSpeciality(
          Speciality(
            specialityId:
                DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
            specialityName: event.specialityName,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
        final specialities = await specialityRepository.getSpecialities();
        emit(SpecialityLoaded(specialities: specialities));
      } catch (e) {
        emit(SpecialityError(message: e.toString()));
      }
    });

    on<UpdateSpeciality>((event, emit) async {
      try {
        await specialityRepository.updateSpeciality(
            event.specialityId, event.newName);
        final specialities = await specialityRepository.getSpecialities();
        emit(SpecialityLoaded(specialities: specialities));
      } catch (e) {
        emit(SpecialityError(message: e.toString()));
      }
    });

    on<DeleteSpeciality>((event, emit) async {
      try {
        await specialityRepository.deleteSpeciality(event.specialityId);
        final specialities = await specialityRepository.getSpecialities();
        emit(SpecialityLoaded(specialities: specialities));
      } catch (e) {
        emit(SpecialityError(message: e.toString()));
      }
    });
  }
}
