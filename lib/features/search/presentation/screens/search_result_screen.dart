import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/doctor_notifier.dart';
import '../widgets/doctor_card.dart';

class SearchResultScreen extends ConsumerWidget {
  final String query;

  const SearchResultScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the doctorsProvider to get the state
    final doctorsAsync = ref.watch(doctorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "$query"'),
      ),
      body: doctorsAsync.when(
        data: (doctors) {
          // Filter the doctors based on the query (update criteria as needed)
          final filteredDoctors = doctors.where((doctor) {
            final searchLower = query.toLowerCase();
            return doctor.qualifications.toLowerCase().contains(searchLower) ||
                doctor.biography.toLowerCase().contains(searchLower);
          }).toList();

          if (filteredDoctors.isEmpty) {
            return const Center(child: Text('No results found'));
          }

          return ListView.builder(
            itemCount: filteredDoctors.length,
            itemBuilder: (context, index) {
              return DoctorCard(doctor: filteredDoctors[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Error: ${error.toString()}')),
      ),
    );
  }
}
