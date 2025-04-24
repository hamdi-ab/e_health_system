import 'package:e_health_system/core/constants/app_colors.dart';
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
    const Center(child: Text("Chat")),
    const Center(child: Text("Blog")),
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
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _drawerItem(Icons.home, "Home", 0),
            _drawerItem(Icons.person, "Profile", 1),
            _drawerItem(Icons.settings, "Settings", 2),
            _drawerItem(Icons.logout, "Logout", 3),
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
