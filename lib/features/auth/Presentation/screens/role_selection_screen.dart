import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:e_health_system/features/auth/Presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../globals.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Full-screen layout without an AppBar for a welcome experience.
      backgroundColor: AppColors.surface,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header Text with RichText
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "🩺 Welcome to ",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: "E~Hospital",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Subheading instructions
            Text(
              "Please select your role to continue",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 32),
            // Using Padding for the buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                children: [
                  // Doctor button with new icon.
                  ElevatedButton.icon(
                    onPressed: () {
                      // Set the global variable to true (doctor)
                      isDoctorUser = true;
                      // Navigate to the Login Screen (or another screen)
                      context.push('/sign-in');
                    },
                    icon: const Icon(
                      Icons.local_hospital,
                      size: 28,
                    ),
                    label: const Text(
                      "I am a Doctor",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Patient button with new icon.
                  ElevatedButton.icon(
                    onPressed: () {
                      // Set the global variable to false (patient)
                      isDoctorUser = false;
                      // For example, navigate to the Login Screen (or a separate patient screen)
                      context.push('/sign-in');
                    },
                    icon: const Icon(
                      Icons.person,
                      size: 28,
                    ),
                    label: const Text(
                      "I am a Patient",
                      style: TextStyle(fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
