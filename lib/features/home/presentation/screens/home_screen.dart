import 'package:e_health_system/core/constants/app_colors.dart';
import 'package:e_health_system/features/appointment/presentation/screens/appointment_patient_screen.dart';
import 'package:e_health_system/features/auth/Presentation/screens/login_screen.dart';
import 'package:e_health_system/features/auth/Presentation/screens/sign_up_screen.dart';
import 'package:e_health_system/features/chat/presentation/screens/chat_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/doctor_home.dart';
import '../widgets/patient_home.dart';

enum UserRole { doctor, patient }

UserRole userRole = UserRole.patient;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Tracks selected tab

  final List<Widget> _screens = [
    const PatientHome(),
    const DoctorHome(),
    ChatScreen(),
    const AppointmentPatientScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("E~Hospital",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.primary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Remove any default padding.
          padding: EdgeInsets.zero,
          children: [
            // Header Section
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor, // or your preferred color
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                        'assets/images/user_avatar.png'), // Replace with your asset or use NetworkImage
                  ),
                  const SizedBox(height: 8),
                  // User Name
                  const Text(
                    "User Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // User Email
                  const Text(
                    "user.email@example.com",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Menu Options
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text("Profile"),
              onTap: () {
                // Navigate to Profile screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                // Navigate to Settings screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About Us"),
              onTap: () {
                // Navigate to About Us screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("FAQ"),
              onTap: () {
                // Navigate to FAQ screen
              },
            ),
            // Extra spacing before Logout
            const SizedBox(height: 20),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Logout"),
              onTap: () {
                // Handle logout action
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex], // Switches between screens
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Appointments"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "Blog"),
        ],
      ),
    );
  }

  // Drawer Item Widget
  Widget _drawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }
}
