import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/doctor.dart';
import '../../data/repositories/doctor_repository.dart';

// Provider for DoctorRepository.
final doctorRepositoryProvider = Provider<DoctorRepository>((ref) {
  return DoctorRepository();
});

// A FutureProvider.family that fetches doctor data based on a userId.
final doctorProvider = FutureProvider.family<Doctor, String>((ref, userId) async {
  final repository = ref.watch(doctorRepositoryProvider);
  return repository.fetchDoctorForUser(userId);
});
