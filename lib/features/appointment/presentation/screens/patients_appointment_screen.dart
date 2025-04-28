import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import '../widgets/appointment_widgets.dart';

class PatientsAppointmentScreen extends StatefulWidget {
  const PatientsAppointmentScreen({super.key});

  @override
  State<PatientsAppointmentScreen> createState() =>
      _PatientsAppointmentScreenState();
}

class _PatientsAppointmentScreenState extends State<PatientsAppointmentScreen> {
  String? selectedSpecialty;
  String? selectedDoctor;
  final List<String> timeSlots = ["9:00 AM", "1:00 PM", "4:00 PM"];
  int? selectedTimeSlotIndex;
  DateTime? selectedDate;
  bool isOnline = true;

  final List<String> specialties = ["Cardiology", "Dentistry", "Neurology"];
  final Map<String, List<String>> doctorsBySpecialty = {
    "Cardiology": ["Dr. Smith", "Dr. Johnson"],
    "Dentistry": ["Dr. Brown", "Dr. Miller"],
    "Neurology": ["Dr. Wilson", "Dr. Davis"],
  };

  final List<Map<String, dynamic>> upcomingAppointments = [
    {
      "name": "Dr. Smith",
      "date": "May 10, 3:00 PM",
      "type": "Virtual",
      "specialty": "Cardiology"
    },
    {
      "name": "Dr. Johnson",
      "date": "May 15, 11:00 AM",
      "type": "Physical",
      "specialty": "Dentistry"
    },
  ];

  final List<Map<String, dynamic>> pastAppointments = [
    {
      "name": "Dr. Brown",
      "date": "April 20, 2:00 PM",
      "type": "Virtual",
      "rated": false,
      "specialty": "Cardiology"
    },
    {
      "name": "Dr. Miller",
      "date": "April 5, 10:00 AM",
      "type": "Physical",
      "rated": true,
      "specialty": "Dentistry"
    },
  ];

  /// Function to pick a date from calendar
  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() => selectedDate = pickedDate);
    }
  }

  /// Function to book an appointment
  void _bookAppointment() {
    if (selectedSpecialty == null ||
        selectedDoctor == null ||
        selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all details!")),
      );
      return;
    }

    setState(() {
      upcomingAppointments.add({
        "doctor": selectedDoctor,
        "date":
            "${selectedDate!.month}/${selectedDate!.day}, ${selectedDate!.year}",
        "type": isOnline ? "Virtual" : "Physical",
        "specialty": selectedSpecialty
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Appointment booked with $selectedDoctor!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: _buildAppBar(),
      // drawer: const Drawer(), // Example placeholder for drawer
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildBookAppointmentSection(),
            const SizedBox(height: 20),
            const Text(
              "Upcoming Appointments",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...upcomingAppointments
                .map((appointment) =>
                _buildUpcomingAppointmentCard(context, appointment))
                .toList(),
            // _buildUpcomingAppointmentsSection(upcomingAppointments),
            const SizedBox(height: 16),
            // Appointment History Section
            const Text(
              "Appointment History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildHistoryFilter(context),
            const SizedBox(height: 8),
            ...pastAppointments
                .map((appointment) =>
                _buildHistoryAppointmentCard(context, appointment))
                .toList(),
            // _buildAppointmentHistorySection(pastAppointments),
          ],
        ),
      ),
    );
  }


  /// Builds the Book Appointment section.
  Widget _buildBookAppointmentSection() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            "Book Appointment",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Specialty Dropdown with outlined border.
          DropdownButtonFormField<String>(
            value: selectedSpecialty,
            decoration: InputDecoration(
              fillColor: AppColors.surface,
              filled: true,
              labelText: "Select Specialty",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: specialties.map((spec) {
              return DropdownMenuItem(value: spec, child: Text(spec));
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSpecialty = value;
                selectedDoctor = null;
              });
            },
          ),
          const SizedBox(height: 12),
          // Doctor Dropdown with outlined border.
          DropdownButtonFormField<String>(
            value: selectedDoctor,
            decoration: InputDecoration(
              fillColor: AppColors.surface,
              filled: true,
              labelText: "Select Doctor",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: (selectedSpecialty != null)
                ? doctorsBySpecialty[selectedSpecialty]!
                    .map(
                        (doc) => DropdownMenuItem(value: doc, child: Text(doc)))
                    .toList()
                : [],
            onChanged: (value) {
              setState(() => selectedDoctor = value);
            },
          ),
          const SizedBox(height: 12),
          // Row 3: Toggle for Online / Physical appointment.
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isOnline = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isOnline ? AppColors.primary : AppColors.surface,
                  ),
                  child: Text(
                    "Virtual",
                    style: TextStyle(
                      color: isOnline ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isOnline = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        !isOnline ? AppColors.primary : AppColors.surface,
                  ),
                  child: Text(
                    "Physical",
                    style: TextStyle(
                      color: !isOnline ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Row 4: Time Slot Selection using ChoiceChips.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(timeSlots.length, (index) {
              return ChoiceChip(
                label: Text(timeSlots[index]),
                selected: selectedTimeSlotIndex == index,
                onSelected: (bool selected) {
                  setState(() {
                    selectedTimeSlotIndex = selected ? index : null;
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 12),
          // Row 5: Date Picker & "Book Now" Button
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _selectDate,
                  child: Text(selectedDate != null
                      ? "Date: ${selectedDate!.month}/${selectedDate!.day}"
                      : "Pick Date"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _bookAppointment,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text(
                    "Book Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointmentCard(BuildContext context, Map<String, dynamic> appointment) {
    return AppointmentSection(
      title: 'Upcoming Appointments',
      appointments: [Appointment.fromMap(appointment)],
      isUpcoming: true,
      onPrimaryAction: (apt) {/* reschedule */},
      onSecondaryAction: (apt) {/* cancel */},
    );
  }

  Widget _buildHistoryAppointmentCard(BuildContext context, appointment) {
    return AppointmentSection(
      title: 'Upcoming Appointments',
      appointments: [Appointment.fromMap(appointment)],
      isUpcoming: false,
      onPrimaryAction: (apt) {/* reschedule */},
      onSecondaryAction: (apt) {/* cancel */},
    );
  }

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
