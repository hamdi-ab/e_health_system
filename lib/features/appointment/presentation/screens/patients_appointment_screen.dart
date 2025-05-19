import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:e_health_system/features/appointment/presentation/blocs/appointment_bloc.dart';
import 'package:e_health_system/features/appointment/presentation/blocs/appointment_event.dart';
import 'package:e_health_system/features/appointment/presentation/blocs/appointment_state.dart';
import 'package:e_health_system/features/home/presentation/bloc/speciality_bloc.dart';
import 'package:e_health_system/features/home/presentation/bloc/speciality_event.dart';
import 'package:e_health_system/features/home/presentation/bloc/speciality_state.dart';
import 'package:e_health_system/features/search/presentation/blocs/doctor_bloc.dart';
import 'package:e_health_system/features/search/presentation/blocs/doctor_event.dart';
import 'package:e_health_system/features/search/presentation/blocs/doctor_state.dart';
import 'package:e_health_system/models/speciality.dart';
import 'package:e_health_system/shared/enums/appointment_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/appointment_widgets.dart';

class PatientsAppointmentScreen extends StatefulWidget {
  const PatientsAppointmentScreen({super.key});

  @override
  State<PatientsAppointmentScreen> createState() =>
      _PatientsAppointmentScreenState();
}

class _PatientsAppointmentScreenState extends State<PatientsAppointmentScreen> {
  Speciality? selectedSpecialty;
  String? selectedDoctor;
  final List<String> timeSlots = [
    "10:00 - 10:30",
    "11:00 - 11:30",
    "12:00 - 12:30",
    "2:00 - 2:30",
    "3:00 - 3:30",
    "4:00 - 4:30"
  ];
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
    if (selectedDoctor == null ||
        selectedDate == null ||
        selectedTimeSlotIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final timeSlotString = timeSlots[selectedTimeSlotIndex!];
    final startTimeString =
        timeSlotString.split('-')[0].trim(); // e.g., "10:00"
    final timeParts = startTimeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    BlocProvider.of<AppointmentBloc>(context).add(
      CreateAppointment(
        doctorId: selectedDoctor!,
        patientId: "pat1", // Replace with actual patient ID
        appointmentDate: selectedDate!,
        appointmentTime: TimeOfDay(
          hour: hour,
          minute: minute,
        ),

        appointmentType:
            isOnline ? AppointmentType.Online : AppointmentType.InPerson,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Dispatch the event to fetch appointments
    BlocProvider.of<AppointmentBloc>(context)
        .add(LoadAppointmentsByPatient(patientId: 'pat1'));

    BlocProvider.of<SpecialityBloc>(context).add(LoadSpecialities());
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
            _buildUpcomingAppointmentCard(context),
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
            // ...pastAppointments
            //     .map((appointment) =>
            //         _buildHistoryAppointmentCard(context, appointment))
            //     .toList(),
            // // _buildAppointmentHistorySection(pastAppointments),
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
          // DropdownButtonFormField<String>(
          //   value: selectedSpecialty,
          //   decoration: InputDecoration(
          //     fillColor: AppColors.surface,
          //     filled: true,
          //     labelText: "Select Specialty",
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     contentPadding:
          //         const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          //   ),
          //   items: specialties.map((spec) {
          //     return DropdownMenuItem(value: spec, child: Text(spec));
          //   }).toList(),
          //   onChanged: (value) {
          //     setState(() {
          //       selectedSpecialty = value;
          //       selectedDoctor = null;
          //     });
          //   },
          // ),
          _buildSpecialityDropdown(),
          const SizedBox(height: 12),
          // Doctor Dropdown with outlined border.
          _buildDoctorDropdown(),
          // DropdownButtonFormField<String>(
          //   value: selectedDoctor,
          //   decoration: InputDecoration(
          //     fillColor: AppColors.surface,
          //     filled: true,
          //     labelText: "Select Doctor",
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //     contentPadding:
          //         const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          //   ),
          //   items: (selectedSpecialty != null)
          //       ? doctorsBySpecialty[selectedSpecialty]!
          //           .map(
          //               (doc) => DropdownMenuItem(value: doc, child: Text(doc)))
          //           .toList()
          //       : [],
          //   onChanged: (value) {
          //     setState(() => selectedDoctor = value);
          //   },
          // ),
          // const SizedBox(height: 12),
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
          ElevatedButton(
            onPressed: _selectDate,
            child: Text(selectedDate != null
                ? "Date: ${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}"
                : "Pick Date"),
          ),
          const SizedBox(height: 12),
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

          // Row 4: Time Slot Selection using ChoiceChips.
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: List.generate(timeSlots.length, (index) {
          //     return ChoiceChip(
          //       label: Text(timeSlots[index]),
          //       selected: selectedTimeSlotIndex == index,
          //       onSelected: (bool selected) {
          //         setState(() {
          //           selectedTimeSlotIndex = selected ? index : null;
          //         });
          //       },
          //     );
          //   }),
          // ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _bookAppointment,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text(
              "Book Appointment",
              style: TextStyle(color: Colors.white),
            ),
          ),
          // Row 5: Date Picker & "Book Now" Button
          //   Row(
          //     children: [
          //       Expanded(
          //         child: ElevatedButton(
          //           onPressed: _selectDate,
          //           child: Text(selectedDate != null
          //               ? "Date: ${selectedDate!.month}/${selectedDate!.day}"
          //               : "Pick Date"),
          //         ),
          //       ),
          //       const SizedBox(width: 12),
          //       Expanded(
          //         child: ElevatedButton(
          //           onPressed: _bookAppointment,
          //           style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          //           child: const Text(
          //             "Book Now",
          //             style: TextStyle(color: Colors.white),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAppointmentCard(BuildContext context) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
      builder: (context, state) {
        if (state is AppointmentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AppointmentError) {
          return Center(child: Text("Error: ${state.message}"));
        } else if (state is AppointmentLoaded) {
          final appointments = state.appointments;
          if (appointments.isEmpty) {
            return const Center(child: Text("No upcoming appointments"));
          }

          return AppointmentSection(
            title: 'Upcoming Appointments',
            appointments: appointments,
            isUpcoming: true,
            onPrimaryAction: (apt) {
              // TODO: Add reschedule logic here
            },
            onSecondaryAction: (apt) {
              // TODO: Add cancel logic here
            },
          );
        } else if (state is AppointmentInitial) {
          // Explicitly handling the initial state if needed.
          return const Center(child: Text("No upcoming appointments"));
        }

        return const Center(child: Text("No upcoming appointments found."));
      },
    );
  }

  // Widget _buildHistoryAppointmentCard(BuildContext context, appointment) {
  //   return AppointmentSection(
  //     title: 'Upcoming Appointments',
  //     appointments: [Appointment.fromMap(appointment)],
  //     isUpcoming: false,
  //     onPrimaryAction: (apt) {/* reschedule */},
  //     onSecondaryAction: (apt) {/* cancel */},
  //   );
  // }

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

  Widget _buildSpecialityDropdown() {
    return BlocBuilder<SpecialityBloc, SpecialityState>(
      builder: (context, state) {
        if (state is SpecialityLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SpecialityLoaded) {
          final specialties = state.specialities;
          return DropdownButtonFormField<Speciality>(
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
              return DropdownMenuItem<Speciality>(
                value: spec,
                child: Text(spec.specialityName),
              );
            }).toList(),
            onChanged: (Speciality? value) {
              setState(() {
                selectedSpecialty = value;
                selectedDoctor = null; // Reset the doctor selection.
              });
              if (value != null) {
                // Dispatch event to fetch doctors for the selected specialty.
                BlocProvider.of<DoctorBloc>(context).add(
                  FetchDoctors(specialityId: value.specialityId),
                );
              }
            },
          );
        } else if (state is SpecialityError) {
          return Text("Error: ${state.message}");
        } else {
          return const SizedBox(); // Return an empty container for other states.
        }
      },
    );
  }

  Widget _buildDoctorDropdown() {
    return BlocBuilder<DoctorBloc, DoctorState>(
      builder: (context, state) {
        if (state is DoctorLoading) {
          // ✅ Fixed incorrect state check
          return const Center(child: CircularProgressIndicator());
        } else if (state is DoctorLoaded) {
          return DropdownButtonFormField<String>(
            key: UniqueKey(), // ✅ Forces rebuild
            value: selectedDoctor != null &&
                    state.doctors.any((doc) => doc.doctorId == selectedDoctor)
                ? selectedDoctor
                : null, // ✅ Ensures valid selection
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
            items: state.doctors.map((doctor) {
              final doctorName = doctor.user.firstName ?? doctor.doctorId;
              return DropdownMenuItem<String>(
                value: doctor.doctorId,
                child: Text(doctorName),
              );
            }).toList(),
            onChanged: (value) {
              setState(() => selectedDoctor = value);
            },
          );
        } else if (state is DoctorError) {
          return Text("Error: ${state.message}");
        } else {
          return const SizedBox(); // Return an empty container for other states.
        }
      },
    );
  }
}
