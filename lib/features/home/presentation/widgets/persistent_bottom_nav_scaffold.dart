// lib/widgets/persistent_bottom_nav_scaffold.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';

class PersistentBottomNavScaffold extends StatefulWidget {
  final Widget child;
  const PersistentBottomNavScaffold({super.key, required this.child});

  @override
  _PersistentBottomNavScaffoldState createState() =>
      _PersistentBottomNavScaffoldState();
}

class _PersistentBottomNavScaffoldState
    extends State<PersistentBottomNavScaffold> {
  int _currentIndex = 0;

  // Define the routes associated with each bottom nav tab.
  final List<String> _routes = [
    '/home',
    '/appointments',
    '/chat',
    '/blog',
  ];

  // Define the corresponding titles for the AppBar.
  final List<String> _titles = [
    'E~Hospital',
    'Appointments',
    'Chat',
    'Blog',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(_titles[_currentIndex],
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Handle notifications
              context.push('/notifications');
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
                color:
                    Theme.of(context).primaryColor, // or your preferred color
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Avatar
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                        'assets/images/user_avatar.png'), // Replace with your asset or use NetworkImage
                  ),
                  SizedBox(height: 8),
                  // User Name
                  Text(
                    "User Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  // User Email
                  Text(
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
                context.push('/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                // Navigate to Settings screen
                context.push('/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text("About Us"),
              onTap: () {
                // Navigate to About Us screen
                context.push('/about-us');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("FAQ"),
              onTap: () {
                // Navigate to FAQ screen
                context.push('/faq');
              },
            ),
            // Extra spacing before Logout
            const SizedBox(height: 20),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Handle logout action
                  context.go('/');
                },
                icon: const Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary, // Using red to emphasize logout
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
              ),
            )
          ],
        ),
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != _currentIndex) {
            setState(() {
              _currentIndex = index;
            });
            // Navigate to the route corresponding to the tapped tab.
            context.go(_routes[index]);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Blog',
          ),
        ],
      ),
    );
  }
}
