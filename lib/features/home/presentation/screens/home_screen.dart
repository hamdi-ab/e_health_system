import 'package:flutter/material.dart';
import 'package:e_health_system/globals.dart' as globals;
import 'doctor_home.dart';
import 'patient_home.dart';

// enum UserRole { doctor, patient }
//
// UserRole userRole = UserRole.patient;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: globals.isDoctorUser ? const DoctorHome() : const PatientHome(),
    );
  }

  // Call this method when the user switches roles
  void updateUserRole(bool isDoctor) {
    setState(() {
      globals.isDoctorUser = isDoctor;
    });
  }
}

