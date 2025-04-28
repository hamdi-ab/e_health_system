import 'package:flutter/material.dart';
import 'package:e_health_system/core/constants/app_colors.dart';

enum AppointmentStatus { upcoming, completed, cancelled }

/// Model representing an appointment entry.
class Appointment {
  final String name;
  final String date;
  final String type;
  final String? specialty;
  final bool? rated;// Keep for patient side
  final AppointmentStatus status;

  Appointment({
    required this.name,
    required this.date,
    required this.type,
    this.specialty,
    this.rated = false,
    this.status = AppointmentStatus.upcoming,
  });

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      name: map["name"],
      date: map["date"],
      type: map["type"],
      specialty: map["specialty"],
      rated: map["rated"] ?? false,
      status: AppointmentStatus.upcoming,
    );
  }


}

/// A reusable card widget for displaying appointment details.
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.isUpcoming,
    required this.isDoctor,
    this.onPrimaryAction,
    this.onSecondaryAction,
  }) : super(key: key);

  final Appointment appointment;
  final bool isUpcoming;
  final bool isDoctor; // <-- NEW
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade200,
                  child: Text(
                    appointment.name[0],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.date,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      appointment.type,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (!isDoctor) // Show specialty ONLY for patient side
                      Text(
                        appointment.specialty!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PrimaryAction(
                    isUpcoming: isUpcoming,
                    isDoctor: isDoctor,
                    appointment: appointment,
                    rated: appointment.rated!,
                    onPressed: onPrimaryAction,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSecondaryAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isUpcoming ? Colors.red : Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    child: Text(isUpcoming ? 'Cancel' : 'View Detail'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({
    Key? key,
    required this.isUpcoming,
    required this.isDoctor,
    required this.appointment,
    required this.rated,
    this.onPressed,
  }) : super(key: key);

  final bool isUpcoming;
  final bool isDoctor;
  final Appointment appointment;
  final bool rated;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (!isUpcoming) {
      if (isDoctor) {
        // Doctor side history: show status
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Text(
            appointment.status == AppointmentStatus.completed ? 'Completed' : 'Cancelled',
            style: TextStyle(
              color: appointment.status == AppointmentStatus.completed ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (rated) {
        // Patient side and already rated
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: const Icon(Icons.star, color: Colors.amber, size: 24),
        );
      }
    }
    // Default: show a button
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: Text(isUpcoming ? 'Reschedule' : 'Rate & Review'),
    );
  }
}

/// A section widget to display a list of appointments.
class AppointmentSection extends StatelessWidget {
  const AppointmentSection({
    Key? key,
    required this.title,
    required this.appointments,
    this.isUpcoming = true,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.isDoctor = false,
  }) : super(key: key);

  final String title;
  final List<Appointment> appointments;
  final bool isUpcoming;
  final bool isDoctor;
  final void Function(Appointment)? onPrimaryAction;
  final void Function(Appointment)? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        ...appointments.map((apt) {
          return AppointmentCard(
            appointment: apt,
            isUpcoming: isUpcoming,
            isDoctor: isDoctor, // or false
            onPrimaryAction: () => onPrimaryAction?.call(apt),
            onSecondaryAction: () => onSecondaryAction?.call(apt),
          );
        }),
      ],
    );
  }
}
