import 'package:flutter/material.dart';

class AppointmentPatientScreen extends StatefulWidget {
  const AppointmentPatientScreen({super.key});

  @override
  _AppointmentPatientScreenState createState() =>
      _AppointmentPatientScreenState();
}

class _AppointmentPatientScreenState extends State<AppointmentPatientScreen> {
  // For the Book Appointment Section
  String? selectedSpecialty;
  String? selectedDoctor;
  bool isOnline = true;
  DateTime? selectedDate;
  int? selectedTimeSlotIndex;

  // Dummy values for dropdowns and time slots
  final List<String> specialties = ["Cardiology", "Neurology", "Pediatrics"];
  final Map<String, List<String>> doctorsBySpecialty = {
    "Cardiology": ["Dr. John Doe", "Dr. Jane Smith"],
    "Neurology": ["Dr. Albert", "Dr. Smith"],
    "Pediatrics": ["Dr. Green", "Dr. Brown"],
  };
  final List<String> timeSlots = [
    "10:00 - 10:30",
    "11:00 - 11:30",
    "12:00 - 12:30",
    "2:00 - 2:30",
    "3:00 - 3:30",
    "4:00 - 4:30"
  ];

  /// Opens a date picker to choose an appointment date.
  Future<void> _selectDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  /// Dummy method to simulate booking the appointment.
  void _bookAppointment() {
    // Normally, you’d call your backend here.
    print("Booking appointment:");
    print("Doctor: $selectedDoctor, Specialty: $selectedSpecialty");
    print("Mode: ${isOnline ? "Virtual" : "Physical"}");
    print("Date: $selectedDate");
    print(
        "Time Slot: ${selectedTimeSlotIndex != null ? timeSlots[selectedTimeSlotIndex!] : "None"}");
  }

  /// Builds the Appointment Queue section (placeholder).
  Widget _buildAppointmentQueueSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            "Your Appointment Queue",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.grey[300],
            child: const Center(child: Text("Appointment Card Placeholder")),
          ),
          Container(
            height: 100,
            margin: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.grey[300],
            child: const Center(child: Text("Appointment Card Placeholder")),
          ),
        ],
      ),
    );
  }

  /// Builds the "Book Appointment" section as described.
  Widget _buildBookAppointmentSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          // Header: Book New Appointment
          const Text(
            "Book New Appointment",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // 1. Select Doctor
          const Text("1. Select Doctor:", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedDoctor,
            decoration: InputDecoration(
              fillColor: Colors.grey[200],
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
                      (doc) => DropdownMenuItem(
                        value: doc,
                        child: Text(doc),
                      ),
                    )
                    .toList()
                : [],
            onChanged: (value) {
              setState(() {
                selectedDoctor = value;
              });
            },
          ),
          const SizedBox(height: 16),
          // 2. Choose Date
          const Text("2. Choose Date:", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _selectDate,
            child: Text(selectedDate != null
                ? "Date: ${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}"
                : "Pick Date"),
          ),
          const SizedBox(height: 16),
          // 3. Check Availability Button
          const Text("3. Check Availability:", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // Trigger API call to get available slots (for now, it assumes 'timeSlots' is ready)
              // In a full app, you might update state here.
              print("Checking availability...");
            },
            child: const Text("Check Availability"),
          ),
          const SizedBox(height: 16),
          // Available Time Slots displayed as a Grid
          const Text("Available Time Slots:", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: timeSlots.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns per row
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.5,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedTimeSlotIndex = index;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedTimeSlotIndex == index
                        ? Colors.blue
                        : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    timeSlots[index],
                    style: TextStyle(
                      color: selectedTimeSlotIndex == index
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          // 4. Appointment Type: Toggle Online / Physical
          const Text("4. Appointment Type:", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
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
                    backgroundColor: isOnline ? Colors.blue : Colors.grey[300],
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
                    backgroundColor: !isOnline ? Colors.blue : Colors.grey[300],
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
          const SizedBox(height: 16),
          // 5. Confirm Booking Button
          const Text("5. Confirm Booking:", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _bookAppointment,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text(
              "Book Appointment",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Two tabs: Appointment Queue and Book Appointment
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Appointments"),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                // Open menu drawer or navigate to menu.
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Appointment Queue"),
              Tab(text: "Book Appointment"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildAppointmentQueueSection(),
            _buildBookAppointmentSection(),
          ],
        ),
      ),
    );
  }
}
