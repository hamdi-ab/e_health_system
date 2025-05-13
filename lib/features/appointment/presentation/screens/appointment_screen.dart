import 'package:e_health_system/features/appointment/data/repositories/local_appointment_repository.dart';
import 'package:e_health_system/features/appointment/presentation/blocs/appointment_bloc.dart';
import 'package:e_health_system/features/appointment/presentation/screens/doctors_appointment_screen.dart';
import 'package:e_health_system/features/appointment/presentation/screens/patients_appointment_screen.dart';
import 'package:e_health_system/features/home/data/repositories/local_specialtity_repository.dart';
import 'package:e_health_system/features/home/presentation/bloc/speciality_bloc.dart';
import 'package:e_health_system/features/search/data/repositories/doctor_repository.dart';
import 'package:e_health_system/features/search/data/repositories/patient_repository.dart';
import 'package:e_health_system/features/search/presentation/blocs/doctor_bloc.dart';
import 'package:e_health_system/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentRepository = LocalAppointmentRepository(
      doctorRepository: DoctorRepository(),
      patientRepository: PatientRepository(),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AppointmentBloc>(
          create: (context) => AppointmentBloc(
            appointmentRepository: appointmentRepository,
          ),
        ),
        BlocProvider<SpecialityBloc>(
          create: (context) => SpecialityBloc(
            specialityRepository: LocalSpecialityRepository(),
          ),
        ),
        BlocProvider<DoctorBloc>(
          create: (context) => DoctorBloc(
            doctorRepository: DoctorRepository(),
          ),
        ),
      ],
      child: Scaffold(
        body: isDoctorUser
            ? const DoctorAppointmentScreen()
            : const PatientsAppointmentScreen(),
      ),
    );
  }
}
