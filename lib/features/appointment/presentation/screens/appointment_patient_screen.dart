import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppointmentPatientScreen extends StatefulWidget {
  const AppointmentPatientScreen({Key? key}) : super(key: key);

  @override
  State<AppointmentPatientScreen> createState() => _AppointmentPatientScreenState();
}

class _AppointmentPatientScreenState extends State<AppointmentPatientScreen> {
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
      "doctor": "Dr. Smith",
      "date": "May 10, 3:00 PM",
      "type": "Virtual",
      "specialty": "Cardiology"
    },
    {
      "doctor": "Dr. Johnson",
      "date": "May 15, 11:00 AM",
      "type": "Physical",
      "specialty": "Dentistry"
    },
  ];

  final List<Map<String, dynamic>> pastAppointments = [
    {
      "doctor": "Dr. Brown",
      "date": "April 20, 2:00 PM",
      "type": "Virtual",
      "rated": false,
      "specialty": "Cardiology"
    },
    {
      "doctor": "Dr. Miller",
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
    if (selectedSpecialty == null || selectedDoctor == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select all details!")),
      );
      return;
    }

    setState(() {
      upcomingAppointments.add({
        "doctor": selectedDoctor,
        "date": "${selectedDate!.month}/${selectedDate!.day}, ${selectedDate!.year}",
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
            _buildUpcomingAppointmentsSection(upcomingAppointments),
            const SizedBox(height: 20),
            _buildAppointmentHistorySection(pastAppointments),
          ],
        ),
      ),
    );
  }

  /// Builds App Bar with drawer and notification icons.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text("Appointments"),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {},
        )
      ],
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            items: (selectedSpecialty != null)
                ? doctorsBySpecialty[selectedSpecialty]!
                .map((doc) => DropdownMenuItem(value: doc, child: Text(doc)))
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
                    backgroundColor: isOnline ? AppColors.primary : AppColors.surface,
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
                    backgroundColor: !isOnline ? AppColors.primary : AppColors.surface,
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

  /// Builds the Upcoming Appointments Section.

  /// Builds the Upcoming Appointments Section.
  Widget _buildUpcomingAppointmentsSection(
      List<Map<String, dynamic>> upcomingAppointments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upcoming Appointments",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...upcomingAppointments
            .map((appointment) =>
            _buildAppointmentCard(appointment, isUpcoming: true))
            .toList(),
      ],
    );
  }

  /// Builds the Appointment History Section.
  Widget _buildAppointmentHistorySection(
      List<Map<String, dynamic>> pastAppointments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Appointment History",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...pastAppointments
            .map((appointment) =>
            _buildAppointmentCard(appointment, isUpcoming: false))
            .toList(),
      ],
    );
  }

  /// Reusable Appointment Card widget.
  /// If [isUpcoming] is true, the card shows "Reschedule" and "Cancel."
  /// If false, the left action shows either a star icon (if rated) or a "Rate & Review" button,
  /// and the right action becomes "View Detail."
  Widget _buildAppointmentCard(Map<String, dynamic> appointment,
      {required bool isUpcoming}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Information Row:
            // Contains the profile avatar, doctor's name & date,
            // and on the right a column with appointment type & specialty.
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Avatar
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blue.shade200,
                  child: Text(
                    appointment["doctor"][0], // First letter of doctor's name
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Doctor Name & Date Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment["doctor"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        appointment["date"],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right Column: Appointment Type & Specialty
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      appointment["type"],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment["specialty"],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 12),
            // Action Buttons Row.
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Left Action:
                // If upcoming -> "Reschedule" button.
                // If history -> if rated, show star icon; otherwise, show "Rate & Review" button.
                Expanded(
                  child: !isUpcoming && appointment["rated"] == true
                      ? Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 12),
                    child: const Icon(Icons.star,
                        color: Colors.amber, size: 24),
                  )
                      : ElevatedButton(
                    onPressed: () {
                      if (isUpcoming) {
                        // TODO: Handle reschedule action.
                      } else {
                        // TODO: Handle rate & review action.
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    child: Text(isUpcoming
                        ? "Reschedule"
                        : "Rate & Review"),
                  ),
                ),
                const SizedBox(width: 8),
                // Right Action:
                // Upcoming -> "Cancel" button, History -> "View Detail" button.
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (isUpcoming) {
                        // TODO: Handle cancel action.
                      } else {
                        // TODO: Handle view detail action.
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isUpcoming ? Colors.red : Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 12),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    child:
                    Text(isUpcoming ? "Cancel" : "View Detail"),
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
