// lib/features/search/presentation/widgets/doctor_card.dart

import 'package:flutter/material.dart';
import '../../../../models/doctor.dart'; // Adjust the import path based on your folder structure

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // A CircleAvatar as a placeholder (e.g., showing the initial letter of the qualification)
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
              child: Text(
                doctor.qualifications.substring(0, 1).toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(width: 16.0),
            // Doctor details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.qualifications,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.biography,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            // Show a check icon if the doctor is verified
            if (doctor.isVerified)
              const Icon(
                Icons.verified,
                color: Colors.green,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
