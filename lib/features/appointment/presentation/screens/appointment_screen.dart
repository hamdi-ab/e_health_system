import 'package:e_health_system/features/appointment/presentation/screens/patients_appointment_screen.dart';
import 'package:flutter/material.dart';

import '../../../../globals.dart';
import 'doctors_appointment_screen.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isDoctorUser ? const DoctorAppointmentScreen() : const PatientsAppointmentScreen(),
    );
  }
}
