import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:e_health_system/features/home/presentation/screens/doctor_profile_screen.dart';
import 'package:e_health_system/features/search/presentation/blocs/doctor_bloc.dart';
import 'package:e_health_system/features/search/presentation/blocs/doctor_event.dart';
import 'package:e_health_system/features/search/presentation/blocs/doctor_state.dart';
import 'package:e_health_system/models/doctor.dart';
import 'package:e_health_system/models/speciality.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SpecialtyDoctorsScreen extends StatefulWidget {
  final String specialtyId;
  final String specialtyName;
  final IconData specialtyIcon;

  const SpecialtyDoctorsScreen({
    Key? key,
    required this.specialtyId,
    required this.specialtyName,
    required this.specialtyIcon,
  }) : super(key: key);

  @override
  State<SpecialtyDoctorsScreen> createState() => _SpecialtyDoctorsScreenState();
}

class _SpecialtyDoctorsScreenState extends State<SpecialtyDoctorsScreen> {
  @override
  void initState() {
    super.initState();
    // Load doctors by specialty when screen initializes
    BlocProvider.of<DoctorBloc>(context).add(
      FetchDoctors(specialityId: widget.specialtyId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              widget.specialtyIcon,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text('${widget.specialtyName} Doctors'),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _buildDoctorsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.specialtyName} Specialists',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Find experienced doctors specialized in this field',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Search by doctor name...",
                prefixIcon: Icon(Icons.search, color: AppColors.primary),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsList() {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        if (state is DoctorLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is DoctorError) {
          return Center(
            child: Text('Error: ${state.message}'),
          );
        } else if (state is DoctorLoaded) {
          final doctors = state.doctors;

          if (doctors.isEmpty) {
            return const Center(
              child: Text(
                'No doctors found for this specialty',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              return _buildDoctorCard(doctors[index]);
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildDoctorCard(Doctor doctor) {
    final firstName = doctor.user.firstName;
    final lastName = doctor.user.lastName;
    final fullName = 'Dr. $firstName $lastName';

    // Calculate average rating
    double averageRating = 0;
    if (doctor.reviews.isNotEmpty) {
      final totalRating =
          doctor.reviews.fold(0.0, (sum, review) => sum + review.starRating);
      averageRating = totalRating / doctor.reviews.length;
    }

    return Card(
      elevation: 3.0,
      color: AppColors.surface,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  child: const Icon(
                    Icons.person,
                    size: 30,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        widget.specialtyName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${averageRating.toStringAsFixed(1)} (${doctor.reviews.length} reviews)',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    doctor.biography,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // View doctor's profile
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DoctorProfileScreen(
                          doctorId: doctor.doctorId,
                          doctor: doctor,
                        ),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View Profile'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // Book appointment
                    // TODO: Navigate to appointment booking
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Book'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
