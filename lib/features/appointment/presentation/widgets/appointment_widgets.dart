import 'package:e_health_system/features/appointment/domain/entities/appointment.dart';
import 'package:e_health_system/shared/enums/appointment_status.dart';
import 'package:flutter/material.dart';

/// A reusable card widget for displaying appointment details.
class AppointmentCard extends StatelessWidget {
  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.isUpcoming,
    required this.isDoctor,
    this.onPrimaryAction,
    this.onSecondaryAction,
  });

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
                    appointment
                        .doctorId[0], // Use doctorId for avatar placeholder
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
                        "Dr. ${appointment.doctorId}", // Assuming doctorId is a placeholder for name
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment.appointmentTime
                            .format(context), // Corrected formatting
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
                      appointment.appointmentType
                          .name, // Extracts only the string name
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (!isDoctor) // Show specialty ONLY for patient side
                      Text(
                        appointment
                            .doctorId, // Assuming patientId represents name/details
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
                    rated:
                        true, // Assuming rated logic can be handled separately
                    onPressed: onPrimaryAction,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onSecondaryAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isUpcoming ? Colors.red : Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
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
    required this.isUpcoming,
    required this.isDoctor,
    required this.appointment,
    required this.rated,
    this.onPressed,
  });

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
            appointment.status == AppointmentStatus.Completed
                ? 'Completed'
                : 'Cancelled',
            style: TextStyle(
              color: appointment.status == AppointmentStatus.Completed
                  ? Colors.green
                  : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      } else if (rated) {
        // Patient side and already rated
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: const Row(
            children: [
              Text(
                "★★★★★",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
              SizedBox(width: 5), // Adds some spacing
              Text(
                "(48)",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
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
    super.key,
    required this.title,
    required this.appointments,
    this.isUpcoming = true,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.isDoctor = false,
  });

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
