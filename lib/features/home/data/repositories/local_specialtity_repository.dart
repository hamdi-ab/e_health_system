import 'package:e_health_system/models/speciality.dart';

class LocalSpecialityRepository {
  final List<Speciality> _specialities = [
    Speciality(
      specialityId: "cardio-001",
      specialityName: "Cardiology",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      doctorSpecialities: [],
    ),
    Speciality(
      specialityId: "neuro-001",
      specialityName: "Neurology",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      doctorSpecialities: [],
    ),
  ];

  // Fetch all specialities
  Future<List<Speciality>> getSpecialities() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulated delay
    return _specialities;
  }

  // Fetch a speciality by ID
  Future<Speciality?> getSpecialityById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulated delay
    try {
      return _specialities.firstWhere((s) => s.specialityId == id);
    } catch (e) {
      return null; // If not found, return null
    }
  }

  // Add a new speciality
  Future<void> addSpeciality(Speciality speciality) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulated delay
    _specialities.add(speciality);
  }

  // Update an existing speciality
  Future<void> updateSpeciality(String id, String newName) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulated delay
    final speciality = _specialities.firstWhere((s) => s.specialityId == id);
    speciality.specialityName = newName;
    speciality.updatedAt = DateTime.now();
  }

  // Delete a speciality
  Future<void> deleteSpeciality(String id) async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulated delay
    _specialities.removeWhere((s) => s.specialityId == id);
  }
}
