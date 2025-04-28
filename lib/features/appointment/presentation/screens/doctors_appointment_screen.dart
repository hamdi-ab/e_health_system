import 'package:flutter/material.dart';
import 'package:e_health_system/core/constants/app_colors.dart';

import '../widgets/appointment_widgets.dart'; // Replace with your theme/colors file if needed.

class DoctorAppointmentScreen extends StatelessWidget {
  const DoctorAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for demonstration.
    final List<Map<String, dynamic>> todayQueueAppointments = [
      {
        "name": "John Doe",
        "time": "09:00 AM",
        "type": "Online",
        "status": "Booked",
      },
      {
        "name": "Jane Smith",
        "time": "09:30 AM",
        "type": "Physical",
        "status": "Booked",
      },
    ];

    final List<Map<String, dynamic>> upcomingAppointments = [
      {
        "name": "Alice Brown",
        "date": "Apr 27, 2:00 PM",
        "type": "Physical",
      },
      {
        "name": "Bob White",
        "date": "Apr 29, 4:15 PM",
        "type": "Online",
      },
    ];

    final List<Map<String, dynamic>> historyAppointments = [
      {
        "name": "Carol Grey",
        "date": "Apr 18, 2025",
        "status": "Completed",
        "type": "Online",
      },
      {
        "name": "Dan Blue",
        "date": "Apr 10, 2025",
        "status": "No Show",
        "type": "Physical",
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today's Queue Section
            const Text(
              "Today’s Queue",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...todayQueueAppointments
                .map((appointment) =>
                _buildTodayQueueCard(context, appointment))
                ,
            const SizedBox(height: 16),
            // Upcoming Appointments Section
            const Text(
              "Upcoming Appointments",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...upcomingAppointments
                .map((appointment) =>
                _buildUpcomingAppointmentCard(context, appointment))
                ,
            const SizedBox(height: 16),
            // Appointment History Section
            const Text(
              "Appointment History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildHistoryFilter(context),
            const SizedBox(height: 8),
            ...historyAppointments
                .map((appointment) =>
                _buildHistoryAppointmentCard(context, appointment))
                ,
          ],
        ),
      ),
    );
  }

  Widget _buildTodayQueueCard(BuildContext context, Map<String, dynamic> appointment) {
    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Info Section
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.green.shade200,
                      child: Text(
                        appointment["name"][0],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appointment["name"],
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            appointment["type"],
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          appointment["time"],
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getStatusColor(appointment["status"]).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            appointment["status"],
                            style: TextStyle(
                              color: _getStatusColor(appointment["status"]),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Action Buttons Section: Two primary buttons "Start" and "Reschedule"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // You might add a status indicator or leave this empty if not needed.
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                            child: FilledButton.tonal(
                              onPressed: () => _handleStartAction(appointment),
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(100, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: const Text("Start"),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton(
                              onPressed: () => _handleRescheduleAction(appointment),
                              style: FilledButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                minimumSize: const Size(100, 40),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: Text(
                                "Reschedule",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Popup Menu Button Positioned at the top right corner
        Positioned(
          top: 8,
          right: 8,
          child: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == "Complete") {
                _handleCompleteAction(appointment);
              } else if (value == "Cancel") {
                _handleCancel(appointment);
              } else if (value == "No Show") {
                _handleNoShow(appointment);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: "Complete",
                child: ListTile(
                  leading: Icon(Icons.check),
                  title: Text("Complete"),
                ),
              ),
              const PopupMenuItem(
                value: "Cancel",
                child: ListTile(
                  leading: Icon(Icons.cancel),
                  title: Text("Cancel Appointment"),
                ),
              ),
              const PopupMenuItem(
                value: "No Show",
                child: ListTile(
                  leading: Icon(Icons.person_off_outlined),
                  title: Text("No Show"),
                ),
              ),
            ],
            icon: const Icon(
              Icons.more_horiz,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  /// Example helper function for determining status color.
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// Placeholder action functions.
  void _handleStartAction(Map<String, dynamic> appointment) {
    // Implement the start action logic.
  }

  void _handleRescheduleAction(Map<String, dynamic> appointment) {
    // Implement the reschedule action logic.
  }

  void _handleCompleteAction(Map<String, dynamic> appointment) {
    // Implement the complete action logic.
  }

  void _handleCancel(Map<String, dynamic> appointment) {
    // Implement the cancel action logic.
  }

  void _handleNoShow(Map<String, dynamic> appointment) {
    // Implement the no-show action logic.
  }



  /// Upcoming Appointment Card
  Widget _buildUpcomingAppointmentCard(
      BuildContext context, Map<String, dynamic> appointment) {
    return AppointmentSection(
      title: 'Upcoming Appointments',
      appointments: [Appointment.fromMap(appointment)],
      isDoctor: true,
      isUpcoming: true,
      onPrimaryAction: (apt) { /* reschedule */ },
      onSecondaryAction: (apt) { /* cancel */ },
    );
  }

  /// Appointment History Card
  Widget _buildHistoryAppointmentCard(
      BuildContext context, Map<String, dynamic> appointment) {
    return AppointmentSection(
      title: 'Upcoming Appointments',
      appointments: [Appointment.fromMap(appointment)],
      isDoctor: true,
      isUpcoming: false,
      onPrimaryAction: (apt) { /* reschedule */ },
      onSecondaryAction: (apt) { /* cancel */ },
    );
  }

  /// History Filter Widget
  Widget _buildHistoryFilter(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Filter by date: ",
          style: TextStyle(fontSize: 14),
        ),
        OutlinedButton(
          onPressed: () {
            // TODO: Open date range picker.
          },
          child: const Text("─── Select Range ───▼"),
        )
      ],
    );
  }
}
