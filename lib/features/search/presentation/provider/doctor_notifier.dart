import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/doctor.dart';
import '../../data/repositories/doctor_repository.dart';

// First, create a Provider for your repository so that you can reference it.
final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  return DoctorRepository();
});

// Now, create a StateNotifierProvider that handles the list of doctors asynchronously.
final doctorsProvider =
StateNotifierProvider<DoctorsNotifier, AsyncValue<List<Doctor>>>((ref) {
  final repository = ref.watch(doctorRepositoryProvider);
  return DoctorsNotifier(repository);
});

class DoctorsNotifier extends StateNotifier<AsyncValue<List<Doctor>>> {
  final DoctorRepository repository;

  DoctorsNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    try {
      final doctors = await repository.fetchDoctors();
      state = AsyncValue.data(doctors);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
